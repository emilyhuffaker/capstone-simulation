library(tidyverse)

set.seed(9499)

population_n <- 1000000
n_samples <- 500

causal_effects <- c(0.3, 0.5)
med1_loadings <- c(0.6, 0.8)
med2_loadings <- c(0.6, 0.8)
sample_sizes <- c(100, 200, 500)


# Create population
create_population <- function(
    causal_effect,
    med1_loading,
    med2_loading
) {
  
  population <- tibble(
    med1 = rnorm(population_n),
    med2 = causal_effect * med1 + rnorm(population_n, 0, 1)
  ) |>
    mutate(
      med1_ind1 = med1_loading * med1 + rnorm(population_n, 0, 1),
      med1_ind2 = med1_loading * med1 + rnorm(population_n, 0, 1),
      med1_ind3 = med1_loading * med1 + rnorm(population_n, 0, 1),
      med1_ind4 = med1_loading * med1 + rnorm(population_n, 0, 1),
      
      med2_ind1 = med2_loading * med2 + rnorm(population_n, 0, 1),
      med2_ind2 = med2_loading * med2 + rnorm(population_n, 0, 1),
      med2_ind3 = med2_loading * med2 + rnorm(population_n, 0, 1),
      med2_ind4 = med2_loading * med2 + rnorm(population_n, 0, 1)
    ) |>
    select(
      med1_ind1,
      med1_ind2,
      med1_ind3,
      med1_ind4,
      med2_ind1,
      med2_ind2,
      med2_ind3,
      med2_ind4
    )
  
  return(population)
}


# Run one sample
run_one_sample <- function(population, sample_size) {
  
  sample_data <- population |>
    slice_sample(n = sample_size) |>
    mutate(
      med1_ave = rowMeans(
        pick(
          med1_ind1,
          med1_ind2,
          med1_ind3,
          med1_ind4
        )
      ),
      med2_ave = rowMeans(
        pick(
          med2_ind1,
          med2_ind2,
          med2_ind3,
          med2_ind4
        )
      )
    )
  
  # Unstandardized regression
  unstandardized_model <- lm(
    med2_ave ~ med1_ave,
    data = sample_data
  )
  
  unstandardized_b <- unname(
    coef(unstandardized_model)[2]
  )
  
  p_value <- summary(
    unstandardized_model
  )$coefficients[2, 4]
  
  
  # Standardized regression
  standardized_model <- lm(
    scale(med2_ave) ~ scale(med1_ave),
    data = sample_data
  )
  
  standardized_b <- unname(
    coef(standardized_model)[2]
  )
  
  
  # Correlation between the two averages
  correlation <- cor(
    sample_data$med1_ave,
    sample_data$med2_ave
  )
  
  
  # Average inter-item correlation for med1
  med1_cor_matrix <- cor(
    sample_data |>
      select(
        med1_ind1,
        med1_ind2,
        med1_ind3,
        med1_ind4
      )
  )
  
  med1_interitem_r <- mean(
    med1_cor_matrix[
      upper.tri(med1_cor_matrix)
    ]
  )
  
  
  # Average inter-item correlation for med2
  med2_cor_matrix <- cor(
    sample_data |>
      select(
        med2_ind1,
        med2_ind2,
        med2_ind3,
        med2_ind4
      )
  )
  
  med2_interitem_r <- mean(
    med2_cor_matrix[
      upper.tri(med2_cor_matrix)
    ]
  )
  
  
  return(
    c(
      unstandardized_b = unstandardized_b,
      standardized_b = standardized_b,
      p_value = p_value,
      correlation = correlation,
      med1_interitem_r = med1_interitem_r,
      med2_interitem_r = med2_interitem_r
    )
  )
}


# Empty results table
simulation_summary <- tibble()


# Run all 24 conditions
for (causal_effect in causal_effects) {
  
  for (med1_loading in med1_loadings) {
    
    for (med2_loading in med2_loadings) {
      
      # Create population for this combination
      population <- create_population(
        causal_effect = causal_effect,
        med1_loading = med1_loading,
        med2_loading = med2_loading
      )
      
      for (sample_size in sample_sizes) {
        
        unstandardized_bs <- numeric(n_samples)
        standardized_bs <- numeric(n_samples)
        sample_ps <- numeric(n_samples)
        sample_correlations <- numeric(n_samples)
        med1_interitem_rs <- numeric(n_samples)
        med2_interitem_rs <- numeric(n_samples)
        
        
        # Draw 500 samples
        for (i in 1:n_samples) {
          
          result <- run_one_sample(
            population = population,
            sample_size = sample_size
          )
          
          unstandardized_bs[i] <- result["unstandardized_b"]
          standardized_bs[i] <- result["standardized_b"]
          sample_ps[i] <- result["p_value"]
          sample_correlations[i] <- result["correlation"]
          med1_interitem_rs[i] <- result["med1_interitem_r"]
          med2_interitem_rs[i] <- result["med2_interitem_r"]
        }
        
        
        # Summarize this condition
        condition_summary <- tibble(
          causal_effect = causal_effect,
          med1_loading = med1_loading,
          med2_loading = med2_loading,
          sample_size = sample_size,
          
          mean_unstandardized_b = mean(unstandardized_bs),
          sd_unstandardized_b = sd(unstandardized_bs),
          
          mean_standardized_b = mean(standardized_bs),
          sd_standardized_b = sd(standardized_bs),
          
          percent_significant = mean(sample_ps < .05) * 100,
          
          mean_correlation = mean(sample_correlations),
          
          mean_med1_interitem_r = mean(med1_interitem_rs),
          mean_med2_interitem_r = mean(med2_interitem_rs)
        )
        
        
        simulation_summary <- bind_rows(
          simulation_summary,
          condition_summary
        )
      }
    }
  }
}


# Write only the 24-row summary
write_csv(
  simulation_summary,
  "latentvariable_across_24cond_summary.csv"
)
