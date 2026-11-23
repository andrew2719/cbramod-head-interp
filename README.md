# cbramod-head-interp

## Drive organization

```text
/courses/CS7150.202710/students/pitta.a/cbramod-head-interp/
├── cbramod-head-interp/          # your GitHub repo (git pull / git push here)
│   ├── README.md
│   ├── hpc/                      # setup_env.sh, run_notebook.sbatch
│   └── notebooks/                # this notebook + your other notebooks
├── CBraMod/                      # official authors' code, pinned commit
├── envs/cbramod/                 # conda env (built once)
├── logs/                         # logs of notebook jobs
└── CBraMod-MI/                   # data + results, never in git
    ├── eeg-motor-movementimagery-dataset-1.0.0.zip
    ├── data/physionet_mi/
    │   ├── files/S001/S001R04.edf ...
    │   └── processed_average/data.mdb
    ├── models/pretrained/cbramod/pretrained_weights.pth
    └── results/physionet_mi_4class/
        ├── test_scores.csv, authors_commit.txt
        └── seed_3407/  (train.log, gpu.txt, epoch..._acc_..._kappa_..._f1_....pth)
```