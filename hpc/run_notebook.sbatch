#!/bin/bash
#SBATCH --job-name=notebook
#SBATCH --partition=courses-gpu
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=4
#SBATCH --mem=12G
#SBATCH --time=04:00:00
#SBATCH --output=/courses/CS7150.202710/students/pitta.a/cbramod-head-interp/logs/notebook-%j.out
#
# Runs a whole notebook top to bottom on a course GPU and saves the outputs into the
# same .ipynb file, so you can git push it afterwards. No browser needed.
#   cd /courses/CS7150.202710/students/pitta.a/cbramod-head-interp/cbramod-head-interp
#   sbatch hpc/run_notebook.sbatch notebooks/your_notebook.ipynb
#   squeue -u $USER        (PD = waiting, R = running, gone from the list = finished)
# courses-gpu limits: 1 running job at a time, 12 GB RAM, 8 h max (--time can go up to 08:00:00).
# If courses-gpu is full, send one run to the general GPU partition instead:
#   sbatch -p gpu --mem=16G hpc/run_notebook.sbatch notebooks/your_notebook.ipynb
# If it fails, the error is in logs/notebook-<jobID>.out and the notebook is left unchanged.
set -e
[ -f "$1" ] || { echo "Notebook not found: $1"; exit 1; }
echo "Running $1 on $(hostname)"
/courses/CS7150.202710/students/pitta.a/cbramod-head-interp/envs/cbramod/bin/jupyter nbconvert \
    --to notebook --execute --inplace \
    --ExecutePreprocessor.kernel_name=cbramod \
    --ExecutePreprocessor.timeout=-1 \
    "$1"
echo "Finished: outputs saved into $1"
