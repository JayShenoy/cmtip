#!/bin/bash
#SBATCH --partition=ml
#SBATCH --job-name=mtip_simulate
#SBATCH --nodes=1
#SBATCH --gpus=a100:1
#SBATCH --mem=131072
#SBATCH -t 01:00:00
#SBATCH -n 32
#SBATCH --output=logs/%j.log
#SBATCH --error=logs/%j.err

source /sdf/group/ml/CryoNet/jshenoy/conda/etc/profile.d/conda.sh
conda activate /sdf/group/ml/CryoNet/jshenoy/conda/envs/cmtip

# USE_CUPY needs to be set for Skopi to use GPUs
# only use CPU for this
export USE_CUPY=0

work_dir=${PWD}
output_dir=/sdf/group/ml/CryoNet/jshenoy/skopi_datasets

#python /sdf/home/a/apeck/exafel/milestone/simulate_beam_jitter.py -b /sdf/home/a/apeck/cmtip/examples/input/amo86615.beam -p /scratch/apeck/cmtip_dev3/pdbs/2cex_a.pdb -d pnccd /sdf/home/a/apeck/skopi/examples/input/lcls/amo86615/PNCCD::CalibV1/Camp.0:pnCCD.1/geometry/0-end.data 0.04 -n 100 -o 2cexa_sim.h5 -q -s 100 -bj 0.5
#python cmtip/simulate.py -b ./examples/input/amo86615.beam -p ./examples/input/2cex_a.pdb -d 64 0.1 0.1 -n 5000 -s 10000000 -o ../skopi_datasets/2cexa_sim_64_dist_01_5k_scaled.h5
# python ${code_dir}/cmtip/simulate.py -b ${work_dir}/amo86615/amo86615.beam -p ${work_dir}/2cex_a.pdb -d 64 0.1 0.1 -n 50000 -s 10000000 -o 2cexa_sim_64_dist_01_50k_scaled.h5

# python ${work_dir}/cmtip/simulate.py -b ${work_dir}/examples/input/amo86615.beam -p ${work_dir}/examples/input/2cex_a.pdb -d 64 0.1 0.1 -n 1000 -s 10000000 -o ${output_dir}/2cexa_sim_64_dist_01_1k_scaled.h5
# python ${work_dir}/cmtip/simulate.py -b ${work_dir}/examples/input/amo86615.beam -p ${work_dir}/examples/input/1o9k.pdb -d 64 0.1 0.2 -n 50000 -o ${output_dir}/1o9k_sim_64_dist_02_50k.h5
python ${work_dir}/cmtip/simulate.py -b ${work_dir}/examples/input/amo86615.beam -p ${work_dir}/examples/input/3iyf.pdb -d 64 0.1 0.5 -n 10000 -s 100000 -o ${output_dir}/3iyf_sim_64_dist_05_10k_scaled10.h5