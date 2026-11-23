#!/bin/bash
#SBATCH --job-name=notebook
#SBATCH --partition=courses-gpu
#SBATCH --gres=gpu:v100-sxm2:1
#SBATCH --cpus-per-task=4
#SBATCH --mem=12G
#SBATCH --time=04:00:00
#SBATCH --output=/courses/CS7150.202710/students/pitta.a/cbramod-head-interp/logs/notebook-%j.out
#
# GPU runner: runs a whole notebook top to bottom on a course V100. Every cell's
# output streams into the job log (bash hpc/status.sh shows it), and the outputs
# are saved into the same .ipynb as it goes, so you can git push it afterwards.
#   cd /courses/CS7150.202710/students/pitta.a/cbramod-head-interp/cbramod-head-interp
#   sbatch hpc/run_notebook.sbatch notebooks/your_notebook.ipynb
# Only for notebooks that use the GPU: GPU jobs that sit idle get cancelled.
# CPU-only work (like data prep) goes through hpc/run_notebook_cpu.sbatch instead.
# Waiting too long for a V100? Take any free course GPU (may be a slower P100):
#   sbatch --gres=gpu:1 hpc/run_notebook.sbatch notebooks/your_notebook.ipynb
# courses-gpu limits: 1 running job at a time, 12 GB RAM, 8 h max (--time up to 08:00:00).
set -e
ENV=/courses/CS7150.202710/students/pitta.a/cbramod-head-interp/envs/cbramod
[ -f "$1" ] || { echo "Notebook not found: $1"; exit 1; }
NB=$(realpath "$1")
echo "Running $NB on $(hostname)"
"$ENV/bin/python" -c "import papermill" 2>/dev/null || "$ENV/bin/python" -m pip install --quiet papermill
"$ENV/bin/papermill" "$NB" "$NB" --kernel cbramod --log-output --cwd "$(dirname "$NB")"
echo "Finished: outputs saved into $NB"
