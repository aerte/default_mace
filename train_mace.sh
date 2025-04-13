#!/bin/sh
### General options
### –- specify queue --
#BSUB -q gpua100
### -- set the job Name --
#BSUB -J Benzene_default
### -- ask for number of cores (default: 1) --
#BSUB -n 8
### -- Select the resources: 1 gpu in exclusive process mode --
#BSUB -gpu "num=1:mode=exclusive_process:mps=yes"
### -- set walltime limit: hh:mm --  maximum 24 hours for GPU-queues right now
#BSUB -W 24:00
# request 5GB of system-memory
#BSUB -R "rusage[mem=12GB]"
### -- set the email address --
# please uncomment the following line and put in your e-mail address,
# if you want to receive e-mail notifications on a non-default address
##BSUB -u email
### -- send notification at completion--
#BSUB -N
### -- Specify the output and error file. %J is the job-id --
### -- -o and -e mean append, -oo and -eo mean overwrite --
#BSUB -oo Benzene_default_%J.out
#BSUB -eo Benzene_default_%J.err
# -- end of LSF options --


module load python3/3.12.9 cuda/12.8.0
source .venv/bin/activate

python mace/cli/run_train.py \
    --name="MACE_benzene" \
    --train_file="/work3/s204797/mace/data/rmd17/train_rmd17_benzene.xyz" \
    --valid_fraction=0.05 \
    --test_file="/work3/s204797/mace/data/rmd17/test_rmd17_benzene.xyz" \
    --energy_weight=6.0 \
    --forces_weight=1000.0 \
    --config_type_weights='{"Default":1.0}' \
    --energy_key="energy" \
    --forces_key="forces" \
    --E0s='average' \
    --model="ScaleShiftMACE" \
    --interaction_first="RealAgnosticResidualInteractionBlock" \
    --interaction="RealAgnosticResidualInteractionBlock" \
    --num_interactions=2 \
    --error_table="TotalMAE" \
    --max_ell=3 \
    --hidden_irreps='256x0e + 256x1o + 256x2e' \
    --num_cutoff_basis=5 \
    --correlation=3 \
    --r_max=6.0 \
    --scaling='rms_forces_scaling' \
    --batch_size=5 \
    --max_num_epochs=3500 \
    --lr=0.01 \
    --patience=200 \
    --swa_forces_weight=1000.0 \
    --swa_energy_weight=8.0 \
    --swa_lr=0.001 \
    --weight_decay=5e-7 \
    --ema \
    --ema_decay=0.99 \
    --amsgrad \
    --default_dtype="float32" \
    --swa \
    --start_swa=2000 \
    --clip_grad=10 \
    --device=cuda \
    --seed=3 \
    --wandb \
    --wandb_entity="aertebjerg-felix" \
    --wandb_project="RMD17" \
    --wandb_name="benzene_default" 