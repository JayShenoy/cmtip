#!/bin/bash

#SBATCH --job-name=cmtip
#SBATCH --output=logs/%j.log
#SBATCH --error=logs/%j.err

#SBATCH --time=01:00:00
#SBATCH --partition=ml
#SBATCH --ntasks=8
#SBATCH --mem=1G

POSITIONAL=()
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    -d|--datadir)
      DATADIRPATH="$2"
      shift
      shift
      ;;
    --n_images)
      NUM_IMAGES="$2"
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

echo "Dataset directory:"
echo ${DATADIRPATH}

work_dir=${PWD}
reconst_top_dir=${DATADIRPATH}/mtip/reconstruct_${NUM_IMAGES}_${SLURM_JOB_ID}
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

python ${work_dir}/cmtip/reconstruct.py -i ${DATADIRPATH}/data_train.h5 --test_set_file ${DATADIRPATH}/data_test.h5 --n_images ${NUM_IMAGES} -b 2 -m 64 -n 10 -o rec_${vnum} --n_ref 10000

EOF

sbatch temp_${vnum}.sh
done
