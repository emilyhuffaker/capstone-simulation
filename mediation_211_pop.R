library(tidyverse)

set.seed(9499)

n_classrooms <- 100000
students_per_classroom <- 5

a <- 0.2
c_prime <- 0
b <- 0.2

understood_loading <- 0.4
grade_loading <- 0.4

within_effect <- 0.5


# Create population
create_population <- function(
    a,
    c_prime,
    b,
    understood_loading,
    grade_loading,
    within_effect
) {
  
  classroom_population <- tibble(
    classroom_id = 1:n_classrooms,
    cond = sample(
      rep(
        c(-1, 1),
        each = n_classrooms / 2
      )
    )
  ) |>
    
    mutate(
      
      classroom_latent_understood =
        a * cond +
        rnorm(n_classrooms),
      
      classroom_latent_grade =
        c_prime * cond +
        b * classroom_latent_understood +
        rnorm(n_classrooms)
    )
  
  
  population <- classroom_population |>
    
    uncount(
      weights = students_per_classroom,
      .id = "student_id"
    ) |>
    
    mutate(
      
      student_understood =
        understood_loading * classroom_latent_understood +
        rnorm(n())
    ) |>
    
    group_by(classroom_id) |>
    
    mutate(
      
      student_understood_within =
        student_understood -
        mean(student_understood),
      
      grade =
        grade_loading * classroom_latent_grade +
        within_effect * student_understood_within +
        rnorm(n())
    ) |>
    
    ungroup() |>
    
    select(
      classroom_id,
      student_id,
      cond,
      classroom_latent_understood,
      classroom_latent_grade,
      student_understood,
      grade
    )
  
  return(population)
}


# Create population
population <- create_population(
  a = a,
  c_prime = c_prime,
  b = b,
  understood_loading = understood_loading,
  grade_loading = grade_loading,
  within_effect = within_effect
)


# Check population
cat("Number of classrooms:", n_distinct(population$classroom_id), "\n")
cat("Students per classroom:", students_per_classroom, "\n")
cat("Total observations:", nrow(population), "\n")
cat("Number of columns:", ncol(population), "\n")

print(
  population |>
    slice_head(n = 10)
)


# Validate population parameters

classroom_data <- population |>
  distinct(
    classroom_id,
    cond,
    classroom_latent_understood,
    classroom_latent_grade
  )

model_a <- lm(
  classroom_latent_understood ~ cond,
  data = classroom_data
)

model_b <- lm(
  classroom_latent_grade ~ cond + classroom_latent_understood,
  data = classroom_data
)

model_understood_loading <- lm(
  student_understood ~ classroom_latent_understood,
  data = population
)

population_check <- population |>
  group_by(classroom_id) |>
  mutate(
    student_understood_within =
      student_understood - mean(student_understood)
  ) |>
  ungroup()

model_grade <- lm(
  grade ~ classroom_latent_grade + student_understood_within,
  data = population_check
)


# Create validation summary

validation_summary <- tibble(
  parameter = c(
    "a",
    "c_prime",
    "b",
    "understood_loading",
    "grade_loading",
    "within_effect"
  ),

  population_value = c(
    a,
    c_prime,
    b,
    understood_loading,
    grade_loading,
    within_effect
  ),

  recovered_value = c(
    coef(model_a)["cond"],
    coef(model_b)["cond"],
    coef(model_b)["classroom_latent_understood"],
    coef(model_understood_loading)["classroom_latent_understood"],
    coef(model_grade)["classroom_latent_grade"],
    coef(model_grade)["student_understood_within"]
  )
)


# Save validation summary

write_csv(
  validation_summary,
  "results/mediation_211_pop_validation.csv"
)

print(validation_summary)

population |>
  filter(classroom_id <= 3) |>
  write_csv(
    "results/mediation_211_pop_preview.csv"
  )
