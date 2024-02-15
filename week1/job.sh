#!/bin/bash
#SBATCH --job-name=test_job
#SBATCH --partition=test
#SBATCH --account=phys030845
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=24
#SBATCH --time=0-00:59:00
#SBATCH --mem=4000M

module add apps/moose/1.0
source activate moose

srun --cpu-bind=cores --mpi=pmi2 /user/home/gj19866/projects/sc_res/sc_res-opt -i /user/home/gj19866/projects/sc_res/week1/week11_3.i -t
