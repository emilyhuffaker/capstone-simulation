# Capstone Simulation Project

**Author:** Emily Huffaker  
**University:** University of Wisconsin–Madison  
**Program:** M.S. Data Science in Human Behavior

---

## Overview

This repository contains code and supporting files for my master's capstone project under the supervision of Dr. Markus Brauer at the University of Wisconsin–Madison.

The long-term goal of this project is to investigate the statistical properties of **2-1-1 multilevel mediation models** using Monte Carlo simulation in R. Initial work focuses on building a reproducible simulation framework, scaling simulations with the University of Wisconsin Center for High Throughput Computing (CHTC), and preparing for more complex multilevel mediation analyses.

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
├── simulation.R                 # Main simulation script
├── simulation.sub               # HTCondor submit file
├── run_simulation.sh            # Shell script executed on CHTC
├── tidyverse.def                # Apptainer definition file
├── README.md
│
├── results/                     # Simulation output files
│
├── notes/                       # Project notes and documentation
│
└── archive/                     # Previous versions and exploratory analyses
```

> **Note:** Some directories will be added as the project continues to grow.

---

## Current Progress

- ✅ GitHub repository created
- ✅ R simulation framework completed
- ✅ Apptainer container built
- ✅ Successfully executed simulations on CHTC
- ✅ Completed 90,000 simulation replications (10,000 replications across 9 experimental conditions)
- ⏳ Parallelize simulations across multiple CHTC jobs (Step 7)
- ⏳ Begin multilevel mediation simulations

---

## Reproducing the Simulation

To run the simulation locally:

```bash
Rscript simulation.R
```

To submit the simulation to CHTC:

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

- Parallelize simulation jobs using HTCondor.
- Implement 2-1-1 multilevel mediation simulations.
- Compare multilevel SEM and wide-format SEM estimation methods.
- Evaluate parameter bias, standard errors, confidence interval coverage, and statistical power under varying simulation conditions.

---

## Project Advisor

**Dr. Markus Brauer**  
Department of Psychology  
University of Wisconsin–Madison
