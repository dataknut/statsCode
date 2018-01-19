# Testing mtcars
Ben Anderson  
Last run at: `r Sys.time()`  



# Test partition by transmission

ggplot visualisation of the model

```r
mtcarsDT <- as.data.table(mtcars)
mtcarsDT <- mtcarsDT[, transmission := factor(am, labels = c("Automatic", "Manual"))]
ggplot(mtcarsDT, aes(x=qsec, y=mpg, color=transmission)) +
    geom_point(shape=1) +    # Use hollow circles
    # theme(legend.position="bottom") +
    geom_smooth(method=lm,
                se = FALSE)   # Add linear regression line 
```

![](testingMtcars_files/figure-html/testPartition-1.png)<!-- -->

```r
                             #  (by default includes 95% confidence region)
```

# Create model estimation results suitable for graphing with 95% CI


```r
mpgModel2 <- lm(mpg ~ qsec + wt, mtcarsDT)

# basic results
summary(mpgModel2)
```

```
## 
## Call:
## lm(formula = mpg ~ qsec + wt, data = mtcarsDT)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -4.3962 -2.1431 -0.2129  1.4915  5.7486 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  19.7462     5.2521   3.760 0.000765 ***
## qsec          0.9292     0.2650   3.506 0.001500 ** 
## wt           -5.0480     0.4840 -10.430 2.52e-11 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2.596 on 29 degrees of freedom
## Multiple R-squared:  0.8264,	Adjusted R-squared:  0.8144 
## F-statistic: 69.03 on 2 and 29 DF,  p-value: 9.395e-12
```

```r
library(broom)    
mpgModel2DF <- tidy(mpgModel2)
mpgModel2DF$ci_lower <- mpgModel2DF$estimate - qnorm(0.975) * mpgModel2DF$std.error
mpgModel2DF$ci_upper <- mpgModel2DF$estimate + qnorm(0.975) * mpgModel2DF$std.error

ggplot(mpgModel2DF, aes(x=term, y=estimate)) + 
    geom_bar(position=position_dodge(), stat="identity", fill = "yellowgreen") +
    geom_errorbar(aes(ymin=ci_lower, ymax=ci_upper),
                  width=.2,                    # Width of the error bars
                  position=position_dodge(.9)
                  )
```

![](testingMtcars_files/figure-html/testPlot1-1.png)<!-- -->

Repeat this but put model 1 beside model 2:


```r
mpgModel1 <- lm(mpg ~ qsec, mtcarsDT)

# basic results
summary(mpgModel1)
```

```
## 
## Call:
## lm(formula = mpg ~ qsec, data = mtcarsDT)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -9.8760 -3.4539 -0.7203  2.2774 11.6491 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)  
## (Intercept)  -5.1140    10.0295  -0.510   0.6139  
## qsec          1.4121     0.5592   2.525   0.0171 *
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 5.564 on 30 degrees of freedom
## Multiple R-squared:  0.1753,	Adjusted R-squared:  0.1478 
## F-statistic: 6.377 on 1 and 30 DF,  p-value: 0.01708
```

```r
mpgModel2 <- lm(mpg ~ qsec + wt, mtcarsDT)

# basic results
summary(mpgModel2)
```

```
## 
## Call:
## lm(formula = mpg ~ qsec + wt, data = mtcarsDT)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -4.3962 -2.1431 -0.2129  1.4915  5.7486 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  19.7462     5.2521   3.760 0.000765 ***
## qsec          0.9292     0.2650   3.506 0.001500 ** 
## wt           -5.0480     0.4840 -10.430 2.52e-11 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2.596 on 29 degrees of freedom
## Multiple R-squared:  0.8264,	Adjusted R-squared:  0.8144 
## F-statistic: 69.03 on 2 and 29 DF,  p-value: 9.395e-12
```

```r
library(broom)    
mpgModel1DF <- tidy(mpgModel1)
mpgModel1DF$ci_lower <- mpgModel1DF$estimate - qnorm(0.975) * mpgModel1DF$std.error
mpgModel1DF$ci_upper <- mpgModel1DF$estimate + qnorm(0.975) * mpgModel1DF$std.error
mpgModel1DF$model <- "Model 1"


mpgModel2DF <- tidy(mpgModel2)
mpgModel2DF$ci_lower <- mpgModel2DF$estimate - qnorm(0.975) * mpgModel2DF$std.error
mpgModel2DF$ci_upper <- mpgModel2DF$estimate + qnorm(0.975) * mpgModel2DF$std.error
mpgModel2DF$model <- "Model 2"

# combine the results
modelsDF <- rbind(mpgModel1DF, mpgModel2DF)

# draw the plots using 'model' to seperate them
plotModels <- ggplot(modelsDF, aes(x = term, y = estimate)) + 
    geom_bar(aes(fill = model), 
             position=position_dodge(), stat="identity") +
    geom_errorbar(aes(ymin=ci_lower, ymax=ci_upper, group = model),
                  width=.2,                    # Width of the error bars
                  colour = "black", # make them visible
                  position=position_dodge(.9)
                  )
plotModels
```

![](testingMtcars_files/figure-html/testPlot2-1.png)<!-- -->

Things to fix:

 * the bar with only one variable in model 2 expands.
 
# Prediction


```r
mtcarsDT$mpgPrediction <- predict(mpgModel2)
ggplot(mtcarsDT, aes(x=wt, y=mpg, color = "Observed")) +
    geom_point(shape=1) +    # Use hollow circles
    # theme(legend.position="bottom") +
    geom_point(aes(y = mpgPrediction, color = "Prediction"))
```

![](testingMtcars_files/figure-html/prediction-1.png)<!-- -->

Next: add some new car observations to the data table and predict their mpg using this model.

