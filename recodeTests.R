# test recoding methods

mtcars <- mtcars

# car
library(car)
mpg_r_car <- car::recode(mtcars$mpg, "0:20 = '<20'; 20:30 = '20 to 30'; 30:hi = '30+'")
table(mpg_r_car, useNA = "always")

library(dplyr)
# fails - dplyr can't recode ranges?
mpg_r_dplyr <- dplyr::recode(mtcars$mpg, range(min,20) = '<20', .default = "?")
table(mpg_r_dplyr, useNA = "always")

# also breaks
mpg_r <- recode(mtcars$mpg,
      A = 1 <- range(0,20),
       B = 2 <- 30:40,
       C = 3 <- range(41,max), # this last comma is ignored
)
table(mpg_r, useNA = "always")