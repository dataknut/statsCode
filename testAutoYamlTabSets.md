# Test Auto-yaml and Tab sets
Ben Anderson `@dataknut`  
Last run at: `r Sys.time()`  



# Purpose

To test:

 * [auto-inclusion](http://rmarkdown.rstudio.com/html_document_format.html#shared_options) of the `_output.yaml` file;
 * [tabsets](http://rmarkdown.rstudio.com/html_document_format.html#tabbed_sections)

Key packages used:

 * base R - for the basics [@baseR]
 * knitr - to create this document [@knitr]
 
# Auto-yaml

Anything below (within) the `output:` container seems to be OK in the yaml file. But the ordering seems to matter so it refuses to knit to pdf if you have html first in the yaml file. Ifyou put the html last in the yaml file and then ask to knit to html it gnores  your html yaml settings.

It also does not re-use title, author etc. nor the bibliograpphy option. Which is all a bit of a pain... don't use it until understand it better!

Would be helpful if we could have a global ~/output.yaml file which is over-ridden on a script by script basis? 

# Tabset Heading {.tabset}

This is really very useful...

## mtcars


```r
kable(caption = "mtcars",
      summary(mtcars)
)
```



Table: mtcars

          mpg             cyl             disp             hp             drat             wt             qsec             vs               am              gear            carb     
---  --------------  --------------  --------------  --------------  --------------  --------------  --------------  ---------------  ---------------  --------------  --------------
     Min.   :10.40   Min.   :4.000   Min.   : 71.1   Min.   : 52.0   Min.   :2.760   Min.   :1.513   Min.   :14.50   Min.   :0.0000   Min.   :0.0000   Min.   :3.000   Min.   :1.000 
     1st Qu.:15.43   1st Qu.:4.000   1st Qu.:120.8   1st Qu.: 96.5   1st Qu.:3.080   1st Qu.:2.581   1st Qu.:16.89   1st Qu.:0.0000   1st Qu.:0.0000   1st Qu.:3.000   1st Qu.:2.000 
     Median :19.20   Median :6.000   Median :196.3   Median :123.0   Median :3.695   Median :3.325   Median :17.71   Median :0.0000   Median :0.0000   Median :4.000   Median :2.000 
     Mean   :20.09   Mean   :6.188   Mean   :230.7   Mean   :146.7   Mean   :3.597   Mean   :3.217   Mean   :17.85   Mean   :0.4375   Mean   :0.4062   Mean   :3.688   Mean   :2.812 
     3rd Qu.:22.80   3rd Qu.:8.000   3rd Qu.:326.0   3rd Qu.:180.0   3rd Qu.:3.920   3rd Qu.:3.610   3rd Qu.:18.90   3rd Qu.:1.0000   3rd Qu.:1.0000   3rd Qu.:4.000   3rd Qu.:4.000 
     Max.   :33.90   Max.   :8.000   Max.   :472.0   Max.   :335.0   Max.   :4.930   Max.   :5.424   Max.   :22.90   Max.   :1.0000   Max.   :1.0000   Max.   :5.000   Max.   :8.000 

## ChickWeight


```r
kable(caption = "ChickWeight",
      summary(ChickWeight)
)
```



Table: ChickWeight

         weight           Time           Chick     Diet  
---  --------------  --------------  ------------  ------
     Min.   : 35.0   Min.   : 0.00   13     : 12   1:220 
     1st Qu.: 63.0   1st Qu.: 4.00   9      : 12   2:120 
     Median :103.0   Median :10.00   20     : 12   3:120 
     Mean   :121.8   Mean   :10.72   10     : 12   4:118 
     3rd Qu.:163.8   3rd Qu.:16.00   17     : 12   NA    
     Max.   :373.0   Max.   :21.00   19     : 12   NA    
     NA              NA              (Other):506   NA    


## PlantGrowth


```r
kable(caption = "PlantGrowth",
      summary(PlantGrowth)
)
```



Table: PlantGrowth

         weight       group  
---  --------------  --------
     Min.   :3.590   ctrl:10 
     1st Qu.:4.550   trt1:10 
     Median :5.155   trt2:10 
     Mean   :5.073   NA      
     3rd Qu.:5.530   NA      
     Max.   :6.310   NA      

# References
