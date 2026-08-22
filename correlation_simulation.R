library(tidyverse)
library(MASS)

set.seed(9499)

# Simulation conditions
sample_sizes <- c(20, 40, 60)
population_rs <- c(.15, .25, .35)

# Number of samples drawn for each condition
n_samples <- 10000


# Create a population with a specified correlation
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


# Draw one sample and calculate r and p
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


# Empty data frame for the FINAL nine summary rows
simulation_summary <- tibble()


# Run all nine simulation conditions
for (population_r in population_rs) {
  
  # Create one population for this value of r
  population <- create_population(population_r)
  
  for (sample_size in sample_sizes) {
    
    # Store the 10,000 results for THIS condition only
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
    
    condition_summary <- tibble(
      sample_size = sample_size,
      population_r = population_r,
      mean_r = mean(sample_rs),
      sd_r = sd(sample_rs),
      prop_sig = mean(sample_ps < .05)
    )
    
    # ONLY the summary row
    simulation_summary <- bind_rows(
      simulation_summary,
      condition_summary
    )
  }
}


# 9-row summary file
write_csv(
  simulation_summary,
  "exercise_06_simulation_summary.csv"
)