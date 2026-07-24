#!/bin/bash

echo "Job started on $(hostname)"
echo "rho = $1"
echo "sample size = $2"

Rscript simulation2.R "$1" "$2"

echo "Job finished"
ls -lh
