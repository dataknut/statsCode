# test multiple .csv loading
setwd("~/Documents/Work/Data/SAVE/WMG/daily/original/uncompressed/qindex")

filelist <- list.files(pattern = glob2rx("*.csv", trim.head = FALSE, trim.tail = TRUE))
# the following only works if all files valid and same number of columns
testDT = do.call(rbind, lapply(filelist, fread)) # fread is part of data.table
