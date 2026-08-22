# Capstone Simulation Project

**Author:** Emily Huffaker  
**University:** University of Wisconsin–Madison  
**Program:** M.S. Data Science in Human Behavior  
**Advisor:** Dr. Markus Brauer

---

## Overview

This repository contains code, CHTC submission files, and simulation results from my master's capstone project under the supervision of Dr. Markus Brauer at the University of Wisconsin–Madison.

The broader goal of this project is to investigate the statistical properties of 2-1-1 multilevel mediation models using Monte Carlo simulation in R. The current work establishes the computational and statistical framework needed for the full mediation study by progressing from simple correlation simulations to simulations involving latent variables, measurement error, multiple parameter conditions, and parallel computing.

Simulations are run using R and the University of Wisconsin Center for High Throughput Computing (CHTC). CHTC is used both to run complete simulation studies and to distribute individual simulation conditions across separate computing jobs.

---

## Project Objectives

The primary objectives of this project are to:

* Develop reproducible Monte Carlo simulation workflows in R.
* Generate populations with known statistical properties.
* Draw repeated random samples from simulated populations.
* Examine sampling variability across different parameter conditions.
* Simulate latent constructs using multiple observed indicators.
* Examine the effects of measurement quality and sample size on parameter estimates.
* Scale simulation studies by distributing conditions across separate CHTC jobs.
* Develop the simulation framework needed for 2-1-1 multilevel mediation models.
* Compare multilevel SEM and wide-format SEM estimation approaches.

---

## Simulation Development

### 1. Correlation Simulation

The initial simulation examines sampling variability in Pearson correlations.

Simulated populations are generated with known population correlations of:

* 0.15
* 0.25
* 0.35

Samples of:

* 20
* 40
* 60

are repeatedly drawn from each population.

For every condition, 10,000 samples are drawn and summarized using:

* Mean estimated correlation
* Standard deviation of estimated correlations
* Proportion of statistically significant correlations

This produces nine combinations of population correlation and sample size.

The simulation was first run as a single CHTC job containing all nine conditions and was then restructured so that the nine conditions could run as nine separate CHTC jobs in parallel.

---

### 2. Latent-Variable Simulation

The next stage extends the simulation framework to variables measured using multiple observed indicators.

Two latent constructs are simulated, with the first construct having a known causal effect on the second. Each construct is measured using four observed indicators containing measurement error.

Repeated samples are drawn from the simulated population and composite scores are created from the observed indicators.

For each simulation condition, the following quantities are summarized:

* Mean unstandardized regression coefficient
* Standard deviation of unstandardized regression coefficients
* Mean standardized regression coefficient
* Standard deviation of standardized regression coefficients
* Percentage of statistically significant effects
* Mean correlation between the two composite measures
* Mean inter-item correlation for the first construct
* Mean inter-item correlation for the second construct

---

### 3. Latent-Variable Simulation Across 24 Conditions

The latent-variable simulation was expanded to systematically vary four population and sample characteristics:

* Causal effect: 0.3 or 0.5
* Factor loading for indicators of the first latent variable: 0.6 or 0.8
* Factor loading for indicators of the second latent variable: 0.6 or 0.8
* Sample size: 100, 200, or 500

This creates:

```text
2 × 2 × 2 × 3 = 24 simulation conditions
```

For each of the 24 conditions, 500 samples are drawn.

The resulting summary contains one row per condition and 12 columns:

* Four columns identifying the simulation condition
* Eight columns containing the simulation results

The complete simulation was first run as a single CHTC job.

---

### 4. Parallel 24-Condition Simulation

The 24-condition latent-variable simulation was then converted to a parallel CHTC workflow.

Instead of one CHTC job processing all 24 conditions, each condition is assigned to an independent job:

```text
24 conditions → 24 CHTC jobs
```

Each job:

1. Receives one combination of simulation parameters.
2. Generates the corresponding population.
3. Draws 500 samples.
4. Calculates the requested statistics.
5. Writes a one-row summary file.

The 24 one-row output files are then combined into a final 24-row × 12-column summary.

This workflow establishes the parallel-computing structure that will be used for the larger capstone simulation study.

---

## Repository Structure

```text
capstone-simulation/
│
├── results/
│   ├── correlation_simulation_summary.csv
│   ├── correlation_simulation_parallel_summary.csv
│   ├── simulation_latentvariable_summary.csv
│   ├── latentvariable_across_24cond_summary.csv
│   └── latentvariable_across_24cond_parallel_summary.csv
│
├── .gitignore
│
├── First Simulations.qmd
│   └── Quarto document containing the initial simulation exercises
│
├── correlation_simulation.R
│   └── Correlation simulation across nine conditions
│
├── correlation_simulation.sub
│   └── CHTC submission file for the single-job correlation simulation
│
├── capstone_simulation.def
│   └── Apptainer definition file for the correlation simulation environment
│
├── correlation_simulation_parallel.R
│   └── Parameterized correlation simulation for one condition at a time
│
├── correlation_simulation_parallel.sub
│   └── CHTC submission file for nine parallel correlation jobs
│
├── correlation_conditions.txt
│   └── Parameter combinations for the parallel correlation simulation
│
├── correlation_parallel.def
│   └── Apptainer definition file for the parallel correlation workflow
│
├── correlation_parallel_combine.R
│   └── Combines the nine correlation condition summaries
│
├── latent_variable_simulation.R
│   └── Initial latent-variable simulation
│
├── latentvariable_across_24cond.R
│   └── Latent-variable simulation across 24 parameter conditions
│
├── latentvariable_across_24cond.sub
│   └── CHTC submission file for the 24-condition simulation
│
├── latentvariable_across_24cond.def
│   └── Apptainer definition file for the 24-condition simulation
│
├── latentvariable_across_24cond_parallel.R
│   └── Parameterized latent-variable simulation for one condition per job
│
├── latentvariable_across_24cond_parallel.sub
│   └── CHTC submission file for 24 parallel jobs
│
├── latentvariable_24cond_conditions.txt
│   └── Parameter combinations for the 24 parallel jobs
│
├── latentvariable_across_24cond_parallel.def
│   └── Apptainer definition file for the parallel latent-variable workflow
│
├── latentvariable_across_24cond_parallel_combine.R
│   └── Combines the 24 individual condition summaries
│
└── README.md
    └── Project overview and documentation
```

---

## Current Progress

* ✅ GitHub repository established
* ✅ Reproducible Monte Carlo simulation workflow developed in R
* ✅ Basic correlation simulation completed
* ✅ Nine correlation conditions evaluated with 10,000 samples per condition
* ✅ Correlation simulation successfully executed as a single CHTC job
* ✅ Nine correlation conditions successfully executed as nine separate CHTC jobs
* ✅ Latent-variable simulation framework completed
* ✅ Latent constructs represented using multiple observed indicators
* ✅ Measurement quality incorporated through varying factor loadings
* ✅ Latent-variable simulation expanded across 24 parameter combinations
* ✅ 500 samples evaluated for each of the 24 conditions
* ✅ 24-condition simulation successfully executed through CHTC
* ✅ 24 conditions successfully distributed across 24 separate CHTC jobs
* ✅ Parallel outputs combined into a single 24-row × 12-column summary
* ✅ Reproducible Apptainer environments created for CHTC workflows
* ✅ Preliminary simulation exercises completed

---

## Reproducing the Simulations

### Correlation Simulation

Run the nine-condition correlation simulation:

```bash
Rscript correlation_simulation.R
```

To submit the simulation through CHTC:

```bash
condor_submit correlation_simulation.sub
```

---

### Parallel Correlation Simulation

The parallel correlation simulation accepts one sample size and population correlation per job.

The parameter combinations are stored in:

```text
correlation_conditions.txt
```

Submit the nine jobs with:

```bash
condor_submit correlation_simulation_parallel.sub
```

The individual condition summaries can then be combined using:

```bash
Rscript correlation_parallel_combine.R
```

---

### Initial Latent-Variable Simulation

Run the initial latent-variable simulation using:

```bash
Rscript latent_variable_simulation.R
```

---

### 24-Condition Latent-Variable Simulation

Run the full 24-condition simulation using:

```bash
Rscript latentvariable_across_24cond.R
```

To run it through CHTC:

```bash
condor_submit latentvariable_across_24cond.sub
```

---

### Parallel 24-Condition Simulation

The parallel version assigns one parameter combination to each CHTC job.

The 24 parameter combinations are stored in:

```text
latentvariable_24cond_conditions.txt
```

Submit all 24 jobs using:

```bash
condor_submit latentvariable_across_24cond_parallel.sub
```

After all jobs finish, combine the individual condition summaries using:

```bash
Rscript latentvariable_across_24cond_parallel_combine.R
```

Simulation summary files are stored in the `results/` directory.

---

## Software and Tools

* R
* tidyverse
* MASS
* HTCondor
* Apptainer
* Quarto
* Git
* GitHub

---

## Next Steps

With the preliminary simulation exercises complete, the next phase of the project will focus on developing the full 2-1-1 multilevel mediation simulation.

Planned work includes:

* Define the population-generating model for the 2-1-1 mediation structure.
* Systematically vary population and measurement characteristics.
* Implement multilevel SEM estimation.
* Implement the wide-format SEM approach.
* Run large-scale simulation conditions through CHTC.
* Compare parameter recovery across estimation approaches.
* Evaluate bias, confidence interval coverage, statistical power, Type I error, and convergence.
* Summarize and interpret simulation results for the capstone manuscript.

---

## Project Advisor

**Dr. Markus Brauer**  
Department of Psychology  
University of Wisconsin–Madison
