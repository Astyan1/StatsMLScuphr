#!/bin/bash -l

#SBATCH --account=edu     # The account name for the job.
#SBATCH -J scuphr1   # The job name.
#SBATCH -c 15                   # The number of cpu cores to use.
#SBATCH --time=5:00:00              # The time the job will take to run 
CODE_SRC_DIR="/rigel/home/ecc2197/scuphr/src"
DATA_DIR="/rigel/home/ecc2197/scuphr/data"
RESULT_DIR="/rigel/home/ecc2197/scuphr/results"
EXP_NAME='exp'

NUM_CELLS=40
SEED_VAL=42
CHR_ID=1
READ_LENGTH=100
GENOME_LENGTH=100000
SCUPHR_STRATEGY='singleton'

CNV_RATIO=0.05

module load anaconda/3-2021.11
echo "Ca commence"
cd $CODE_SRC_DIR/src/
wait
python3 data_simulator.py --global_dir ${DATA_DIR}/${EXP_NAME}/ --num_cells $NUM_CELLS --genome_length $GENOME_LENGTH --cnv_ratio $CNV_RATIO --seed_val $SEED_VAL --p_ae 2e-05 --num_max_mid_points 10 --ado_poisson_rate 100.0 --phred_type 2 --chr_id $CHR_ID --mut_poisson_rate 3 --is_flat False --num_iter 1000 --p_ado 0.3 --amp_method mda --num_rep_amp_bias 3 --read_length $READ_LENGTH --gsnv_rate 0.005 --ado_type 3
wait
echo "SIMULATION FINIE"

