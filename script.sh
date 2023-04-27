#!/bin/bash -l
#SBATCH --account=edu     # The account name for the job.
#SBATCH -J scuphr_total   # The job name.
#SBATCH -c 15                   # The number of cpu cores to use.
#SBATCH --time=10:00:00              # The time the job will take to run
CODE_SRC_DIR="/rigel/home/ecc2197/scuphr/src"
DATA_DIR="/rigel/home/ecc2197/scuphr/data"
OUTPUT_DIR="/rigel/home/ecc2197/scuphr/results/"
EXP_NAME='exp'

NUM_CELLS=50
SEED_VAL=42
CHR_ID=1
READ_LENGTH=10
GENOME_LENGTH=1000
SCUPHR_STRATEGY='singleton'

CNV_RATIO=0.05


reference_fasta=${DATA_DIR}/${EXP_NAME}/"/truth/bulk_ref.fasta"
bulk_bam=${DATA_DIR}/${EXP_NAME}/"/bam/bulk.bam"
cells_pileup=${DATA_DIR}/${EXP_NAME}/"/bam/cells_pile.mpileup"
cell_template=${DATA_DIR}/${EXP_NAME}/"bam/cell_idx_"


module load anaconda/3-2021.11
echo "Ca commence"
cd $CODE_SRC_DIR/src/
wait
python3 data_simulator.py --global_dir ${DATA_DIR}/${EXP_NAME}/ --num_cells $NUM_CELLS --genome_length $GENOME_LENGTH --cnv_ratio $CNV_RATIO --seed_val $SEED_VAL --p_ae 2e-05 --num_max_mid_points 10 --ado_poisson_rate 100.0 --phred_type 2 --chr_id $CHR_ID --mut_poisson_rate 3 --is_flat False --num_iter 1000 --p_ado 0.3 --amp_method mda --num_rep_amp_bias 3 --read_length $READ_LENGTH --gsnv_rate 0.005 --ado_type 3
wait
echo "SIMULATION FINIE"

echo "Ca commence"
samtools mpileup --fasta-ref ${reference_fasta} -s --no-BAQ --output ${cells_pileup} ${bulk_bam} ${cell_template}"0.bam" ${cell_template}"1.bam" ${cell_template}"2.bam" ${cell_template}"3.bam" ${cell_template}"4.bam" ${cell_template}"5.bam" ${cell_template}"6.bam" ${cell_template}"7.bam" ${cell_template}"8.bam" ${cell_template}"9.bam" ${cell_template}"10.bam" ${cell_template}"11.bam" ${cell_template}"12.bam" ${cell_template}"13.bam" ${cell_template}"14.bam" ${cell_template}"15.bam" ${cell_template}"16.bam" ${cell_template}"17.bam" ${cell_template}"18.bam" ${cell_template}"19.bam" ${cell_template}"20.bam" ${cell_template}"21.bam" ${cell_template}"22.bam" ${cell_template}"23.bam" ${cell_template}"24.bam" ${cell_template}"25.bam" ${cell_template}"26.bam" ${cell_template}"27.bam" ${cell_template}"28.bam" ${cell_template}"29.bam" ${cell_template}"30.bam" ${cell_template}"31.bam" ${cell_template}"32.bam" ${cell_template}"33.bam" ${cell_template}"34.bam" ${cell_template}"35.bam" ${cell_template}"36.bam" ${cell_template}"37.bam" ${cell_template}"38.bam" ${cell_template}"39.bam" ${cell_template}"40.bam" ${cell_template}"41.bam" ${cell_template}"42.bam" ${cell_template}"43.bam" ${cell_template}"44.bam" ${cell_template}"45.bam" ${cell_template}"46.bam" ${cell_template}"47.bam" ${cell_template}"48.bam" ${cell_template}"49.bam" 
wait
echo "pileup finished"
python site_detection.py ${DATA_DIR}/${EXP_NAME}/ $NUM_CELLS --seed_val $SEED_VAL --scuphr_strategy $SCUPHR_STRATEGY --chr_id $CHR_ID --read_length $READ_LENGTH
wait
echo "Done"
python generate_dataset_json.py ${DATA_DIR}/${EXP_NAME}/ $NUM_CELLS --data_type real --seed_val $SEED_VAL --chr_id $CHR_ID --read_length $READ_LENGTH
wait
echo "Done"
python analyse_dbc_json.py ${DATA_DIR}/${EXP_NAME}/ --scuphr_strategy $SCUPHR_STRATEGY --data_type real --seed_val $SEED_VAL --output_dir ${OUTPUT_DIR}
wait
echo "Done"
python analyse_dbc_combine_json.py ${DATA_DIR}/${EXP_NAME}/ --scuphr_strategy $SCUPHR_STRATEGY --data_type real --output_dir ${OUTPUT_DIR}
wait
echo "Done"
python lineage_trees.py ${OUTPUT_DIR} --data_type real
wait
echo "Done"
cd $CODE_SRC_DIR/src/
module load anaconda/3-2021.11
echo "Ca commence"
python cnv_analysis.py --res_dir ${OUTPUT_DIR} --truth_dir ${DATA_DIR}/exp/truth/
wait
echo "Done"

