# selecting data.table columns by wildcard
library(data.table)
testDT <- as.data.table(mtcars)

testDT[, ba_test1 := mpg]
testDT[, ba_test2 := wt]

names(testDT)

keepvars <- c("mpg", "cyl")
testDT[, !grep(c("ba_"), names(testDT)), with = FALSE] # not the ones with ba_* as prefix

testDT[, .(keepvars)]
