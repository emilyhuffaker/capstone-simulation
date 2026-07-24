library(tidyverse)
library(MASS)

args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 2) {
  stop(
    "This script requires two arguments: ",
    "population correlation and sample size.\n",
    "Example: Rscript simulation.R 0.15 20"
  )
}

rho <- as.numeric(args[1])
sample_size <- as.integer(args[2])

if (is.na(rho) || is.na(sample_size)) {
  stop("The population correlation and sample size must be numeric.")
}

seed <- 9499 + sample_size + round(rho * 1000)
set.seed(seed)

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

message(
  "Running condition: rho = ", rho,
  ", sample size = ", sample_size,
  ", replications = ", n_replications,
  ", seed = ", seed
)

population <- create_population(rho)

results <- purrr::map_dfr(
  seq_len(n_replications),
  ~run_one_sample(population, sample_size)
)

summary_results <- tibble::tibble(
  sample_size = sample_size,
  population_r = rho,
  mean_r = mean(results$r),
  sd_r = sd(results$r),
  prop_sig = mean(results$p < .05)
)

output_file <- paste0(
  "simulation_summary_r",
  format(rho, nsmall = 2),
  "_n",
  sample_size,
  ".csv"
)

readr::write_csv(
  summary_results,
  output_file
)

message("Results saved to: ", output_file)

print(summary_results)