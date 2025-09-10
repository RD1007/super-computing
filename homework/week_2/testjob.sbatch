#!/bin/bash
#SBATCH -J testjob
#SBATCH -N 1 --ntasks-per-node=1
#SBATCH -c 1
#SBATCH -t5
#SBATCH -oReport-%j.out

cd $SLURM_SUBMIT_DIR

whoami
echo $SLURM_JOB_ID
hostname


# • Requests 1 node, 1 task, 1 CPU core
# • Sets a runtime ≤ 5 minutes
# • Prints the following:
# • Your username (whoami)
# • The Slurm job ID (echo $SLURM_JOB_ID)
# • The compute node name (hostname)
