library(tidyverse)
library(MASS)

set.seed(9499)

# Read sample size and population correlation from CHTC
args <- commandArgs(trailingOnly = TRUE)

sample_size <- as.numeric(args[1])
population_r <- as.numeric(args[2])

n_samples <- 10000


# Create population
create_population <- function(rho) {
  
  sigma <- matrix(
    c(1, rho,
      rho, 1),
    nrow = 2
  )
  
  population <- mvrnorm(
    n = 100000,
    mu = c(0, 0),
    Sigma = sigma
  ) |>
    as.data.frame()
  
  names(population) <- c("x", "y")
  
  return(population)
}


# Run one sample
run_one_sample <- function(population, sample_size) {
  
  sample_data <- population |>
    slice_sample(n = sample_size)
  
  correlation_test <- cor.test(
    sample_data$x,
    sample_data$y
  )
  
  return(
    c(
      r = unname(correlation_test$estimate),
      p = correlation_test$p.value
    )
  )
}


# Create population for this condition
population <- create_population(population_r)


# Run 10,000 samples for this condition
sample_rs <- numeric(n_samples)
sample_ps <- numeric(n_samples)

for (i in 1:n_samples) {
  
  result <- run_one_sample(
    population = population,
    sample_size = sample_size
  )
  
  sample_rs[i] <- result["r"]
  sample_ps[i] <- result["p"]
}


# Summarize results for this condition
condition_summary <- tibble(
  sample_size = sample_size,
  population_r = population_r,
  mean_r = mean(sample_rs),
  sd_r = sd(sample_rs),
  prop_sig = mean(sample_ps < .05)
)


# Create output filename for this condition
output_file <- paste0(
  "correlation_summary_n",
  sample_size,
  "_r",
  population_r,
  ".csv"
)


# summary file
write_csv(
  condition_summary,
  output_file
)
