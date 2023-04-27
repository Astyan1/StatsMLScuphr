#!/bin/bash -l

#SBATCH --account=edu
#SBATCH -J scuphr2
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

reference_fasta=${DATA_DIR}/${EXP_NAME}/"/truth/bulk_ref.fasta"
bulk_bam=${DATA_DIR}/${EXP_NAME}/"/bam/bulk.bam"
cells_pileup=${DATA_DIR}/${EXP_NAME}/"/bam/cells_pile.mpileup"
cell_template=${DATA_DIR}/${EXP_NAME}/"bam/cell_idx_"

cd $CODE_SRC_DIR/src/
module load anaconda/3-2021.11
echo "Ca commence"
samtools mpileup --fasta-ref ${reference_fasta} -s --no-BAQ --output ${cells_pileup} ${bulk_bam} ${cell_template}"0.bam" ${cell_template}"1.bam" ${cell_template}"2.bam" ${cell_template}"3.bam" ${cell_template}"4.bam" ${cell_template}"5.bam" ${cell_template}"6.bam" ${cell_template}"7.bam" ${cell_template}"8.bam" ${cell_template}"9.bam" ${cell_template}"10.bam" ${cell_template}"11.bam" ${cell_template}"12.bam" ${cell_template}"13.bam" ${cell_template}"14.bam" 
wait
echo "pileup finished"
python site_detection.py ${DATA_DIR}/${EXP_NAME}/ $NUM_CELLS --seed_val $SEED_VAL --scuphr_strategy $SCUPHR_STRATEGY --chr_id $CHR_ID --read_length $READ_LENGTH
wait
echo "Done"
