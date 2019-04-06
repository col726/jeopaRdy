library("rvest", lib.loc="~/R/win-library/3.4")

create_clues <- function(episodeID){
  
  jarchive_page <- read_html(paste("http://www.j-archive.com/showgame.php?game_id=",episodeID, sep=''))
  jarchive_page_responses <- read_html(paste("http://www.j-archive.com/showgameresponses.php?game_id=",episodeID, sep=''))
  
  tiebreaker <- FALSE
  
  clue_values <- jarchive_page %>%
    html_nodes(".clue_value_daily_double, .clue_value") %>%
    html_text()
  
  if(length(clue_values) > 0)
  {
    categories <- jarchive_page %>%
      html_nodes(".category_name") %>%
      html_text()
    
    if(length(categories) == 14)
    {
      tiebreaker <- TRUE
      clue_values[length(clue_values) + 1] <- "n/a"
      clue_values[length(clue_values) + 1] <- "n/a"
    }
    else
      clue_values[length(clue_values) + 1] <- "n/a"
    
    
    clues <- jarchive_page %>%
      html_nodes(".clue_text") %>%
      html_text()
    
    categories <- jarchive_page %>%
      html_nodes(".category_name") %>%
      html_text()
    
    clue_order_number_j <- jarchive_page %>%
      html_nodes("#jeopardy_round .clue_order_number") %>%
      html_text() %>%
      as.numeric()
    
    clue_order_number_dj <- jarchive_page %>%
      html_nodes("#double_jeopardy_round .clue_order_number") %>%
      html_text() %>%
      as.numeric()
    
    
    clue_order_number_dj <- clue_order_number_dj + length(clue_order_number_j)
    
    clue_order_number <- c(clue_order_number_j, clue_order_number_dj)
    
    if(tiebreaker)
    {
      clue_order_number[length(clue_order_number) + 1] <- length(clue_order_number) + 1
      clue_order_number[length(clue_order_number) + 1] <- length(clue_order_number) + 1
    }
    else
    {
      clue_order_number[length(clue_order_number) + 1] <- length(clue_order_number) + 1
    }
    
    clue_answers <- jarchive_page_responses %>%
      html_nodes(".correct_response") %>%
      html_text()
    
    clues_df<-cbind.data.frame(clue_values, clues, clue_answers, clue_order_number)
    
    clues_df["round"] <- NA
    
    clues_df$round[clue_order_number <= length(clue_order_number_j)] <- "Jeopardy"
    clues_df$round[clue_order_number > length(clue_order_number_j)] <- "Double Jeopardy"
    if(tiebreaker)
    {
      clues_df$round[clue_order_number == length(clue_order_number) - 1] <- "Final Jeopardy"
      clues_df$round[clue_order_number == length(clue_order_number)] <- "Tiebreaker"
    }
    else
    {
      clues_df$round[clue_order_number == length(clue_order_number)] <- "Final Jeopardy"
    }
    
    clues_df["category"] <- NA
    
    categories_j <- categories[1:6]
    categories_dj <- categories[7:12]
    if(tiebreaker)
    {
      categories_fj <- categories[13]
      categories_tb <- categories[14]
    }
    else
    {
      categories_fj <- categories[13]
    }
    
    
    clues_df$category[clues_df$round=="Jeopardy"]<- categories_j
    clues_df$category[clues_df$round=="Double Jeopardy"]<- categories_dj
    if(tiebreaker)
    {
      clues_df$category[clues_df$round=="Final Jeopardy"]<- categories_fj
      clues_df$category[clues_df$round=="Tiebreaker"]<- categories_tb
    }
    else
    {
      clues_df$category[clues_df$round=="Final Jeopardy"]<- categories_fj
    }
    
    
    clues_df["jid"] <-(episodeID * 100) + clues_df["clue_order_number"]
    
    return(clues_df)
  }
  
  return(NULL)
}