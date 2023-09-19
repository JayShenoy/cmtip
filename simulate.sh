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

POSITIONAL=()
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    -c|--config)
      RELATVECONFIGPATH="$2"
      shift
      shift
      ;;
    *)
      POSITIONAL+=("$1")
      shift
      ;;
  esac
done

set -- "${POSITIONAL[@]}" # restore positional parameters

echo "Relative path for config:"
echo ${RELATVECONFIGPATH}

python cmtip/simulate.py -c ${RELATVECONFIGPATH} --job_id ${SLURM_JOB_ID}