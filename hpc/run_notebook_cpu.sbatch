#!/bin/bash
#SBATCH --job-name=notebook
#SBATCH --partition=courses
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=04:00:00
#SBATCH --output=/courses/CS7150.202710/students/pitta.a/cbramod-head-interp/logs/notebook-%j.out
#
# CPU runner: same as run_notebook.sbatch, but without a GPU. Use it for notebooks
# or runs that don't need one, like the one-time data prep of notebook 02.
#   cd /courses/CS7150.202710/students/pitta.a/cbramod-head-interp/cbramod-head-interp
#   sbatch hpc/run_notebook_cpu.sbatch notebooks/your_notebook.ipynb
set -e
ENV=/courses/CS7150.202710/students/pitta.a/cbramod-head-interp/envs/cbramod
[ -f "$1" ] || { echo "Notebook not found: $1"; exit 1; }
NB=$(realpath "$1")
echo "Running $NB on $(hostname)"
"$ENV/bin/python" -c "import papermill" 2>/dev/null || "$ENV/bin/python" -m pip install --quiet papermill
"$ENV/bin/papermill" "$NB" "$NB" --kernel cbramod --log-output --cwd "$(dirname "$NB")"
echo "Finished: outputs saved into $NB"
