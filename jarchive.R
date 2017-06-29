library("rvest", lib.loc="~/R/win-library/3.4")

jarchive_page <- read_html("http://www.j-archive.com/showgame.php?game_id=5637")
jarchive_page_responses <- read_html("http://www.j-archive.com/showgameresponses.php?game_id=5637")
jarchive_page_scores <- read_html("http://www.j-archive.com/showscores.php?game_id=5637")

clue_values <- jarchive_page %>%
  html_nodes(".clue_value_daily_double, .clue_value") %>%
  html_text()

clue_values[61] <- "n/a"

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

clue_order_number_dj <- clue_order_number_dj + 30

clue_order_number <- c(clue_order_number_j, clue_order_number_dj)

clue_order_number[61] <- 61

clue_answers <- jarchive_page_responses %>%
  html_nodes(".correct_response") %>%
  html_text()

scores <- jarchive_page_scores %>%
  html_nodes("#jeopardy_round .scores_table") %>%
  html_table(header = TRUE)

scores_dj <- jarchive_page_scores %>%
  html_nodes("#double_jeopardy_round .scores_table") %>%
  html_table(header = TRUE, fill = TRUE)

scores_fj <- jarchive_page_scores %>%
  html_nodes("#final_jeopardy_round table") %>%
  html_table(header = TRUE)


scores <- as.data.frame(scores)
colnames(scores)[1] <- "clue_order_number"
colnames(scores)[5] <- "other"

scores_dj <- as.data.frame(scores_dj)
colnames(scores_dj)[1] <- "clue_order_number"
colnames(scores_dj)[5] <- "other"

scores_fj <- as.data.frame(scores_fj[1])
scores_fj <- scores_fj[1,]
scores_fj["clue_order_number"] <- 61
scores_fj["other"] <- NA

scores_dj$clue_order_number <- scores_dj$clue_order_number + 30

scores <- rbind(scores, scores_dj, scores_fj)

  
j_df<-cbind.data.frame(clue_values, clues, clue_answers, clue_order_number)

j_df["round"] <- NA

j_df$round[clue_order_number <= 30] <- "Jeopardy"
j_df$round[clue_order_number > 30] <- "Double Jeopardy"
j_df$round[clue_order_number = 61] <- "Final Jeopardy"

j_df["category"] <- NA

categories_j <- categories[1:6]
categories_dj <- categories[7:12]
categories_fj <- categories[13]

j_df$category[j_df$round=="Jeopardy"]<- categories_j
j_df$category[j_df$round=="Double Jeopardy"]<- categories_dj
j_df$category[j_df$round=="Final Jeopardy"]<- categories_fj

j_df <- merge(j_df, scores, by="clue_order_number")

write.csv(j_df, "C:/Users/cmckenna/Desktop/j_archive.csv")
View(j_df)