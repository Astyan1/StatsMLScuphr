#!/bin/bash -l

#SBATCH --account=edu
#SBATCH -J scuphr6
#SBATCH -c 15
#SBATCH --time=5:00:00
CODE_SRC_DIR="/rigel/home/ecc2197/scuphr/src"
DATA_DIR="/rigel/home/ecc2197/scuphr/data"
OUTPUT_DIR="/rigel/home/ecc2197/scuphr/results/"
EXP_NAME="exp"

NUM_CELLS=15
SEED_VAL=42
CHR_ID=1
READ_LENGTH=100
GENOME_LENGTH=100000
SCUPHR_STRATEGY="singleton"

CNV_RATIO=0.05

cd $CODE_SRC_DIR/src/
module load anaconda/3-2021.11
echo "Ca commence"
python cnv_analysis.py --res_dir ${OUTPUT_DIR} --truth_dir ${DATA_DIR}/exp/truth/
wait
echo "Done"
