#!/bin/bash
# One-time setup for running CBraMod on Northeastern's Explorer cluster.
#
# Run on a COMPUTE node, not the login node (explorer-01/02):
#   srun -p courses --cpus-per-task=4 --mem=16G --time=01:00:00 --pty bash
#   bash hpc/setup_env.sh
#
# Creates:
#   $BASE/envs/cbramod   conda env: Python 3.11, PyTorch, the authors' requirements
#   $BASE/CBraMod        the authors' code at the same pinned commit as the notebook
#   a Jupyter kernel "Python (cbramod)" for Open OnDemand JupyterLab
set -eo pipefail

BASE=/courses/CS7150.202710/students/pitta.a/cbramod-head-interp
ENV=$BASE/envs/cbramod
AUTHORS_REPO=$BASE/CBraMod
OFFICIAL_COMMIT=b9e961003214326972c567eff390e75b0287e32a

# Keep package caches out of the 75 GB home quota.
export CONDA_PKGS_DIRS=$BASE/.cache/conda_pkgs
export PIP_CACHE_DIR=$BASE/.cache/pip
mkdir -p "$BASE/CBraMod-MI" "$BASE/logs"      # data/results folder + job logs folder

module load anaconda3/2024.06          # if this version is ever removed: `module avail anaconda3`
if [ ! -x "$ENV/bin/python" ]; then
    conda create -y --prefix "$ENV" --override-channels -c conda-forge python=3.11
fi
PY=$ENV/bin/python                     # call the env's python directly; no `conda activate` needed

# 1) PyTorch. CBraMod's requirements.txt does not list it (Colab has it preinstalled).
#    2.5.1 + CUDA 12.1 runs on all public GPU types on Explorer (V100, T4, A100, H200).
$PY -m pip install --upgrade pip
$PY -m pip install torch==2.5.1 --index-url https://download.pytorch.org/whl/cu121

# 2) Authors' code (pinned) + their requirements + notebook tooling.
if [ ! -d "$AUTHORS_REPO/.git" ]; then
    git clone https://github.com/wjq-learning/CBraMod.git "$AUTHORS_REPO"
fi
git -C "$AUTHORS_REPO" checkout --quiet "$OFFICIAL_COMMIT"
$PY -m pip install -r "$AUTHORS_REPO/requirements.txt" huggingface_hub ipykernel jupyterlab

# 3) Register the env as a Jupyter kernel so Open OnDemand's JupyterLab can use it.
$PY -m ipykernel install --user --name cbramod --display-name "Python (cbramod)"

# 4) Quick check. "GPU visible: False" is expected on a CPU node.
$PY -c "import torch, mne, lmdb; print('torch', torch.__version__, '| CUDA', torch.version.cuda, '| GPU visible:', torch.cuda.is_available())"
echo "Done. Environment: $ENV"
