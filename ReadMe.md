## Enhanced Scuphr
#Code for Enhanced Scuphr, Statistical Machine Learning - Final Project
Cordina Emmanuel - ecc2197

- The code is located in src/, most of it comes from: https://github.com/Lagergren-Lab/scuphr
- Files that I added:
	* commit.sh was a shortcut that allow me to modify the code in google colab more rapidly (Google Drive is very slow for 	upload/download)
	* *script.sh are scripts to launch on a distant server
	* src/cnv_analysis.py: This file performs cnv analysis on simulated data
	* src/read_dataset.ipynb: This file .fastq.gz in order to load them into Scuphr
- I also modified almost all files to account for the CNV
- Files that we launch are (in order):
	* data_simulator.py: Simulates fake data
	* site_detection.py: Performs sites detection
	* generate_dataset_json.py: Generate a formatted dataset
	* analyse_dbc_json.py: Calculate the distance
	* analyse_dbc_combine_json.py: Combine the distance
	* lineage_trees.py: Generate and Print Trees
	* cnv_analysis.py

- The output file in output/ is the slurm output from The Habanero server
- Raw data is available online (See the .pdf file)
- List of dependencies that are *not* in anaconda 3-2021.11:
	* Dendropy 4.5.2
	* ete3 3.1.2
	* pysam
	* setuptools
	* cnv_pytor
	One might also need to install samtools
- To launch the code:
	* If you are on a Linux server:
		- %sbatch script.sh will launch the entire code
		- %sbatch iscript.sh (0<i<8) allows to launch the code in multiple runs
		- Hyperparameters are at the beginning of each *script.sh
	* You can also launch the code with the 05_Pipeline_Script_Generator.ipynb file located in src/
		- Dependencies are automatically installed
		- You can change the Hyperparameters in the #Hyperparameters tab

