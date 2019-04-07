source("clues.R")

final <- create_clues(173)

startEp <- 174
endEp <- 6257

totalEp <- endEp - startEp

#6257 most recent episode

for(id in startEp:endEp){
  
  x <- suppressWarnings(create_clues(id))
  
  if(!is.null(x))
  {
    final <-rbind(final, x)
    cat(sprintf("Episode %s added to data set.\n", id))
  }
  else{
    cat(sprintf("Skipping episode %s. No data returned.\n", id))
  }
  prog <- round(((id - startEp)/totalEp) * 100, 1)
  cat(sprintf("Processed %g%% of all episodes.\n", prog))
}

write.csv(final, file="jeopardy.csv")

View(final)