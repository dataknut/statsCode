# h/t chatgpt

# see also https://meghan.rbind.io/blog/2022-06-28-a-beginners-guide-to-mixed-effects-models/
  
# Example data
set.seed(123)
df <- data.frame(
  subject = rep(1:10, each = 5),
  response = rnorm(50, mean = 10, sd = 2)
)

# Install and load necessary packages
install.packages("lme4")
install.packages("lmerTest")  # For p-values and confidence intervals
library(lme4)
library(lmerTest)

# Fit a mixed-effects model
model <- lmerTest::lmer(response ~ 1 + (1 | subject), data = df)

# Get the summary of the model
summary(model)

# Calculate confidence intervals for the fixed effects
confint(model, method = "Wald")
