# R Notebook: Stargazer Package Tests
Ben Anderson (b.anderson@soton.ac.uk/@dataknut) [Energy & Climate Change, Faculty of Engineering & Environment, University of Southampton]  
Last run at: `r Sys.time()`  

# Setup

```r
startTime <- Sys.time() # always good to time your code
knitr::opts_chunk$set(echo = TRUE)
knitr::opts_chunk$set(warning = TRUE)
knitr::opts_chunk$set(message = TRUE)
knitr::opts_chunk$set(fig_caption = TRUE)
knitr::opts_chunk$set(tidy = TRUE)


library(knitr) # for kable
library(stargazer)
```

```
## 
## Please cite as:
```

```
##  Hlavac, Marek (2015). stargazer: Well-Formatted Regression and Summary Statistics Tables.
```

```
##  R package version 5.2. http://CRAN.R-project.org/package=stargazer
```

Key packages used:

 * base R - for the basics [@baseR]
 * stargazer - for pretty tables [@stargazer]
 * knitr - to create this document [@knitr]
 
# Summary

We can print an ordinary table:


```r
summary(cars)
```

```
##      speed           dist       
##  Min.   : 4.0   Min.   :  2.00  
##  1st Qu.:12.0   1st Qu.: 26.00  
##  Median :15.0   Median : 36.00  
##  Mean   :15.4   Mean   : 42.98  
##  3rd Qu.:19.0   3rd Qu.: 56.00  
##  Max.   :25.0   Max.   :120.00
```

# Kable

We can also do that using kable:


```r
t <- summary(cars)
kable(caption = "Cars", t)
```



Table: Cars

         speed           dist      
---  -------------  ---------------
     Min.   : 4.0   Min.   :  2.00 
     1st Qu.:12.0   1st Qu.: 26.00 
     Median :15.0   Median : 36.00 
     Mean   :15.4   Mean   : 42.98 
     3rd Qu.:19.0   3rd Qu.: 56.00 
     Max.   :25.0   Max.   :120.00 

# Stargazer

We can also use stargazer:

```r
# NB: we need to force knitr to keep the html (asis)
stargazer(cars, type = "html")
```


<table style="text-align:center"><tr><td colspan="6" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">Statistic</td><td>N</td><td>Mean</td><td>St. Dev.</td><td>Min</td><td>Max</td></tr>
<tr><td colspan="6" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">speed</td><td>50</td><td>15.400</td><td>5.288</td><td>4</td><td>25</td></tr>
<tr><td style="text-align:left">dist</td><td>50</td><td>42.980</td><td>25.769</td><td>2</td><td>120</td></tr>
<tr><td colspan="6" style="border-bottom: 1px solid black"></td></tr></table>

Stargazer is especially good at regression model outputs:


```r
model1 <- lm(mpg ~ disp + cyl, mtcars)
model2 <- lm(mpg ~ disp + cyl + hp + qsec, mtcars)

stargazer(model1, model2, type = "html", column.sep.width = "2pt", font.size = "tiny"  # tiny, scriptsize, footnotesize,small,normalsize,large
)
```


<table style="text-align:center"><tr><td colspan="3" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left"></td><td colspan="2"><em>Dependent variable:</em></td></tr>
<tr><td></td><td colspan="2" style="border-bottom: 1px solid black"></td></tr>
<tr><td style="text-align:left"></td><td colspan="2">mpg</td></tr>
<tr><td style="text-align:left"></td><td>(1)</td><td>(2)</td></tr>
<tr><td colspan="3" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">disp</td><td>-0.021<sup>*</sup></td><td>-0.012</td></tr>
<tr><td style="text-align:left"></td><td>(0.010)</td><td>(0.011)</td></tr>
<tr><td style="text-align:left"></td><td></td><td></td></tr>
<tr><td style="text-align:left">cyl</td><td>-1.587<sup>**</sup></td><td>-1.614<sup>*</sup></td></tr>
<tr><td style="text-align:left"></td><td>(0.712)</td><td>(0.826)</td></tr>
<tr><td style="text-align:left"></td><td></td><td></td></tr>
<tr><td style="text-align:left">hp</td><td></td><td>-0.029</td></tr>
<tr><td style="text-align:left"></td><td></td><td>(0.017)</td></tr>
<tr><td style="text-align:left"></td><td></td><td></td></tr>
<tr><td style="text-align:left">qsec</td><td></td><td>-0.683</td></tr>
<tr><td style="text-align:left"></td><td></td><td>(0.471)</td></tr>
<tr><td style="text-align:left"></td><td></td><td></td></tr>
<tr><td style="text-align:left">Constant</td><td>34.661<sup>***</sup></td><td>49.235<sup>***</sup></td></tr>
<tr><td style="text-align:left"></td><td>(2.547)</td><td>(10.699)</td></tr>
<tr><td style="text-align:left"></td><td></td><td></td></tr>
<tr><td colspan="3" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">Observations</td><td>32</td><td>32</td></tr>
<tr><td style="text-align:left">R<sup>2</sup></td><td>0.760</td><td>0.785</td></tr>
<tr><td style="text-align:left">Adjusted R<sup>2</sup></td><td>0.743</td><td>0.753</td></tr>
<tr><td style="text-align:left">Residual Std. Error</td><td>3.055 (df = 29)</td><td>2.997 (df = 27)</td></tr>
<tr><td style="text-align:left">F Statistic</td><td>45.808<sup>***</sup> (df = 2; 29)</td><td>24.589<sup>***</sup> (df = 4; 27)</td></tr>
<tr><td colspan="3" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left"><em>Note:</em></td><td colspan="2" style="text-align:right"><sup>*</sup>p<0.1; <sup>**</sup>p<0.05; <sup>***</sup>p<0.01</td></tr>
</table>

Stargazer has a lot of [options](https://www.rdocumentation.org/packages/stargazer/versions/5.2/topics/stargazer) that can be used to change what goes where...

***
__Meta:__
Analysis completed in: 0.558 seconds using [knitr](https://cran.r-project.org/package=knitr) in [RStudio](http://www.rstudio.com).

# References
