library(tidyverse)

a_values <- c(0.2, 0.5)
c_prime_values <- c(0, 0.5)
b_values <- c(0.2, 0.5)
understood_loading_values <- c(0.4, 0.8)
grade_loading_values <- c(0.4, 0.8)
within_effect_values <- c(-0.2, 0, 0.2, 0.5, 0.8)

population_conditions <- expand_grid(
  a = a_values,
  c_prime = c_prime_values,
  b = b_values,
  understood_loading = understood_loading_values,
  grade_loading = grade_loading_values,
  within_effect = within_effect_values
)

print(population_conditions)

cat(
  "Number of population conditions:",
  nrow(population_conditions),
  "\n"
)
