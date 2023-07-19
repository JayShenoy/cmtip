#!/bin/bash
  
source /sdf/group/ml/CryoNet/jshenoy/conda/etc/profile.d/conda.sh
conda activate /sdf/group/ml/CryoNet/jshenoy/conda/envs/cmtip

work_dir=${PWD}
input_dir=/sdf/group/ml/CryoNet/jshenoy/skopi_datasets
reconst_top_dir=${work_dir}/outputs/${SLURM_JOB_ID}
mkdir -p ${reconst_top_dir}

cd ${reconst_top_dir}

for vnum in `seq 0 9`
do

cat >> temp_${vnum}.sh <<EOF
#!/bin/bash

#SBATCH --job-name=cmtip-rec_${vnum}
#SBATCH --output=${reconst_top_dir}/${vnum}.out
#SBATCH --error=${reconst_top_dir}/${vnum}.err

#SBATCH --time=24:00:00
#SBATCH --partition=ml
#SBATCH --ntasks=8
#SBATCH --mem=196G

module load mpi/mpich-x86_64

source /sdf/group/ml/CryoNet/jshenoy/conda/etc/profile.d/conda.sh
conda activate /sdf/group/ml/CryoNet/jshenoy/conda/envs/cmtip

# python ${work_dir}/cmtip/reconstruct.py -i ${input_dir}/2cexa_sim_64_dist_01_50k_scaled.h5 -t 50000 -b 2 -m 64 -n 10 -o rec_${vnum}
# python ${work_dir}/cmtip/reconstruct.py -i ${input_dir}/1o9k_sim_64_dist_02_50k_scaled.h5 -t 50000 -b 2 -m 64 -n 10 -o rec_${vnum}
# python ${work_dir}/cmtip/reconstruct.py -i ${input_dir}/1o9k_sim_64_dist_02_50k.h5 -t 50000 -b 2 -m 64 -n 10 -o rec_${vnum}
python ${work_dir}/cmtip/reconstruct.py -i ${input_dir}/1o9k_sim_64_dist_02_50k_scaled_10.h5 -t 50000 -b 2 -m 64 -n 10 -o rec_${vnum}

EOF

sbatch temp_${vnum}.sh
done
