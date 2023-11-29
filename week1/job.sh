#!/bin/bash
#SBATCH --job-name=test_job
#SBATCH --partition=test
#SBATCH --account=phys030845
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=0:10:00
#SBATCH --mem=100M

module add apps/moose/1.0

# source activate moose

/user/home/gj19866/projects/sc_res/sc_res-opt -i /user/home/gj19866/projects/sc_res/week1/week10.i
