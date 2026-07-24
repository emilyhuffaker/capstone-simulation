library(tidyverse)
library(MASS)

set.seed(9499)

n_replications <- 10000

create_population <- function(rho) {
  
  population <- as.data.frame(
    MASS::mvrnorm(
      n = 100000,
      mu = c(0, 0),
      Sigma = matrix(
        c(
          1, rho,
          rho, 1
        ),
        nrow = 2
      )
    )
  )
  
  names(population) <- c("X1", "X2")
  
  population
}

run_one_sample <- function(population, n) {
  
  sample_data <- population |>
    dplyr::slice_sample(n = n)
  
  test <- cor.test(
    sample_data$X1,
    sample_data$X2
  )
  
  tibble::tibble(
    r = unname(test$estimate),
    p = test$p.value
  )
}

sample_sizes <- c(20, 40, 60)
population_rs <- c(.15, .25, .35)

summary_results <- tibble::tibble()

for (rho in population_rs) {
  
  population <- create_population(rho)
  
  for (n in sample_sizes) {
    
    message(
      "Running rho = ", rho,
      ", sample size = ", n
    )
    
    results <- purrr::map_dfr(
      seq_len(n_replications),
      ~run_one_sample(population, n)
    )
    
    summary_results <- dplyr::bind_rows(
      summary_results,
      tibble::tibble(
        sample_size = n,
        population_r = rho,
        mean_r = mean(results$r),
        sd_r = sd(results$r),
        prop_sig = mean(results$p < .05)
      )
    )
  }
}

readr::write_csv(
  summary_results,
  "simulation_summary.csv"
)

print(summary_results)