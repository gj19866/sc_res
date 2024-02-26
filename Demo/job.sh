#!/bin/bash
#SBATCH --job-name=test_job
#SBATCH --partition=compute
#SBATCH --account=phys030845
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=24
#SBATCH --time=30:00:00
#SBATCH --mem=4000M

module add apps/moose/1.0
source activate moose

srun --cpu-bind=cores --mpi=pmi2 /user/home/gj19866/projects/sc_res/sc_res-opt -i /user/home/gj19866/projects/sc_res/Demo/NormalBC.i -t
