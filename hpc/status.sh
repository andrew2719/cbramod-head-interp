#!/bin/bash
# status.sh: one-shot overview of your notebook jobs. From the repo folder:
#   bash hpc/status.sh
# Run it again to refresh, or auto-refresh every minute (Ctrl+C stops, not the job):
#   watch -n 60 bash hpc/status.sh
PROJ=/courses/CS7150.202710/students/pitta.a/cbramod-head-interp

echo "=== Your jobs (ST: PD = waiting, R = running) ==="
squeue -u "$USER" -o "%.10i %.12P %.10j %.3t %.10M %.10l %.8N"

for id in $(squeue -u "$USER" -h -t R -n notebook -o %i); do
    log="$PROJ/logs/notebook-$id.out"
    echo
    echo "=== Notebook job $id ==="
    head -n 1 "$log" 2>/dev/null                       # which notebook, on which node
    srun --jobid="$id" --overlap nvidia-smi \
         --query-gpu=name,utilization.gpu,memory.used,memory.total \
         --format=csv,noheader 2>/dev/null | sed 's/^/GPU now: /'
    sstat -n -j "$id.batch" -o MaxRSS 2>/dev/null | sed 's/^ */Peak RAM so far: /'
    echo "--- files written in the last 2 minutes (what it's working on) ---"
    find "$PROJ" \( -path "$PROJ/envs" -o -path "$PROJ/.cache" -o -path "$PROJ/logs" \) -prune \
         -o -type f -mmin -2 -print 2>/dev/null | head -n 8
    echo "--- last 15 lines of the job log ---"
    tail -n 15 "$log" 2>/dev/null
done

echo
echo "=== Notebook jobs from the last 2 days ==="
sacct -u "$USER" -X -S now-2days --name=notebook -o JobID,State,Elapsed,NodeList
