# Capstone Simulation Project

**Author:** Emily Huffaker  
**University:** University of Wisconsin–Madison  
**Program:** M.S. Data Science in Human Behavior

---

## Overview

This repository contains code and supporting files for my master's capstone project under the supervision of Dr. Markus Brauer at the University of Wisconsin–Madison.

The long-term goal of this project is to investigate the statistical properties of 2-1-1 multilevel mediation models using Monte Carlo simulation in R. The current phase of the project focuses on developing reproducible simulation workflows, beginning with simple correlation simulations and extending to latent variable simulations before progressing to full multilevel mediation models. Simulations are executed locally and on the University of Wisconsin Center for High Throughput Computing (CHTC).

---

## Project Objectives

Current objectives include:

- Develop reproducible simulation workflows in R.
- Generate populations with known statistical properties.
- Draw repeated random samples from simulated populations.
- Evaluate sampling distributions across thousands of replications.
- Scale simulations using CHTC.
- Extend the simulation framework to multilevel mediation models.
- Compare multilevel SEM and wide-format SEM approaches in future analyses.

---

## Repository Structure

```text
capstone-simulation/
│
├── simulation.R                     # Correlation simulation
├── latent_variable_simulation.R     # Latent variable simulation (Step 8)
├── simulation.sub                 # HTCondor submit file
├── run_simulation.sh              # Shell script executed on CHTC
├── tidyverse.def                  # Apptainer container definition
│
├── results/
│   ├── simulation_summary.csv
│   └── simulation_step8_summary.csv
│
└──
```

> **Note:** Some directories will be added as the project continues to grow.

---
## Current Status

This repository currently contains two simulation studies:

1. Correlation simulations examining sampling variability across different sample sizes and population correlations.
2. Latent variable simulations examining the effects of measurement error on observed regression coefficients and reliability estimates.

These studies serve as the foundation for the larger multilevel mediation simulation project.

## Current Progress

- ✅ GitHub repository established
- ✅ Reproducible Monte Carlo simulation workflow developed in R
- ✅ Correlation simulation framework completed
- ✅ Latent variable simulation framework completed
- ✅ Successfully executed simulations on CHTC
- ✅ Generated and summarized simulation results from 500 replications
- ✅ Containerized workflow using Apptainer

### Next Steps

- ⏳ Parallelize simulations across multiple CHTC jobs
- ⏳ Implement 2-1-1 multilevel mediation simulations
- ⏳ Compare multilevel SEM and wide-format SEM approaches

---

## Reproducing the Simulation

To run the correlation simulation locally:

```bash
Rscript simulation.R
```

To run the latent variable simulation:

```bash
Rscript latent_variable_simulation.R
```

To submit a simulation to CHTC:

```bash
condor_submit simulation.sub
```
---

## Software and Tools

- R
- tidyverse
- MASS
- HTCondor
- Apptainer
- Git & GitHub

---

## Future Work

Upcoming phases of the project include:

- Parallelize Monte Carlo simulations across multiple CHTC jobs.
- Develop simulations for 2-1-1 multilevel mediation models.
- Compare multilevel SEM and wide-format SEM estimation methods.
- Evaluate parameter bias, confidence interval coverage, statistical power, and Type I error across varying simulation conditions.

---

## Project Advisor

**Dr. Markus Brauer**  
Department of Psychology  
University of Wisconsin–Madison
