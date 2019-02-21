---
title: "OLS Regression modeling in R"
author: Ben Anderson (b.anderson@soton.ac.uk, `@dataknut`)
date: 'Last run at: 2019-02-22 12:40:49'
output:
  html_document:
    keep_md: yes
    number_sections: yes
    self_contained: no
    toc: yes
    toc_depth: 4
    toc_float: yes
  pdf_document:
    number_sections: yes
    toc: yes
    toc_depth: 4
    toc_float: yes
  word_document:
    fig_caption: yes
    toc: yes
    toc_depth: 4
bibliography: '/Users/ben/bibliography.bib'
---




# Why are we here?

To learn how to do ols regression modelling in R (markdown) and specifically how to use broom [@broom] and car [@car] for diagnostics, stargazer [@stargazer] for model tables, data.table [@data.table] for data manipulation and ggplot [@ggplot2] for results visualisation. 

For more on regression try: http://socserv.socsci.mcmaster.ca/jfox/Courses/Brazil-2009/index.html 

So many birds and just one stone...


```r
# R has a very useful built-in dataset called mtcars
# http://stat.ethz.ch/R-manual/R-devel/library/datasets/html/mtcars.html

# A data frame with 32 observations on 11 variables.  [, 1] mpg Miles/(US)
# gallon [, 2] cyl Number of cylinders [, 3] disp Displacement (cu.in.)  [,
# 4] hp Gross horsepower [, 5] drat Rear axle ratio [, 6] wt Weight (1000
# lbs) [, 7] qsec 1/4 mile time [, 8] vs V/S [, 9] am Transmission (0 =
# automatic, 1 = manual) [,10] gear Number of forward gears [,11] carb
# Number of carburetors


# Load mtcars ----
mtcars <- mtcars

summary(mtcars)  # base method
```

```
##       mpg             cyl             disp             hp       
##  Min.   :10.40   Min.   :4.000   Min.   : 71.1   Min.   : 52.0  
##  1st Qu.:15.43   1st Qu.:4.000   1st Qu.:120.8   1st Qu.: 96.5  
##  Median :19.20   Median :6.000   Median :196.3   Median :123.0  
##  Mean   :20.09   Mean   :6.188   Mean   :230.7   Mean   :146.7  
##  3rd Qu.:22.80   3rd Qu.:8.000   3rd Qu.:326.0   3rd Qu.:180.0  
##  Max.   :33.90   Max.   :8.000   Max.   :472.0   Max.   :335.0  
##       drat             wt             qsec             vs        
##  Min.   :2.760   Min.   :1.513   Min.   :14.50   Min.   :0.0000  
##  1st Qu.:3.080   1st Qu.:2.581   1st Qu.:16.89   1st Qu.:0.0000  
##  Median :3.695   Median :3.325   Median :17.71   Median :0.0000  
##  Mean   :3.597   Mean   :3.217   Mean   :17.85   Mean   :0.4375  
##  3rd Qu.:3.920   3rd Qu.:3.610   3rd Qu.:18.90   3rd Qu.:1.0000  
##  Max.   :4.930   Max.   :5.424   Max.   :22.90   Max.   :1.0000  
##        am              gear            carb      
##  Min.   :0.0000   Min.   :3.000   Min.   :1.000  
##  1st Qu.:0.0000   1st Qu.:3.000   1st Qu.:2.000  
##  Median :0.0000   Median :4.000   Median :2.000  
##  Mean   :0.4062   Mean   :3.688   Mean   :2.812  
##  3rd Qu.:1.0000   3rd Qu.:4.000   3rd Qu.:4.000  
##  Max.   :1.0000   Max.   :5.000   Max.   :8.000
```

# Examine dataset


```r
names(mtcars)
```

```
##  [1] "mpg"  "cyl"  "disp" "hp"   "drat" "wt"   "qsec" "vs"   "am"   "gear"
## [11] "carb"
```

```r
pairs(~mpg + disp + hp + drat + wt, labels = c("Mpg", "Displacement", "Horse power", 
    "Rear axle rotation", "Weight"), data = mtcars, main = "Simple Scatterplot Matrix")
```

![](olsRegressionExample_files/figure-html/examine data-1.png)<!-- -->

Test normality of mpg (outcome variable of interest) as linear models rest on this assumption (and quite a few others...).


```r
# test with a histogram
hist(mtcars$mpg)
```

![](olsRegressionExample_files/figure-html/normality-1.png)<!-- -->

```r
# test with a qq plot
qqnorm(mtcars$mpg)
qqline(mtcars$mpg, col = 2)
```

![](olsRegressionExample_files/figure-html/normality-2.png)<!-- -->

```r
shapiro.test(mtcars$mpg)
```

```
## 
## 	Shapiro-Wilk normality test
## 
## data:  mtcars$mpg
## W = 0.94756, p-value = 0.1229
```

```r
# if p > 0.05 => normal

# is it? Beware: shapiro-wilks is less robust as N ->
```

Mpg seems to approximate normality but with a slightly worrying tail effect at the right hand extreme.

# Model with 1 term predicting mpg

Run a model trying to see if qsec predicts mpg. This will print out a basic table of results.


```r
# qsec = time to go 1/4 mile from stationary
mpgModel1 <- lm(mpg ~ qsec, mtcars)

# results?
summary(mpgModel1)
```

```
## 
## Call:
## lm(formula = mpg ~ qsec, data = mtcars)
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

Now run the standard diagnostics over the model results.


```r
# Diagnostics ----

message("# Diagnostic plots")

plot(mpgModel1)
```

![](olsRegressionExample_files/figure-html/model.1.diag-1.png)<!-- -->![](olsRegressionExample_files/figure-html/model.1.diag-2.png)<!-- -->![](olsRegressionExample_files/figure-html/model.1.diag-3.png)<!-- -->![](olsRegressionExample_files/figure-html/model.1.diag-4.png)<!-- -->

```r
message("# Normality of residuals")

hist(mpgModel1$residuals)
```

![](olsRegressionExample_files/figure-html/model.1.diag-5.png)<!-- -->

```r
qqnorm(mpgModel1$residuals)
qqline(mpgModel1$residuals, col = 2)
```

![](olsRegressionExample_files/figure-html/model.1.diag-6.png)<!-- -->

```r
shapiro.test(mpgModel1$residuals)
```

```
## 
## 	Shapiro-Wilk normality test
## 
## data:  mpgModel1$residuals
## W = 0.94193, p-value = 0.08494
```

```r
message("# Normality of standardised residuals")

# it is usual to do these checks for standardised residuals - but the
# results are the same add casewise diagnostics back into dataframe
mtcars$studentised.residuals <- rstudent(mpgModel1)

qqnorm(mtcars$studentised.residuals)
qqline(mtcars$studentised.residuals, col = 2)
```

![](olsRegressionExample_files/figure-html/model.1.diag-7.png)<!-- -->

```r
shapiro.test(mtcars$studentised.residuals)
```

```
## 
## 	Shapiro-Wilk normality test
## 
## data:  mtcars$studentised.residuals
## W = 0.93996, p-value = 0.07469
```

```r
# if p > 0.05 => normal is it?  But don't rely on the test espcially with
# large n
```

Now try using the car package [@car] to do the same things.


```r
# The 'car' package has some nice graphs to help here
car::qqPlot(mpgModel1)  # shows default 95% CI
```

![](olsRegressionExample_files/figure-html/model.1.diag.car-1.png)<!-- -->

```
## Toyota Corolla   Lotus Europa 
##             20             28
```

```r
car::spreadLevelPlot(mpgModel1)
```

![](olsRegressionExample_files/figure-html/model.1.diag.car-2.png)<!-- -->

```
## 
## Suggested power transformation:  -1.490415
```

```r
message("# Do we think the variance of the residuals is constant?")
message("# Did the plot suggest a transformation? If so, why?")

message("# autocorrelation/independence of errors")
car::durbinWatsonTest(mpgModel1)
```

```
##  lag Autocorrelation D-W Statistic p-value
##    1       0.5922771     0.8065068       0
##  Alternative hypothesis: rho != 0
```

```r
# if p < 0.05 then a problem as implies autocorrelation what should we
# conclude? Why? Could you have spotted that in the model summary?

message("# homoskedasticity")
plot(mtcars$mpg, mpgModel1$residuals)
abline(h = mean(mpgModel1$residuals), col = "red")  # add the mean of the residuals (yay, it's zero!)
```

![](olsRegressionExample_files/figure-html/model.1.diag.car-3.png)<!-- -->

```r
message("# homoskedasticity: formal test")
car::ncvTest(mpgModel1)
```

```
## Non-constant Variance Score Test 
## Variance formula: ~ fitted.values 
## Chisquare = 0.956535, Df = 1, p = 0.32806
```

```r
# if p > 0.05 then there is heteroskedasticity what do we conclude from the
# tests?
```

go back to the model - what can we conclude from it?


```r
summary(mpgModel1)
```

```
## 
## Call:
## lm(formula = mpg ~ qsec, data = mtcars)
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

There are an infinite number of ways to report regression model results and every journal has it's own. We look at this in detail below using stargazer [@stargazer] but the [guidance here](https://www.csus.edu/indiv/v/vangaasbeckk/courses/200a/sup/regressionresults.pdf) is also quite useful.

# Model with more than 1 term

So our model was mostly OK (one violated assumption?) but the r sq was quite low. 

Maybe we should add the car's weight?


```r
# wt = weight of car
mpgModel2 <- lm(mpg ~ qsec + wt, mtcars)

# results?
summary(mpgModel2)
```

```
## 
## Call:
## lm(formula = mpg ~ qsec + wt, data = mtcars)
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

Run diagnostics.


```r
# Diagnostics ----

car::qqPlot(mpgModel2)  # shows default 95% CI
```

![](olsRegressionExample_files/figure-html/model.2.diag-1.png)<!-- -->

```
## Chrysler Imperial          Fiat 128 
##                17                18
```

```r
car::spreadLevelPlot(mpgModel2)
```

![](olsRegressionExample_files/figure-html/model.2.diag-2.png)<!-- -->

```
## 
## Suggested power transformation:  0.4388755
```

```r
message("# Do we think the variance of the residuals is constant?")
message("# Did the plot suggest a transformation? If so, why?")

message("# autocorrelation/independence of errors")
car::durbinWatsonTest(mpgModel2)
```

```
##  lag Autocorrelation D-W Statistic p-value
##    1       0.2438102       1.49595   0.114
##  Alternative hypothesis: rho != 0
```

```r
# if p < 0.05 then a problem as implies autocorrelation what should we
# conclude? Why? Could you have spotted that in the model summary?

message("# homoskedasticity")
plot(mtcars$mpg, mpgModel2$residuals)
abline(h = mean(mpgModel2$residuals), col = "red")  # add the mean of the residuals (yay, it's zero!)
```

![](olsRegressionExample_files/figure-html/model.2.diag-3.png)<!-- -->

```r
message("# homoskedasticity: formal test")
car::ncvTest(mpgModel2)
```

```
## Non-constant Variance Score Test 
## Variance formula: ~ fitted.values 
## Chisquare = 0.590986, Df = 1, p = 0.44204
```

```r
# if p > 0.05 then there is heteroskedasticity

# but also
message("# additional assumption checks (now there are 2 predictors)")

message("# -> collinearity")
car::vif(mpgModel2)
```

```
##     qsec       wt 
## 1.031487 1.031487
```

```r
# if any values > 10 -> problem

message("# -> tolerance")
1/car::vif(mpgModel2)
```

```
##      qsec        wt 
## 0.9694744 0.9694744
```

```r
# if any values < 0.2 -> possible problem if any values < 0.1 -> definitely
# a problem

# what do we conclude from the tests?
```

Whilst we're here we should also plot the residuals for model 2 against the fitted values (as opposed to the observed values which we did earlier). h/t to https://gist.github.com/apreshill/9d33891b5f9be4669ada20f76f101baa for this.


```r
# save the residuals via broom
resids <- augment(mpgModel2)

# plot fitted vs residuals
ggplot(resids, aes(x = .fitted, y = .resid)) + geom_point(size = 1)
```

![](olsRegressionExample_files/figure-html/model.2.plot.residuals-1.png)<!-- -->

As with a plot of residuals against observed values, hopefully we didn't see any obviously strange patterns (unlike that [gist](https://gist.github.com/apreshill/9d33891b5f9be4669ada20f76f101baa)).

Now compare the models


```r
# comparing models

message("# test significant difference between models")
anova(mpgModel1, mpgModel2)
```

```
## Analysis of Variance Table
## 
## Model 1: mpg ~ qsec
## Model 2: mpg ~ qsec + wt
##   Res.Df    RSS Df Sum of Sq      F    Pr(>F)    
## 1     30 928.66                                  
## 2     29 195.46  1    733.19 108.78 2.519e-11 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

```r
# what should we conclude from that?
```


# Reporting OLS results with confidence intervals

Reporting should include coefficients, p values and confidence intervals for factors in each model as well as regression diagnostics so that readers can judge the goodness of fit and uncertainty for themselves (see https://amstat.tandfonline.com/doi/full/10.1080/00031305.2016.1154108 for guidance and also https://www.csus.edu/indiv/v/vangaasbeckk/courses/200a/sup/regressionresults.pdf – with the addition of e.g. 95% confidence intervals to the tables).

The p values tell you whether the 'effect' (co-efficient) is statistically significant at a given confidence threshold. By convention this is usually one of p < 0.05 (5%), p < 0.01 (1%), or p < 0.001 (0.1%). Sometimes, this is (justifiably) relaxed to p < 0.1 (10%) for example. The choice of which to use is normative and driven by your [appetite for Type 1 & Type 2 error risks](https://git.soton.ac.uk/ba1e12/weGotThePower) and the uses to which you will put the results.

But only _you_ can decide if it is IMPORTANT!

It is usually best to calculate and inspect confidence intervals for your estimates alongside the p values.

This indicates:

 * statistical significance (if the CIs do not include 0) - just like the p value
 * precision - the width of the CIs shows you how precise your estimate is

You can calculate them using the standard error (s.e.) from the summary:

 * lower = estimate - (s.e.*1.96) 
 * upper = estimate + (s.e.*1.96)
 * just like for t tests etc (in fact this _is_ a t test!!)

Or use `confint()` which is more precise.

Print out the summaries again and calculate 95% confidence intervals and p values each time. 


```r
# Model 1 save results as log odds the cbind function simply 'glues' the
# columns together side by side
mpgModel1Results_CI <- cbind(Coef = coef(mpgModel1), confint(mpgModel1), p = round(summary(mpgModel1)$coefficients[, 
    4], 3))
mpgModel1Results_CI
```

```
##                  Coef       2.5 %    97.5 %     p
## (Intercept) -5.114038 -25.5970982 15.369022 0.614
## qsec         1.412125   0.2700654  2.554184 0.017
```

Notice that where p < 0.05 our 95% CI does not include 0. These tell you the same thing: that with a 95% threshold, the coefficient's differnece from 0 is statistically significant. Notice this is not the case for the constant (Intercept).

Now we do that again but for extra practice we use a bonferroni correction to take into account the number of predictors we used. As with most things in statistics, there is active debate about the use of this...


```r
# Model 1 bf use confint to report confidence intervals with bonferroni
# corrected level
bc_p1 <- 0.05/length(mpgModel1$coefficients)

# save results as log odds the cbind function simply 'glues' the columns
# together side by side
mpgModel1Results_bf <- cbind(Coef = coef(mpgModel1), confint(mpgModel1, level = 1 - 
    bc_p1), p = round(summary(mpgModel1)$coefficients[, 4], 3))
mpgModel1Results_bf
```

```
##                  Coef       1.25 %   98.75 %     p
## (Intercept) -5.114038 -28.77937200 18.551296 0.614
## qsec         1.412125   0.09263361  2.731616 0.017
```

The coefficient has not change (of course) and nor has the default p value produced by the original lm model but our confidence intervals have been adjusted. You can see that we are now using the more stringent 2.5% and the intervals are wider. We would still conclude there is a statistically significant effect at this threshold but we are a bit less certain.

> Is that the right interpretation?

Now do the same for model 2.


```r
# Model 2 bf use confint to report confidence intervals with bonferroni
# corrected level
bc_p2 <- 0.05/length(mpgModel2$coefficients)

# save results as log odds the cbind function simply 'glues' the columns
# together side by side
mpgModel2Results_bf <- cbind(Coef = coef(mpgModel2), confint(mpgModel2, level = 1 - 
    bc_p2), p = round(summary(mpgModel2)$coefficients[, 4], 3))

mpgModel2Results_bf
```

```
##                  Coef    0.833 %  99.167 %     p
## (Intercept) 19.746223  6.4012162 33.091229 0.001
## qsec         0.929198  0.2558134  1.602583 0.001
## wt          -5.047982 -6.2777749 -3.818189 0.000
```

# Reporting with Stargazer

Now we'll try reporting the two model using the stargazer package [@stargazer] to get pretty tables. Note we use options to automatically create the 95% CI and to report the results on just one line per predictor. This is especially helpful for models with a lot of variables. However you will see that the default is to report p values as *.


```r
stargazer(mpgModel1, mpgModel2, title = "Model results", ci = TRUE, single.row = TRUE, 
    type = "html")
```


<table style="text-align:center"><caption><strong>Model results</strong></caption>
<tr><td colspan="3" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left"></td><td colspan="2"><em>Dependent variable:</em></td></tr>
<tr><td></td><td colspan="2" style="border-bottom: 1px solid black"></td></tr>
<tr><td style="text-align:left"></td><td colspan="2">mpg</td></tr>
<tr><td style="text-align:left"></td><td>(1)</td><td>(2)</td></tr>
<tr><td colspan="3" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">qsec</td><td>1.412<sup>**</sup> (0.316, 2.508)</td><td>0.929<sup>***</sup> (0.410, 1.449)</td></tr>
<tr><td style="text-align:left">wt</td><td></td><td>-5.048<sup>***</sup> (-5.997, -4.099)</td></tr>
<tr><td style="text-align:left">Constant</td><td>-5.114 (-24.772, 14.544)</td><td>19.746<sup>***</sup> (9.452, 30.040)</td></tr>
<tr><td colspan="3" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">Observations</td><td>32</td><td>32</td></tr>
<tr><td style="text-align:left">R<sup>2</sup></td><td>0.175</td><td>0.826</td></tr>
<tr><td style="text-align:left">Adjusted R<sup>2</sup></td><td>0.148</td><td>0.814</td></tr>
<tr><td style="text-align:left">Residual Std. Error</td><td>5.564 (df = 30)</td><td>2.596 (df = 29)</td></tr>
<tr><td style="text-align:left">F Statistic</td><td>6.377<sup>**</sup> (df = 1; 30)</td><td>69.033<sup>***</sup> (df = 2; 29)</td></tr>
<tr><td colspan="3" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left"><em>Note:</em></td><td colspan="2" style="text-align:right"><sup>*</sup>p<0.1; <sup>**</sup>p<0.05; <sup>***</sup>p<0.01</td></tr>
</table>


We can add the p values using stargazer options. Note that this puts them under the 95% CI - we may want them in a new column.



```r
stargazer(mpgModel1, mpgModel2, title = "Model results", ci = TRUE, report = c("vcsp*"), 
    single.row = TRUE, type = "html")
```


<table style="text-align:center"><caption><strong>Model results</strong></caption>
<tr><td colspan="3" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left"></td><td colspan="2"><em>Dependent variable:</em></td></tr>
<tr><td></td><td colspan="2" style="border-bottom: 1px solid black"></td></tr>
<tr><td style="text-align:left"></td><td colspan="2">mpg</td></tr>
<tr><td style="text-align:left"></td><td>(1)</td><td>(2)</td></tr>
<tr><td colspan="3" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">qsec</td><td>1.412 (0.316, 2.508)</td><td>0.929 (0.410, 1.449)</td></tr>
<tr><td style="text-align:left"></td><td>p = 0.018<sup>**</sup></td><td>p = 0.002<sup>***</sup></td></tr>
<tr><td style="text-align:left">wt</td><td></td><td>-5.048 (-5.997, -4.099)</td></tr>
<tr><td style="text-align:left"></td><td></td><td>p = 0.000<sup>***</sup></td></tr>
<tr><td style="text-align:left">Constant</td><td>-5.114 (-24.772, 14.544)</td><td>19.746 (9.452, 30.040)</td></tr>
<tr><td style="text-align:left"></td><td>p = 0.614</td><td>p = 0.001<sup>***</sup></td></tr>
<tr><td colspan="3" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">Observations</td><td>32</td><td>32</td></tr>
<tr><td style="text-align:left">R<sup>2</sup></td><td>0.175</td><td>0.826</td></tr>
<tr><td style="text-align:left">Adjusted R<sup>2</sup></td><td>0.148</td><td>0.814</td></tr>
<tr><td style="text-align:left">Residual Std. Error</td><td>5.564 (df = 30)</td><td>2.596 (df = 29)</td></tr>
<tr><td style="text-align:left">F Statistic</td><td>6.377<sup>**</sup> (df = 1; 30)</td><td>69.033<sup>***</sup> (df = 2; 29)</td></tr>
<tr><td colspan="3" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left"><em>Note:</em></td><td colspan="2" style="text-align:right"><sup>*</sup>p<0.1; <sup>**</sup>p<0.05; <sup>***</sup>p<0.01</td></tr>
</table>

## Stargazer style options

Stargazer can simulate a range of journal output formats.

Let's start with 'all' which prints everything. This is quite good for your first model report but probably wouldn't go in an article.


```r
stargazer(mpgModel1, mpgModel2, title = "Model results", ci = TRUE, style = "all", 
    single.row = TRUE, type = "html")
```


<table style="text-align:center"><caption><strong>Model results</strong></caption>
<tr><td colspan="3" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left"></td><td colspan="2"><em>Dependent variable:</em></td></tr>
<tr><td></td><td colspan="2" style="border-bottom: 1px solid black"></td></tr>
<tr><td style="text-align:left"></td><td colspan="2">mpg</td></tr>
<tr><td style="text-align:left"></td><td>(1)</td><td>(2)</td></tr>
<tr><td colspan="3" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">qsec</td><td>1.412<sup>**</sup> (0.316, 2.508)</td><td>0.929<sup>***</sup> (0.410, 1.449)</td></tr>
<tr><td style="text-align:left"></td><td>t = 2.525</td><td>t = 3.506</td></tr>
<tr><td style="text-align:left"></td><td>p = 0.018</td><td>p = 0.002</td></tr>
<tr><td style="text-align:left">wt</td><td></td><td>-5.048<sup>***</sup> (-5.997, -4.099)</td></tr>
<tr><td style="text-align:left"></td><td></td><td>t = -10.430</td></tr>
<tr><td style="text-align:left"></td><td></td><td>p = 0.000</td></tr>
<tr><td style="text-align:left">Constant</td><td>-5.114 (-24.772, 14.544)</td><td>19.746<sup>***</sup> (9.452, 30.040)</td></tr>
<tr><td style="text-align:left"></td><td>t = -0.510</td><td>t = 3.760</td></tr>
<tr><td style="text-align:left"></td><td>p = 0.614</td><td>p = 0.001</td></tr>
<tr><td colspan="3" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">Observations</td><td>32</td><td>32</td></tr>
<tr><td style="text-align:left">R<sup>2</sup></td><td>0.175</td><td>0.826</td></tr>
<tr><td style="text-align:left">Adjusted R<sup>2</sup></td><td>0.148</td><td>0.814</td></tr>
<tr><td style="text-align:left">Residual Std. Error</td><td>5.564 (df = 30)</td><td>2.596 (df = 29)</td></tr>
<tr><td style="text-align:left">F Statistic</td><td>6.377<sup>**</sup> (df = 1; 30) (p = 0.018)</td><td>69.033<sup>***</sup> (df = 2; 29) (p = 0.000)</td></tr>
<tr><td colspan="3" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left"><em>Note:</em></td><td colspan="2" style="text-align:right"><sup>*</sup>p<0.1; <sup>**</sup>p<0.05; <sup>***</sup>p<0.01</td></tr>
</table>

### American Economic Review

Now let's try American Economic Review.


```r
stargazer(mpgModel1, mpgModel2, title = "Model results", ci = TRUE, style = "aer", 
    single.row = TRUE, type = "html")
```


<table style="text-align:center"><caption><strong>Model results</strong></caption>
<tr><td colspan="3" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left"></td><td colspan="2">mpg</td></tr>
<tr><td style="text-align:left"></td><td>(1)</td><td>(2)</td></tr>
<tr><td colspan="3" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">qsec</td><td>1.412<sup>**</sup> (0.316, 2.508)</td><td>0.929<sup>***</sup> (0.410, 1.449)</td></tr>
<tr><td style="text-align:left">wt</td><td></td><td>-5.048<sup>***</sup> (-5.997, -4.099)</td></tr>
<tr><td style="text-align:left">Constant</td><td>-5.114 (-24.772, 14.544)</td><td>19.746<sup>***</sup> (9.452, 30.040)</td></tr>
<tr><td style="text-align:left">Observations</td><td>32</td><td>32</td></tr>
<tr><td style="text-align:left">R<sup>2</sup></td><td>0.175</td><td>0.826</td></tr>
<tr><td style="text-align:left">Adjusted R<sup>2</sup></td><td>0.148</td><td>0.814</td></tr>
<tr><td style="text-align:left">Residual Std. Error</td><td>5.564 (df = 30)</td><td>2.596 (df = 29)</td></tr>
<tr><td style="text-align:left">F Statistic</td><td>6.377<sup>**</sup> (df = 1; 30)</td><td>69.033<sup>***</sup> (df = 2; 29)</td></tr>
<tr><td colspan="3" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left"><em>Notes:</em></td><td colspan="2" style="text-align:left"><sup>***</sup>Significant at the 1 percent level.</td></tr>
<tr><td style="text-align:left"></td><td colspan="2" style="text-align:left"><sup>**</sup>Significant at the 5 percent level.</td></tr>
<tr><td style="text-align:left"></td><td colspan="2" style="text-align:left"><sup>*</sup>Significant at the 10 percent level.</td></tr>
</table>

### Demography

Or perhaps Demography.


```r
stargazer(mpgModel1, mpgModel2, title = "Model results", ci = TRUE, style = "demography", 
    single.row = TRUE, type = "html")
```


<table style="text-align:center"><caption><strong>Model results</strong></caption>
<tr><td colspan="3" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left"></td><td colspan="2">mpg</td></tr>
<tr><td style="text-align:left"></td><td>Model 1</td><td>Model 2</td></tr>
<tr><td colspan="3" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">qsec</td><td>1.412<sup>*</sup> (0.316, 2.508)</td><td>0.929<sup>**</sup> (0.410, 1.449)</td></tr>
<tr><td style="text-align:left">wt</td><td></td><td>-5.048<sup>***</sup> (-5.997, -4.099)</td></tr>
<tr><td style="text-align:left">Constant</td><td>-5.114 (-24.772, 14.544)</td><td>19.746<sup>***</sup> (9.452, 30.040)</td></tr>
<tr><td style="text-align:left"><em>N</em></td><td>32</td><td>32</td></tr>
<tr><td style="text-align:left">R<sup>2</sup></td><td>0.175</td><td>0.826</td></tr>
<tr><td style="text-align:left">Adjusted R<sup>2</sup></td><td>0.148</td><td>0.814</td></tr>
<tr><td style="text-align:left">Residual Std. Error</td><td>5.564 (df = 30)</td><td>2.596 (df = 29)</td></tr>
<tr><td style="text-align:left">F Statistic</td><td>6.377<sup>*</sup> (df = 1; 30)</td><td>69.033<sup>***</sup> (df = 2; 29)</td></tr>
<tr><td colspan="3" style="border-bottom: 1px solid black"></td></tr><tr><td colspan="3" style="text-align:left"><sup>*</sup>p < .05; <sup>**</sup>p < .01; <sup>***</sup>p < .001</td></tr>
</table>

# Visualise results using ggplot

Now we'll visualise them using broom and ggplot as we've found that non-statisticians can interpret plots more easily. This is especially useful for showing what the 95% confidence intervals 'mean'.

Just to confuse you we're going to convert the data frames to data.tables [@data.table]. It makes little difference here but data.table is good to get to know for `data science`.

We use the data table (you could use a data frame)


```r
# Broom converts the model results into a data frame (very useful!)
mpgModel1DT <- as.data.table(tidy(mpgModel1))

# add the 95% CI
mpgModel1DT$ci_lower <- mpgModel1DT$estimate - qnorm(0.975) * mpgModel1DT$std.error
mpgModel1DT$ci_upper <- mpgModel1DT$estimate + qnorm(0.975) * mpgModel1DT$std.error
mpgModel1DT <- mpgModel1DT[, `:=`(model, "Model 1")]  # add model label for ggplot to pick up

# repeat for model 2
mpgModel2DT <- as.data.table(tidy(mpgModel2))
mpgModel2DT$ci_lower <- mpgModel2DT$estimate - qnorm(0.975) * mpgModel2DT$std.error
mpgModel2DT$ci_upper <- mpgModel2DT$estimate + qnorm(0.975) * mpgModel2DT$std.error
mpgModel2DT <- mpgModel2DT[, `:=`(model, "Model 2")]  # add model label for ggplot to pick up

# rbind the data tables so you have long form data
modelsDT <- rbind(mpgModel1DT, mpgModel2DT)

# plot the coefficients using colour to distinguish the models and plot the
# 95% CIs
ggplot(modelsDT, aes(x = term, y = estimate, fill = model)) + geom_bar(position = position_dodge(), 
    stat = "identity") + geom_errorbar(aes(ymin = ci_lower, ymax = ci_upper), 
    width = 0.2, position = position_dodge(0.9)) + labs(title = "Model results", 
    x = "Variable", y = "Coefficient", caption = paste0("Model 1 & 2 results, Error bars = 95% CI", 
        "\n Data: mtcars")) + coord_flip()  # rotate for legibility
```

![](olsRegressionExample_files/figure-html/visualise models-1.png)<!-- -->

So now we can easily 'see' and interpret our results.

# About

## Runtime

Analysis completed in: 5.59 seconds using [knitr](https://cran.r-project.org/package=knitr) in [RStudio](http://www.rstudio.com) with R version 3.5.1 (2018-07-02) running on x86_64-apple-darwin15.6.0.

R packages used (rms, stargazer, car, broom, ggplot2, data.table):

 * base R - for the basics [@baseR]
 * ggplot2 - for slick graphics [@ggplot2]
 * car - for regression diagnostics [@car]
 * broom - for tidy model results [@broom]
 * data.table - for fast data manipulation [@data.table]
 * knitr - to create this document [@knitr]
                     
# References
