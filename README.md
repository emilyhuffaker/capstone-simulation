# Capstone Simulation Project

**Author:** Emily Huffaker
**University:** University of Wisconsin–Madison
**Program:** M.S. Data Science in Human Behavior
**Advisor:** Dr. Markus Brauer

---

## Overview

This repository contains code, submission files, and results from my master's capstone project under the supervision of Dr. Markus Brauer at the University of Wisconsin–Madison.

The long-term goal of this project is to investigate the statistical properties of 2-1-1 multilevel mediation models using Monte Carlo simulation in R. The current phase focuses on developing reproducible simulation workflows, beginning with correlation simulations and extending to latent-variable models before progressing to full multilevel mediation simulations.

The simulations are run both locally and through the University of Wisconsin Center for High Throughput Computing (CHTC). CHTC is used to distribute simulation conditions across separate computing jobs and efficiently run a large number of replications.

---

## Project Objectives

The primary objectives of this project are to:

* Develop reproducible Monte Carlo simulation workflows in R.
* Generate populations with known statistical properties.
* Draw repeated random samples from simulated populations.
* Examine sampling variability across different parameter conditions.
* Estimate latent-variable models using `lavaan`.
* Scale simulations by distributing conditions across separate CHTC jobs.
* Extend the simulation framework to 2-1-1 multilevel mediation models.
* Compare multilevel SEM and wide-format SEM estimation approaches.

---

## Repository Structure

```text
capstone-simulation/
│
├── results/
│   └── Simulation output and summary files
│
├── .gitignore
│   └── Specifies files that should not be tracked by Git
│
├── First Simulations.qmd
│   └── Quarto document containing the initial simulation exercises
│
├── latent_variable_simulation.R
│   └── Latent-variable simulation completed for Exercise 8
│
├── run_simulation.sh
│   └── Shell script used to execute simulations through CHTC
│
├── simulation.R
│   └── Correlation simulation across multiple conditions
│
├── simulation2.R
│   └── Parameterized correlation simulation for running one condition per CHTC job
│
├── simulation2.sub
│   └── HTCondor submission file used to run the simulation conditions as separate jobs
│
└── README.md
    └── Project overview and documentation
```
---

## Current Simulation Studies

### 1. Correlation Simulation

The first simulation study examines sampling variability in correlation estimates across combinations of:

* Population correlation
* Sample size
* Number of simulation replications

For each condition, repeated samples are drawn from a simulated population. The resulting correlation estimates and significance tests are summarized to evaluate:

* Mean estimated correlation
* Standard deviation of the estimated correlations
* Proportion of statistically significant results

The nine simulation conditions were also submitted to CHTC as nine separate jobs rather than being run together within one nested loop.

### 2. Latent-Variable Simulation

The second simulation study extends the workflow to a latent-variable model estimated using `lavaan`.

The simulation generates two latent variables and their observed indicators, draws repeated samples, estimates the specified model, and summarizes parameter estimates across 500 replications.

This study provides practice with:

* Simulating latent constructs
* Specifying factor loadings
* Modeling measurement error
* Estimating structural paths between latent variables
* Extracting and summarizing model parameters
* Running latent-variable simulations through CHTC

These preliminary studies establish the computational and statistical foundation for the larger 2-1-1 multilevel mediation project.

---

## Current Progress

* ✅ GitHub repository established
* ✅ Reproducible Monte Carlo simulation workflow developed in R
* ✅ Correlation simulation framework completed
* ✅ Simulations run across nine parameter combinations
* ✅ Nine simulation conditions submitted as separate CHTC jobs
* ✅ Latent-variable simulation framework completed
* ✅ Latent-variable model estimated using `lavaan`
* ✅ Simulation results generated and summarized across 500 replications
* ✅ Simulations successfully executed through CHTC
* ✅ Apptainer container corrected using CHTC recipe guidance
* ✅ Output files successfully transferred from CHTC

---

## Next Steps

* ⏳ Expand the latent-variable simulation across multiple parameter conditions.
* ⏳ Systematically vary the causal effect, factor loadings, and sample size.
* ⏳ Run each latent-variable simulation condition as a separate CHTC job.
* ⏳ Combine the results into a single summary file.
* ⏳ Develop simulations for 2-1-1 multilevel mediation models.
* ⏳ Compare multilevel SEM and wide-format SEM approaches.
* ⏳ Evaluate bias, confidence interval coverage, statistical power, and Type I error.

---

## Reproducing the Simulations

### Initial simulation exercises

The initial simulation exercises and explanations are documented in:

```text
First Simulations.qmd
```

This file can be opened and rendered using RStudio and Quarto.

### Correlation simulation

To run the original correlation simulation locally:

```bash
Rscript simulation.R
```

### Single-condition correlation simulation

The parameterized simulation script is designed to run one combination of sample size and population correlation at a time:

```bash
Rscript simulation2.R
```
When used through CHTC, the parameter values are supplied by the HTCondor submission workflow.

### Latent-variable simulation

To run the Exercise 8 latent-variable simulation locally:

```bash
Rscript latent_variable_simulation.R
```

### CHTC submission

To submit the separate correlation simulation jobs through CHTC:

```bash
condor_submit simulation2.sub
```

The submission file uses `run_simulation.sh` to execute the relevant simulation job.

Simulation output and summary files are stored in the `results/` directory.

---

## Software and Tools

* R
* tidyverse
* MASS
* lavaan
* HTCondor
* Apptainer
* Git
* GitHub

---

## Future Work

Later stages of the project will focus on developing full 2-1-1 multilevel mediation simulations. These simulations will be used to compare different estimation approaches under varying research conditions.

Potential evaluation criteria include:

* Parameter bias
* Standard error accuracy
* Confidence interval coverage
* Statistical power
* Type I error
* Convergence rates
* Performance across different sample sizes and cluster structures

---

## Project Advisor

**Dr. Markus Brauer**
Department of Psychology
University of Wisconsin–Madison
