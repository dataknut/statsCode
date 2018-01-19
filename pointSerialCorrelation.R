# I have no idea why you would ever want to do this

# http://stackoverflow.com/questions/35880910/point-biserial-and-p-value
# Use class as dichotomous variable (must subset)

geom_mean_ci <- function() {
  list(
    stat_summary(fun.y = "mean", geom = "bar", fill = "grey70"),
    stat_summary(fun.data = "mean_cl_normal", geom = "errorbar", width = 0.4) )
}

library(ggplot2) # to get mpg data
newData = subset(mpg, class == 'midsize' | class == 'subcompact')
ggplot(newData, aes(class, hwy)) + geom_mean_ci()

# Now getting p-value
library(ltm)
polyserial(newData$hwy,newData$class, std.err = T)

