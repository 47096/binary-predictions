# Diabetes yes/no — single-feature then multi-feature GLM
# Business question: how much does glucose move risk?

library(tidyverse)
library(caret)
library(naniar)
library(broom)
library(tidymodels)

data("PimaIndiansDiabetes2", package = "mlbench")

# Demo only: drop incomplete rows (production would impute thoughtfully)
vis_miss(PimaIndiansDiabetes2)
PimaIndiansDiabetes2 <- na.omit(PimaIndiansDiabetes2)

set.seed(123)
training.samples <- PimaIndiansDiabetes2$diabetes %>%
  createDataPartition(p = 0.8, list = FALSE)
train.data <- PimaIndiansDiabetes2[training.samples, ]
test.data <- PimaIndiansDiabetes2[-training.samples, ]

# --- Single feature: glucose ----------------------------------------------
glm.model.1 <- glm(diabetes ~ glucose, data = train.data, family = binomial)
tidy(glm.model.1)

b0 <- coef(glm.model.1)[["(Intercept)"]]
b1 <- coef(glm.model.1)[["glucose"]]

new.data <- data.frame(glucose = c(20, 180))
probabilities <- predict(glm.model.1, new.data, type = "response")
data.frame(glucose = new.data$glucose, p_diabetes = probabilities)

# Manual check for glucose = 180
plogis(b0 + b1 * 180)

train.data %>%
  mutate(prob = ifelse(diabetes == "pos", 1, 0)) %>%
  ggplot(aes(glucose, prob)) +
  geom_point(alpha = 0.2) +
  geom_smooth(method = "glm", method.args = list(family = "binomial")) +
  labs(
    title = "Glucose vs diabetes probability",
    x = "Plasma glucose",
    y = "P(diabetes = pos)"
  )

# --- Full model ------------------------------------------------------------
glm.model.2 <- glm(diabetes ~ ., data = train.data, family = binomial)
tidy(glm.model.2)

preds <- test.data %>%
  mutate(
    probabilities = predict(glm.model.2, test.data, type = "response"),
    predicted.classes = as.factor(ifelse(probabilities > 0.5, "pos", "neg"))
  )

# Holdout accuracy
mean(preds$predicted.classes == preds$diabetes)

cmat <- conf_mat(preds, truth = diabetes, estimate = predicted.classes)
cmat
summary(cmat)
