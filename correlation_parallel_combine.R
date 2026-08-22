library(tidyverse)

# Find all one-row summary files
summary_files <- list.files(
  pattern = "^correlation_summary_.*\\.csv$"
)

# Read and combine the nine condition summaries
parallel_summary <- summary_files |>
  map_dfr(read_csv, show_col_types = FALSE) |>
  arrange(sample_size, population_r)

# Write final 9-row, 5-column summary
write_csv(
  parallel_summary,
  "correlation_simulation_parallel_summary.csv"
)
