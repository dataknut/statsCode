# R snippets go here
# Source of code acknowledged where known

## Terms of Use ####
# GPL: V2 - http://choosealicense.com/licenses/gpl-2.0/

# See license file for details.

# [YMMV](http://en.wiktionary.org/wiki/YMMV)

# Datasets ####
# R comes with a lot of built in datasets to play with 
# see:
library(help = "datasets")

# Libraries
library(data.table) # if needed for data.table manipulation
library(stargazer) # flexible & pretty tables

# clear the workspace
rm(list=ls())

# load mpg ----
mtcars <- mtcars

# Summary functions ####
summary(mtcars)
# str(dataframe)  will produce a useful object summary of the frame
str(mtcars)

stargazer(mtcars, type="text") # works best with RMarkdown