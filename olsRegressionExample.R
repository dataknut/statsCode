# Code to run & test ols regression models ----
# code by: b.anderson@soton.ak.uk (@dataknut)
# This is a good resource: http://socserv.socsci.mcmaster.ca/jfox/Courses/Brazil-2009/index.html

# R has a very useful built-in dataset called mtcars
# http://stat.ethz.ch/R-manual/R-devel/library/datasets/html/mtcars.html

# A data frame with 32 observations on 11 variables.
# [, 1] 	mpg 	Miles/(US) gallon
# [, 2] 	cyl 	Number of cylinders
# [, 3] 	disp 	Displacement (cu.in.)
# [, 4] 	hp 	Gross horsepower
# [, 5] 	drat 	Rear axle ratio
# [, 6] 	wt 	Weight (1000 lbs)
# [, 7] 	qsec 	1/4 mile time
# [, 8] 	vs 	V/S
# [, 9] 	am 	Transmission (0 = automatic, 1 = manual)
# [,10] 	gear 	Number of forward gears
# [,11] 	carb 	Number of carburetors 

setwd("~/github/StatsCode") # just in case

rm(list = ls()) # clear memory just in case

# Load required packages ----
x <- c("rms", #  regression tools
       "stargazer", # nice reporting of regressions
       "car", # regression tools
       "broom", # for tidying regression results
       "ggplot" # for displaying regression results
       )
       
# do this to install them first if needed
#install.packages(x)
print("Loading required packages")

# be careful - this will return a FALSE if a package doesn't load but the script will NOT stop!
lapply(x, require, character.only = T)


# Load mtcars ----
mtcars <- mtcars

summary(mtcars) # base method
stargazer(mtcars, title = "Descriptive statistics for cars", 
          type="html", out="sgCarsDescriptivesTable.html") # stargazer method

# Examine dataset ----
names(mtcars)
pairs(~mpg+disp+hp+drat+wt,labels=c(
  "Mpg","Displacement","Horse power", 
  "Rear axle rotation","Weight"), data=mtcars, main="Simple Scatterplot Matrix")

# establish normality of mpg (outcome variable of interest)
hist(mtcars$mpg)
qqnorm(mtcars$mpg); qqline(mtcars$mpg, col = 2)

shapiro.test(mtcars$mpg)
# if p > 0.05 => normal 
# is it? Beware: shapiro-wilks is less robust as N -> 

# Model with 1 term predicting mpg ----
# qsec = time to go 1/4 mile from stationary
mpgModel1 <- lm(mpg ~ qsec, mtcars)

# results?
summary(mpgModel1)

# Diagnostics ----

plot(mpgModel1)

# normality of residuals
hist(mpgModel1$residuals)

qqnorm(mpgModel1$residuals); qqline(mpgModel1$residuals, col = 2)

shapiro.test(mpgModel1$residuals)

# it is usual to do these checks for standardised residuals - but the results are the same
# add casewise diagnostics back into dataframe
mtcars$studentised.residuals <- rstudent(mpgModel1)

qqnorm(mtcars$studentised.residuals); qqline(mtcars$studentised.residuals, col = 2)

shapiro.test(mtcars$studentised.residuals)

# if p > 0.05 => normal 
# is it?
# But don't rely on the test espcially with large n

# The 'car' package has some nice graphs to help here
qqPlot(mpgModel1) # shows default 95% CI
spreadLevelPlot(mpgModel1)
# Do we think the variance of the residuals is constant?
# Did the plot suggest a transformation? If so, why?

# autocorrelation/independence of errors
durbinWatsonTest(mpgModel1)
# if p < 0.05 then a problem as implies autocorrelation
# what should we conclude? Why? Could you have spotted that in the model summary?

# homoskedasticity
plot(mtcars$mpg,mpgModel1$residuals)
abline(h = mean(mpgModel1$residuals), col = "red") # add the mean of the residuals (yay, it's zero!)

# formal test
ncvTest(mpgModel1)
# if p > 0.05 then there is heteroskedasticity
# what do we conclude from the tests?

# go back to the model - what can we conclude from it?
summary(mpgModel1)

# Model with more than 1 term ----

# So our model was mostly OK (one violated assumption?) but the r sq was quite low. 
# Maybe we should add the car's weight?

# wt = weight of car
mpgModel2 <- lm(mpg ~ qsec + wt, mtcars)

# results?
summary(mpgModel2)

# Diagnostics ----
# we whould run the same checks e.g.:
qqPlot(mpgModel2) # shows default 95% CI
spreadLevelPlot(mpgModel2)

# but also
# additional assumption checks (now there are 2 predictors)

# collinearity
vif(mpgModel2)
# if any values > 10 -> problem

# tolerance
1/vif(mpgModel2)
# if any values < 0.2 -> possible problem
# if any values < 0.1 -> definitely a problem

# autocorrelation/independence of errors
durbinWatsonTest(mpgModel2)
# if p < 0.05 then a problem as implies autocorrelation

# comparing models
# as a reminder:
summary(mpgModel1)
summary(mpgModel2)

# test significant difference between models
anova(mpgModel1, mpgModel2)
# what should we conclude from that?

# Reporting OLS results with confidence intervals ----
# The p values tell you whether the 'effect' (co-efficient) is statistically significant 
# Only you can decide if it is IMPORTANT!

# It is usually better to calculate and inspect confidence intervals for your estimates
# This indicates:
# - statistical significance (if the CIs do not include 0) - just like the p value
# - precision - the width of the CIs shows you how precise your estimate it

# you can calculate them using the standard error (s.e.) from the summary:
# lower = estimate - (s.e.*1.96) 
# upper = estimate + (s.e.*1.96)
# just like for t tests etc (in fact this _is_ a t test!!)
# Or use confint() which is more precise

# print out the summaries again and calculate 95% confidence intervals each time

# Model 1
# use confint to report confidence intervals with bonferroni corrected level
bc_p1 <- 0.05/length(mpgModel1$coefficients)

# save results as log odds
# the cbind function simply 'glues' the columns together side by side
mpgModel1Results_bf <- cbind(Coef = coef(mpgModel1), # coefficients
                              confint(mpgModel1, level = 1 - bc_p1), # 95% CI
                             Pr = round(summary(mpgModel1)$coefficients[,4], 3) # p value if required
                             )
mpgModel1Results_bf

# Model 2
# use confint to report confidence intervals with bonferroni corrected level
bc_p2 <- 0.05/length(mpgModel2$coefficients)

# save results as log odds
# the cbind function simply 'glues' the columns together side by side
mpgModel2Results_bf <- cbind(Coef = coef(mpgModel2), 
                            confint(mpgModel2, level = 1 - bc_p2))

mpgModel2Results_bf

# Reporting multiple models using stargazer ----
stargazer(mpgModel1, mpgModel2, output = "html", out = "sgCompareModels.html")
