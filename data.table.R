# see https://atrebas.github.io/post/2019-03-03-datatable-dplyr/#summarise-data
library(data.table)
set.seed(1L)

## Create a data table
DT = data.table(V1 = c(1L,2L),  # recycling
                V2 = 1:9,
                V3 = round(rnorm(3),2),
                V4 = LETTERS[1:3])

class(DT)
DT

DT[, sum(V1) , V4 == "A"] # sum V1 where V4 = "A" and also where it does not
# compare:
DT[V4 == "A", sum(V1)]

DT[, lapply(.SD, mean), by = V4, .SDcols = c("V1", "V2")] # apply function to two columns (V1 & V2) by V4

DT[, c(lapply(.SD, sum), lapply(.SD, mean)), by = V4] # same but two functions. Not the resulting cols are not helpfully labelled

cols = names(DT)[sapply(DT, is.numeric)] # select columns which are numeric (and then do something with them)

DT[, Grp := .GRP, by = .(V4, V1)] # make a grouping variable on unique combinations of V4 & V1

# selecting data.table columns by wildcard
testDT <- as.data.table(mtcars)

testDT[, ba_test1 := mpg]
testDT[, ba_test2 := wt]

names(testDT)

testDT[, grep(c("ba_"), names(testDT)), with = FALSE] # ones with ba_* as prefix

testDT[, !grep(c("ba_"), names(testDT)), with = FALSE] # not the ones with ba_* as prefix

# you can do this another way...
myfun <- function(x){
  return(mean(x))
}
testDT[, .SDcols = patterns('^ba_'), # names of cols
       keyby = gear, # sorts the group
       lapply(.SD, myfun) # what to do
       ] 
