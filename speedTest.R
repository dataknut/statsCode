# Borrowed from https://www.r-bloggers.com/strategies-to-speedup-r-code/

# Create the data frame
col1 <- runif (12^4, 0, 2)
col2 <- rnorm (12^4, 0, 2)
col3 <- rpois (12^4, 3)
col4 <- rchisq (12^4, 2)
df <- data.frame (col1, col2, col3, col4)

# Original R code: Before vectorization and pre-allocation
system.time({
  for (i in 1:nrow(df)) { # for every row
    if ((df[i, 'col1'] + df[i, 'col2'] + df[i, 'col3'] + df[i, 'col4']) > 4) { # check if > 4
      df[i, 5] <- "greater_than_4" # assign 5th column
    } else {
      df[i, 5] <- "lesser_than_4" # assign 5th column
    }
  }
})