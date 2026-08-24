# Capstone Simulation Project

**Author:** Emily Huffaker  
**University:** University of Wisconsin–Madison  
**Program:** M.S. Data Science in Human Behavior  
**Advisor:** Dr. Markus Brauer

---

## Overview

This repository contains code, CHTC submission files, and simulation results from my master's capstone project under the supervision of Dr. Markus Brauer at the University of Wisconsin–Madison.

The broader goal of this project is to investigate the statistical properties of 2-1-1 multilevel mediation models using Monte Carlo simulation in R. The current work establishes the computational and statistical framework needed for the full mediation study by progressing from simple correlation simulations to simulations involving measurement error, multiple parameter conditions, and parallel computing.

Simulations are run using R and the University of Wisconsin Center for High Throughput Computing (CHTC), which allows computationally intensive simulation conditions to be distributed across separate jobs.

---

## Project Objectives

The primary objectives of this project are to:

* Develop reproducible Monte Carlo simulation workflows in R.
* Examine parameter recovery across different population and sample conditions.
* Incorporate measurement error and latent-variable concepts into the simulation framework.
* Scale simulations using parallel computing through CHTC.
* Extend the framework to 2-1-1 multilevel mediation.
* Compare multilevel SEM and wide-format SEM estimation approaches.

---

## Current Simulation Work

### 1. Correlation Simulation

The first simulation examines sampling variability in correlation estimates across combinations of population correlation and sample size.

Population correlations of 0.15, 0.25, and 0.35 are crossed with sample sizes of 20, 40, and 60, resulting in nine simulation conditions. For each condition, 10,000 samples are drawn and summarized using the mean estimated correlation, standard deviation of the estimates, and proportion of statistically significant results.

The simulation was run both as a single CHTC job and as nine separate jobs in parallel to develop and test the computational workflow.

---

### 2. Latent-Variable Simulation

The second simulation extends the workflow to constructs measured using multiple observed indicators. Two underlying variables are simulated, with the first having a known causal effect on the second, and each is represented by four indicators containing measurement error.

The simulation was expanded across 24 conditions varying:

* Causal effect: 0.3 or 0.5
* Factor loading for the first construct: 0.6 or 0.8
* Factor loading for the second construct: 0.6 or 0.8
* Sample size: 100, 200, or 500

For each condition, 500 samples are drawn and the resulting regression coefficients, significance tests, correlations, and inter-item correlations are summarized.

The 24-condition simulation was run both as a single CHTC job and as 24 separate jobs in parallel. The parallel workflow will serve as the foundation for the larger capstone simulation.

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

* ✅ Correlation simulation completed across nine conditions
* ✅ Single-job and parallel CHTC workflows completed
* ✅ Latent-variable simulation framework completed
* ✅ Latent-variable simulation expanded across 24 conditions
* ✅ 24-condition simulation successfully run as 24 parallel CHTC jobs
* ✅ Simulation outputs validated and summarized
* ✅ Preliminary simulation exercises completed

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
* Implement the wide-format SEM approach.
* Develop a comparison multilevel SEM approach.
* Finalize the simulation conditions and evaluation metrics.
* Run large-scale simulations through CHTC.
* Compare parameter recovery across estimation approaches.
* Summarize and interpret results for the capstone manuscript.
