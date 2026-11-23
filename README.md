# cbramod-head-interp

## Drive organization

```text
CBraMod-MI/
├── eeg-motor-movementimagery-dataset-1.0.0.zip
├── data/
│   └── physionet_mi/
│       ├── files/               # Extracted EDF recordings
│       └── processed_average/   # Authors' LMDB dataset
├── models/
│   └── pretrained/
│       └── cbramod/
└── results/
    └── physionet_mi_4class/
        ├── test_scores.csv
        └── seed_3407/
            ├── train.log
            └── model checkpoint (.pth)
```