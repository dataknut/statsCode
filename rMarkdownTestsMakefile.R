# Test rendering of rmarkdown to debug Table numbers
library(rmarkdown)
library(bookdown)

rmdFile <- "rMarkdownTests.Rmd"
title <- "Rmarkdown tests (via makefile)"
rmarkdown::render(input = rmdFile,
                  output_format = "html_document2",
                  params = list(title = title),
                  output_file = "rMarkdownTests.html"
)