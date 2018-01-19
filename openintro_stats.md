# OpenIntro Stats
Ben Anderson  
30 September 2016  

# Open Intro Stats v3
Textbook etc available [online](https://www.openintro.org/stat/textbook.php?stat_book=os).

You will need to make sure the [openintro package](https://github.com/OpenIntroOrg/openintro-r-package) is loaded. To do this:

`>install.packages("devtools") (if you didn't already)`

`>library(devtools)`

`>install_github("OpenIntroOrg/openintro-r-package", subdir = "openintro")`

You will also need to install the OIdata package:

`install_github("OpenIntroOrg/openintro-r-package", subdir = "OIdata")`

Now we've done that, we will load the packages into R.


```r
knitr::opts_chunk$set(echo = TRUE)
library(openintro)
```

```
## Please visit openintro.org for free statistics materials
```

```
## 
## Attaching package: 'openintro'
```

```
## The following objects are masked from 'package:datasets':
## 
##     cars, trees
```

```r
library(OIdata)
```

```
## Loading required package: RCurl
```

```
## Loading required package: bitops
```

```
## Loading required package: maps
```

All set!

# Example 1: Histograms
An example from Open Stats v3. See if you can predict what the histograms will look like...


```r
data(run10)
par(mfrow=c(2,2))
histPlot(run10$time)
histPlot(run10$time[run10$gender=='M'], probability=TRUE, xlim=c(30, 180),
	ylim=c(0, 0.025), hollow=TRUE)
histPlot(run10$time[run10$gender=='F'], probability=TRUE, add=TRUE,
	hollow=TRUE, lty=3, border='red')
legend('topleft', col=c('black', 'red'), lty=2:3, legend=c('M','F'))
histPlot(run10$time, col=fadeColor('yellow', '33'), border='darkblue',
	probability=TRUE, breaks=30, lwd=3)
brks <- c(40, 50, 60, 65, 70, 75, 80, seq(82.5, 120, 2.5), 125,
	130, 135, 140, 150, 160, 180)
histPlot(run10$time, probability=TRUE, breaks=brks,
	col=fadeColor('darkgoldenrod4', '33'))
```

![](openintro_stats_files/figure-html/histPlot_example_1-1.png)<!-- -->
