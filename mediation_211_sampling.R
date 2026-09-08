library(tidyverse)

source("mediation_211_pop.R")

set.seed(9499)


# Draw one sample of classrooms
draw_sample <- function(
    population,
    n_classrooms_sample
) {
  
  sampled_classrooms <- population |>
    distinct(classroom_id) |>
    slice_sample(n = n_classrooms_sample)
  
  sample_data <- population |>
    semi_join(
      sampled_classrooms,
      by = "classroom_id"
    ) |>
    select(
      classroom_id,
      student_id,
      cond,
      student_understood,
      grade
    )
  
  return(sample_data)
}


# Draw example samples
sample_50 <- draw_sample(
  population = population,
  n_classrooms_sample = 50
)

sample_100 <- draw_sample(
  population = population,
  n_classrooms_sample = 100
)

sample_200 <- draw_sample(
  population = population,
  n_classrooms_sample = 200
)


# Check sample dimensions
cat("50 classrooms:", dim(sample_50), "\n")
cat("100 classrooms:", dim(sample_100), "\n")
cat("200 classrooms:", dim(sample_200), "\n")

# Save example sample
sample_50 |>
  write_csv(
    "results/mediation_211_sample50_preview.csv"
  )
