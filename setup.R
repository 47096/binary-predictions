#!/usr/bin/env Rscript
packages <- c("broom", "car", "caret", "ggcorrplot", "mlbench", "naniar", "tidymodels", "tidyverse", "vip")
install.packages(packages[!packages %in% installed.packages()[, "Package"]])
