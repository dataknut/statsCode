library(ggplot2)
# clever use of a function to add layers - from https://github.com/hadley/ggplot2-book
geom_mean_ci <- function() {
  list(
    stat_summary(fun.y = "mean", geom = "bar", fill = "grey70"),
    stat_summary(fun.data = "mean_cl_normal", geom = "errorbar", width = 0.4) )
}

# compare
ggplot(mpg, aes(class, hwy)) + 
  stat_summary(fun.y = "mean", geom = "bar", fill = "grey70") # bars only

ggplot(mpg, aes(class, hwy)) + geom_mean_ci() # full monty
