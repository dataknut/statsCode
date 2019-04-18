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

DT[, sum(V1) , V4 == "A"]

DT[, lapply(.SD, mean), by = V4, .SDcols = c("V1", "V2")]

DT[, c(lapply(.SD, sum), lapply(.SD, mean)), by = V4]

cols = names(DT)[sapply(DT, is.numeric)]

DT[, Grp := .GRP, by = .(V4, V1)][]
