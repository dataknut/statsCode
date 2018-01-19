# skimr
Ben Anderson (b.anderson@soton.ac.uk, `@dataknut`)  
Last run at: `r Sys.time()`  

# skimr

https://github.com/ropenscilabs/skimr#skimr - [@skimr]



```r
knitr::opts_chunk$set(echo = TRUE)
library(skimr)
```

Go!


```r
skim(mtcars)
```

```
## Numeric Variables
## # A tibble: 11 x 13
##      var    type missing complete     n       mean          sd    min
##    <chr>   <chr>   <dbl>    <dbl> <dbl>      <dbl>       <dbl>  <dbl>
##  1    am numeric       0       32    32   0.406250   0.4989909  0.000
##  2  carb numeric       0       32    32   2.812500   1.6152000  1.000
##  3   cyl numeric       0       32    32   6.187500   1.7859216  4.000
##  4  disp numeric       0       32    32 230.721875 123.9386938 71.100
##  5  drat numeric       0       32    32   3.596563   0.5346787  2.760
##  6  gear numeric       0       32    32   3.687500   0.7378041  3.000
##  7    hp numeric       0       32    32 146.687500  68.5628685 52.000
##  8   mpg numeric       0       32    32  20.090625   6.0269481 10.400
##  9  qsec numeric       0       32    32  17.848750   1.7869432 14.500
## 10    vs numeric       0       32    32   0.437500   0.5040161  0.000
## 11    wt numeric       0       32    32   3.217250   0.9784574  1.513
## # ... with 5 more variables: `25% quantile` <dbl>, median <dbl>, `75%
## #   quantile` <dbl>, max <dbl>, hist <chr>
```

# References
