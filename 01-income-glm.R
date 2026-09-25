# Income yes/no — GLM logistic regression
# Business question: who is likely above the income threshold?

library(tidyverse)
library(tidymodels)
library(broom)
library(vip)
library(car)
library(ggcorrplot)

data_adult <- read.csv("data/adult.csv", stringsAsFactors = TRUE)

# Row id and duplicate education codes are not needed for the model
data_cleaned <- data_adult %>%
  select(-x, -educational.num)

set.seed(222)
data_split <- initial_split(data_cleaned, prop = 0.8, strata = income)
train_data <- training(data_split)
test_data <- testing(data_split)

# --- Model -----------------------------------------------------------------
model.1 <- glm(income ~ ., family = binomial, data = train_data)
tidy(model.1)
glance(model.1)

# Multicollinearity check
vif_values <- vif(model.1)
barplot(vif_values, main = "VIF", horiz = TRUE, col = "steelblue")

# --- Interpret coefficients as odds ---------------------------------------
coef_tbl <- tidy(model.1) %>%
  mutate(odds_ratio = exp(estimate))

# Example: age effect on log-odds, then probability at age 32
b_age <- coef(model.1)[["age"]]
b0 <- coef(model.1)[["(Intercept)"]]
log_odds_age32 <- b_age * 32
p_age32 <- plogis(b0 + log_odds_age32)

# --- Score holdout ---------------------------------------------------------
preds <- test_data %>%
  mutate(
    probability = predict(model.1, test_data, type = "response"),
    predicted.class = as.factor(ifelse(probability > 0.5, ">50K", "<=50K"))
  )

cm <- conf_mat(preds, truth = income, estimate = predicted.class)
cm
summary(cm)

# Sample reason row (actual vs scored)
preds %>%
  slice_sample(n = 1) %>%
  select(age, education, hours.per.week, income, probability, predicted.class)
