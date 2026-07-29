library(tidyverse)

set.seed(9499)


# ---------------------------------------------------------
# Simulation settings
# ---------------------------------------------------------

population_n <- 1000000
sample_n <- 100
n_samples <- 500


# ---------------------------------------------------------
# Step 1: Create the population
# ---------------------------------------------------------

population <- tibble(
  
  # Latent variable 1
  med1 = rnorm(
    population_n,
    mean = 0,
    sd = 1
  )
  
) |>
  mutate(
    
    # Latent variable 1 causes latent variable 2
    med2 = 0.30 * med1 +
      rnorm(
        population_n,
        mean = 0,
        sd = 1
      ),
    
    # Indicators of med1
    med1_ind1 = 0.80 * med1 + rnorm(population_n, 0, 1),
    med1_ind2 = 0.80 * med1 + rnorm(population_n, 0, 1),
    med1_ind3 = 0.80 * med1 + rnorm(population_n, 0, 1),
    med1_ind4 = 0.80 * med1 + rnorm(population_n, 0, 1),
    
    # Indicators of med2
    med2_ind1 = 0.60 * med2 + rnorm(population_n, 0, 1),
    med2_ind2 = 0.60 * med2 + rnorm(population_n, 0, 1),
    med2_ind3 = 0.60 * med2 + rnorm(population_n, 0, 1),
    med2_ind4 = 0.60 * med2 + rnorm(population_n, 0, 1)
  )


# ---------------------------------------------------------
# Keep only observed variables
# ---------------------------------------------------------

population_observed <- population |>
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


# ---------------------------------------------------------
# Analyze the full population
# ---------------------------------------------------------

population_observed <- population_observed |>
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


# Unstandardized population model
population_model <- lm(
  med2_ave ~ med1_ave,
  data = population_observed
)

population_unstandardized_b <- coef(
  population_model
)[["med1_ave"]]


# Standardized population model
population_standardized_model <- lm(
  scale(med2_ave) ~ scale(med1_ave),
  data = population_observed
)

population_standardized_b <- coef(
  population_standardized_model
)[[2]]


# Population correlation
population_correlation <- cor(
  population_observed$med1_ave,
  population_observed$med2_ave
)


# Population average inter-item correlation for med1
population_med1_correlations <- cor(
  population_observed |>
    select(
      med1_ind1,
      med1_ind2,
      med1_ind3,
      med1_ind4
    )
)

population_med1_interitem_r <- mean(
  population_med1_correlations[
    upper.tri(population_med1_correlations)
  ]
)


# Population average inter-item correlation for med2
population_med2_correlations <- cor(
  population_observed |>
    select(
      med2_ind1,
      med2_ind2,
      med2_ind3,
      med2_ind4
    )
)

population_med2_interitem_r <- mean(
  population_med2_correlations[
    upper.tri(population_med2_correlations)
  ]
)


# ---------------------------------------------------------
# Create empty vectors to store sample results
# ---------------------------------------------------------

unstandardized_b <- numeric(n_samples)

standardized_b <- numeric(n_samples)

p_values <- numeric(n_samples)

sample_correlations <- numeric(n_samples)

med1_interitem_r <- numeric(n_samples)

med2_interitem_r <- numeric(n_samples)


# ---------------------------------------------------------
# Step 2: Draw and analyze 500 samples
# ---------------------------------------------------------

for (i in 1:n_samples) {
  
  # Draw one sample of 100
  sample_data <- population_observed |>
    slice_sample(
      n = sample_n,
      replace = FALSE
    )
  
  
  # Average the four indicators for each latent variable
  
  sample_data <- sample_data |>
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
  model <- lm(
    med2_ave ~ med1_ave,
    data = sample_data
  )
  
  unstandardized_b[i] <- coef(
    model
  )[["med1_ave"]]
  
  p_values[i] <- summary(
    model
  )$coefficients[
    "med1_ave",
    "Pr(>|t|)"
  ]
  
  
  # Standardized regression
  standardized_model <- lm(
    scale(med2_ave) ~ scale(med1_ave),
    data = sample_data
  )
  
  standardized_b[i] <- coef(
    standardized_model
  )[[2]]
  
  
  # Correlation between the two average scores
  sample_correlations[i] <- cor(
    sample_data$med1_ave,
    sample_data$med2_ave
  )
  
  
  # Average inter-item correlation for med1 indicators
  med1_correlations <- cor(
    sample_data |>
      select(
        med1_ind1,
        med1_ind2,
        med1_ind3,
        med1_ind4
      )
  )
  
  med1_interitem_r[i] <- mean(
    med1_correlations[
      upper.tri(med1_correlations)
    ]
  )
  
  
  # Average inter-item correlation for med2 indicators
  med2_correlations <- cor(
    sample_data |>
      select(
        med2_ind1,
        med2_ind2,
        med2_ind3,
        med2_ind4
      )
  )
  
  med2_interitem_r[i] <- mean(
    med2_correlations[
      upper.tri(med2_correlations)
    ]
  )
}


# ---------------------------------------------------------
# Create the one-row summary output
# ---------------------------------------------------------

simulation_summary <- tibble(
  
  # Results from the 500 samples
  mean_unstandardized_b = mean(unstandardized_b),
  
  sd_unstandardized_b = sd(unstandardized_b),
  
  mean_standardized_b = mean(standardized_b),
  
  sd_standardized_b = sd(standardized_b),
  
  percent_significant = mean(p_values < 0.05) * 100,
  
  mean_correlation = mean(sample_correlations),
  
  mean_med1_interitem_r = mean(med1_interitem_r),
  
  mean_med2_interitem_r = mean(med2_interitem_r),
  
  # Results from the full population
  population_unstandardized_b =
    population_unstandardized_b,
  
  population_standardized_b =
    population_standardized_b,
  
  population_correlation =
    population_correlation,
  
  population_med1_interitem_r =
    population_med1_interitem_r,
  
  population_med2_interitem_r =
    population_med2_interitem_r
)


# View the results
print(simulation_summary)


# Save the one-row output file
write_csv(
  simulation_summary,
  "simulation_step8_summary.csv"
)