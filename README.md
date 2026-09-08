# Capstone Simulation Project

**Author:** Emily Huffaker
**University:** University of Wisconsin–Madison
**Program:** M.S. Data Science in Human Behavior
**Advisor:** Dr. Markus Brauer

---

## Overview

This repository contains code, CHTC submission files, and simulation results from my master's capstone project under the supervision of Dr. Markus Brauer at the University of Wisconsin–Madison.

The broader goal of this project is to investigate the statistical properties of 2-1-1 multilevel mediation models using Monte Carlo simulation in R. The project has progressed from introductory correlation and latent-variable simulations to development of the data-generating process for the full 2-1-1 mediation study.

Simulations are run using R and the University of Wisconsin Center for High Throughput Computing (CHTC), which allows computationally intensive simulation conditions to be distributed across separate jobs.

---

## Project Objectives

The primary objectives of this project are to:

* Develop reproducible Monte Carlo simulation workflows in R.
* Examine parameter recovery across different population and sample conditions.
* Incorporate measurement error and latent-variable concepts into the simulation framework.
* Scale simulations using parallel computing through CHTC.
* Develop a data-generating model for 2-1-1 multilevel mediation.
* Evaluate estimation of the between-classroom mediation effect across simulation conditions.
* Implement and compare the appropriate mediation estimation approaches.

---

## Current Simulation Work

### 1. Correlation Simulation

The first simulation examines sampling variability in correlation estimates across combinations of population correlation and sample size.

Population correlations of 0.15, 0.25, and 0.35 are crossed with sample sizes of 20, 40, and 60, resulting in nine simulation conditions. For each condition, 10,000 samples are drawn and summarized using the mean estimated correlation, standard deviation of the estimates, and proportion of statistically significant results.

The simulation was run both as a single CHTC job and as nine separate jobs in parallel to develop and test the computational workflow.

---

### 2. Latent-Variable Simulation

The second simulation extends the workflow to constructs measured using multiple observed indicators. Two underlying variables are simulated, with the first having a known causal effect on the second, and each represented by four indicators containing measurement error.

The simulation was expanded across 24 conditions varying:

* Causal effect: 0.3 or 0.5
* Loading for the first construct: 0.6 or 0.8
* Loading for the second construct: 0.6 or 0.8
* Sample size: 100, 200, or 500

For each condition, 500 samples are drawn and the resulting regression coefficients, significance tests, correlations, and inter-item correlations are summarized.

The 24-condition simulation was run both as a single CHTC job and as 24 separate jobs in parallel. This workflow provides the computational foundation for the larger capstone simulation.

---

### 3. 2-1-1 Mediation Simulation

The current phase of the project focuses on the full 2-1-1 mediation data-generating process.

Each simulated population contains:

* 100,000 classrooms
* 5 students per classroom
* 500,000 total student observations
* A classroom-level experimental condition
* A latent classroom-level mediator
* A latent classroom-level outcome
* Observed student-level mediator scores
* Observed student-level outcome scores

The population-generating process includes parameters for:

* Path `a`: classroom condition → classroom-level mediator
* Path `c'`: direct effect of classroom condition → classroom-level outcome
* Path `b`: classroom-level mediator → classroom-level outcome
* Strength of the classroom-level contribution to student mediator scores
* Strength of the classroom-level contribution to student outcome scores
* Within-classroom mediator → outcome effect

The primary target of the simulation is the recovery of the between-classroom `b` effect.

The initial population-generating process has been validated by comparing the known population parameters with estimates recovered from the generated data.

The full design contains 160 population conditions:

* `a`: 0.2 or 0.5
* `c'`: 0 or 0.5
* `b`: 0.2 or 0.5
* Mediator loading: 0.4 or 0.8
* Outcome loading: 0.4 or 0.8
* Within-classroom effect: -0.2, 0, 0.2, 0.5, or 0.8

A sampling workflow has also been implemented to draw samples of:

* 50 classrooms
* 100 classrooms
* 200 classrooms

Because each classroom contains five students, these correspond to samples of 250, 500, and 1,000 student observations.

The next phase is to finalize and implement the analysis model applied to each sampled dataset.

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
│   ├── latentvariable_across_24cond_parallel_summary.csv
│   ├── mediation_211_pop_validation.csv
│   ├── mediation_211_pop_validation_baseline.csv
│   ├── mediation_211_pop_validation_within05.csv
│   └── mediation_211_sample50_preview.csv
│
├── .gitignore
│
├── First Simulations.qmd
│
├── correlation_simulation.R
├── correlation_simulation.sub
├── capstone_simulation.def
│
├── correlation_simulation_parallel.R
├── correlation_simulation_parallel.sub
├── correlation_conditions.txt
├── correlation_parallel.def
├── correlation_parallel_combine.R
│
├── latent_variable_simulation.R
├── latentvariable_across_24cond.R
├── latentvariable_across_24cond.sub
├── latentvariable_across_24cond.def
├── latentvariable_across_24cond_parallel.R
├── latentvariable_across_24cond_parallel.sub
├── latentvariable_24cond_conditions.txt
├── latentvariable_across_24cond_parallel.def
├── latentvariable_across_24cond_parallel_combine.R
│
├── mediation_211_pop.R
│   └── Generates and validates an initial 2-1-1 mediation population
│
├── mediation_211_populations.R
│   └── Defines the 160 population parameter combinations
│
├── mediation_211_sampling.R
│   └── Draws samples of 50, 100, or 200 classrooms
│
└── README.md
```

---

## Current Progress

* ✅ Correlation simulation completed across nine conditions
* ✅ Single-job and parallel CHTC workflows completed
* ✅ Latent-variable simulation framework completed
* ✅ Latent-variable simulation expanded across 24 conditions
* ✅ 24-condition simulation successfully run as 24 parallel CHTC jobs
* ✅ Initial 2-1-1 mediation population-generating process completed
* ✅ Population parameters validated
* ✅ Full 160-condition population parameter grid created
* ✅ Sampling workflow completed for 50, 100, and 200 classrooms
* ⏳ Analysis model for sampled 2-1-1 datasets to be finalized

---

## Reproducing the Simulations

### Correlation Simulation

```bash
Rscript correlation_simulation.R
condor_submit correlation_simulation.sub
```

For the parallel version:

```bash
condor_submit correlation_simulation_parallel.sub
Rscript correlation_parallel_combine.R
```

### Latent-Variable Simulation

```bash
Rscript latent_variable_simulation.R
```

For the 24-condition simulation:

```bash
Rscript latentvariable_across_24cond.R
condor_submit latentvariable_across_24cond.sub
```

For the parallel version:

```bash
condor_submit latentvariable_across_24cond_parallel.sub
Rscript latentvariable_across_24cond_parallel_combine.R
```

### 2-1-1 Mediation Simulation

Generate and validate the initial population:

```bash
Rscript mediation_211_pop.R
```

Create the 160-condition parameter grid:

```bash
Rscript mediation_211_populations.R
```

Generate example samples:

```bash
Rscript mediation_211_sampling.R
```

Simulation summary and validation files are stored in the `results/` directory.

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

The data-generating and sampling components of the 2-1-1 mediation simulation are now in place.

The next steps are to:

* Finalize the analysis model applied to each sampled dataset.
* Implement the appropriate path analytic/SEM approach in R.
* Determine which parameter estimates and simulation performance measures will be retained.
* Integrate repeated sampling and model estimation across the 160 population conditions and three sample sizes.
* Scale the full simulation through CHTC.
* Evaluate recovery and bias in the estimated between-classroom mediation effect.
* Summarize and interpret the simulation results for the capstone manuscript.
