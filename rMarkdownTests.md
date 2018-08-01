---
title: "Rmarkdown snippets"
author: "Ben Anderson"
date: 'Last run at: 2018-08-02 08:52:48'
output:
  bookdown::html_document2:
    fig_caption: yes
    code_folding: hide
    number_sections: yes
  bookdown::pdf_document2:
    fig_caption: yes
    number_sections: yes
---



 * One:
    * One.1;
    * One.2.

1. One (the '.' is crucial):
    i) One.1;
    ii) One.2.
2. Two

# Introduction {#intro}

This is Section \@ref(intro)

# Plots {#plots}

See Figure \@ref(fig:myPlot) in Section \@ref(plots)


```r
plot(mtcars$mpg)
```

![cars mpg plot](rMarkdownTests_files/figure-html/myPlot-1.png)

# Tables {#tables}

See Table \@ref(tab:myTable) in Section \@ref(tables).


```r
t <- summary(mtcars)

kable(t, caption = "mtcars table")
```



Table: mtcars table

          mpg             cyl             disp             hp             drat             wt             qsec             vs               am              gear            carb     
---  --------------  --------------  --------------  --------------  --------------  --------------  --------------  ---------------  ---------------  --------------  --------------
     Min.   :10.40   Min.   :4.000   Min.   : 71.1   Min.   : 52.0   Min.   :2.760   Min.   :1.513   Min.   :14.50   Min.   :0.0000   Min.   :0.0000   Min.   :3.000   Min.   :1.000 
     1st Qu.:15.43   1st Qu.:4.000   1st Qu.:120.8   1st Qu.: 96.5   1st Qu.:3.080   1st Qu.:2.581   1st Qu.:16.89   1st Qu.:0.0000   1st Qu.:0.0000   1st Qu.:3.000   1st Qu.:2.000 
     Median :19.20   Median :6.000   Median :196.3   Median :123.0   Median :3.695   Median :3.325   Median :17.71   Median :0.0000   Median :0.0000   Median :4.000   Median :2.000 
     Mean   :20.09   Mean   :6.188   Mean   :230.7   Mean   :146.7   Mean   :3.597   Mean   :3.217   Mean   :17.85   Mean   :0.4375   Mean   :0.4062   Mean   :3.688   Mean   :2.812 
     3rd Qu.:22.80   3rd Qu.:8.000   3rd Qu.:326.0   3rd Qu.:180.0   3rd Qu.:3.920   3rd Qu.:3.610   3rd Qu.:18.90   3rd Qu.:1.0000   3rd Qu.:1.0000   3rd Qu.:4.000   3rd Qu.:4.000 
     Max.   :33.90   Max.   :8.000   Max.   :472.0   Max.   :335.0   Max.   :4.930   Max.   :5.424   Max.   :22.90   Max.   :1.0000   Max.   :1.0000   Max.   :5.000   Max.   :8.000 
