# Capstone Simulation Project

Author: Emily Huffaker  
University of Wisconsin–Madison  
M.S. Data Science in Human Behavior

## Overview

This repository contains the code and supporting files for my master's capstone project with Dr. Markus Brauer.

The project focuses on using simulation methods in R to investigate statistical properties of multilevel mediation models. Initial work involves learning the simulation workflow in R and scaling simulations using the University of Wisconsin Center for High Throughput Computing (CHTC).

## Objectives

Current goals include:

- Learn and implement simulation workflows in R.
- Generate populations with known parameters.
- Draw repeated random samples from simulated populations.
- Estimate sample statistics across many replications.
- Scale simulations using CHTC.
- Extend simulations to multilevel mediation models.

## Repository Structure

```
capstone-simulation/
│
├── simulation.R           # Main simulation script
├── simulation.sub         # HTCondor submit file
├── run_simulation.sh      # Script executed by CHTC
├── tidyverse.def          # Apptainer definition file
├── README.md
│
├── results/               # Output from completed simulations
│
├── notes/                 # Meeting notes and project documentation
│
└── archive/               # Previous versions and experimental files
```

## Current Status

- [x] GitHub repository created.
- [x] R simulation completed locally.
- [x] Apptainer container built.
- [ ] CHTC test job successfully completed.
- [ ] Large-scale simulation completed.
- [ ] Begin multilevel mediation simulations.

## Software

- R
- tidyverse
- MASS
- HTCondor
- Apptainer
- Git/GitHub

## Project Advisor

Dr. Markus Brauer  
Department of Psychology  
University of Wisconsin–Madison
