#!/bin/bash
#SBATCH --job-name=notebook
#SBATCH --partition=gpu
#SBATCH --gres=gpu:v100-sxm2:1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=04:00:00
#SBATCH --output=/courses/CS7150.202710/students/pitta.a/logs/notebook-%j.out
#
# Runs a whole notebook top to bottom on a GPU node and saves the outputs into the
# same .ipynb file, so you can git push it afterwards. No browser needed.
#   cd /courses/CS7150.202710/students/pitta.a/cbramod-head-interp
#   sbatch hpc/run_notebook.sbatch path/to/notebook.ipynb
#   squeue -u $USER        (PD = waiting, R = running, gone from the list = finished)
# If it fails, the error is in logs/notebook-<jobID>.out and the notebook is left unchanged.
set -e
[ -f "$1" ] || { echo "Notebook not found: $1"; exit 1; }
echo "Running $1 on $(hostname)"
/courses/CS7150.202710/students/pitta.a/envs/cbramod/bin/jupyter nbconvert \
    --to notebook --execute --inplace \
    --ExecutePreprocessor.kernel_name=cbramod \
    --ExecutePreprocessor.timeout=-1 \
    "$1"
echo "Finished: outputs saved into $1"
