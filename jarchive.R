source("clues.R")

x <- create_clues(5870)

View(x)


# jarchive_page_scores <- read_html(paste("http://www.j-archive.com/showscores.php?game_id=", episodeID, sep=''))
# 
#   scores <- jarchive_page_scores %>%
#     html_nodes("#jeopardy_round .scores_table") %>%
#     html_table(header = TRUE)
#   
#   scores_dj <- jarchive_page_scores %>%
#     html_nodes("#double_jeopardy_round .scores_table") %>%
#     html_table(header = TRUE, fill = TRUE)
#   
#   scores_fj <- jarchive_page_scores %>%
#     html_nodes("#final_jeopardy_round table") %>%
#     html_table(header = TRUE)
#   
#   
#   scores <- as.data.frame(scores)
#   colnames(scores)[1] <- "clue_order_number"
#   colnames(scores)[5] <- "other"
#   
#   scores_dj <- as.data.frame(scores_dj)
#   colnames(scores_dj)[1] <- "clue_order_number"
#   colnames(scores_dj)[5] <- "other"
#   
#   scores_fj <- as.data.frame(scores_fj[1])
#   scores_fj <- scores_fj[1,]
#   scores_fj["clue_order_number"] <- length(clue_order_number)
#   scores_fj["other"] <- NA
#   
#   scores_dj$clue_order_number <- scores_dj$clue_order_number + length(clue_order_number_j)
#   
#   scores_df <- rbind(scores, scores_dj, scores_fj)
#     
#   j_df <- merge(clues_df, scores_df, by="clue_order_number")
#   
#   write.csv(j_df, "j_archive.csv")
#   View(j_df)
# }