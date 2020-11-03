# Luke Blunden magic:
library(dplyr)
library(janeaustenr)
austen <- austen_books()
for(i in c("tupp","dog")){
  print(with(austen, 
             grep(i,text) %>% text[.])
  )
  }