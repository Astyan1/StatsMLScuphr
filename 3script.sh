#!/bin/bash -l

#SBATCH --account=edu
#SBATCH -J scuphr3
#SBATCH -c 15
#SBATCH --time=5:00:00
CODE_SRC_DIR="/rigel/home/ecc2197/scuphr/src"
DATA_DIR="/rigel/home/ecc2197/scuphr/data"
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
python generate_dataset_json.py ${DATA_DIR}/${EXP_NAME}/ $NUM_CELLS --data_type real --seed_val $SEED_VAL --chr_id $CHR_ID --read_length $READ_LENGTH 
wait
echo "Done"
