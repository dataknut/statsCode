# Script to run after updating R

installMyPackages <- function(..., repository = "https://cran.rstudio.com/"){
  
  packages <- c(...)
  
  # Find if package isn't installed
  newPackages <- packages[!(packages %in% utils::installed.packages()[,1])]
  
  # Install if required
  
  if (length(newPackages)){
    message("Installing: ", newPackages)
    utils::install.packages(newPackages,
                            dependencies = TRUE)
  } else {
    message("None missing")
  }
}

myPacks <- c("bookdown",
             "broom",
             "car",
             "data.table", 
             "devtools",
             "drake", 
             "ggplot2", 
             "ggspatial",
             "here", 
             "Hmisc",
             "hms", 
             "ipfp",
             "kableExtra", 
             "knitr", 
             "leaflet",
             "lubridate", 
             "plotly", 
             "rmarkdown",
             "roxygen2",
             "sf",
             "skimr",
             "tidyverse",
             "usethis"
)

# do this manually
update.packages()

# only install the ones that are missing
installMyPackages(myPacks)

# get github ones
devtools::install_github("dataknut/dkUtils")
devtools::install_github("CfSOtago/GREENGridData")

# then re-build local packages if needed