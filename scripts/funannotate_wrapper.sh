#!/bin/bash

# Enable modules
source /etc/profile.d/modules.sh

# Load funannotate and singularity
module load funannotate/1.7.2_sing

# Important vars, although 'conda activate' may overwrite them
#export SINGULARITYENV_FUNANNOTATE_DB="${FUNANNOTATE_DB}"
#export SINGULARITYENV_AUGUSTUS_CONFIG_PATH="${AUGUSTUS_CONFIG_PATH}"

SCRIPT_NAME=$(basename $0)
if [[ "${SCRIPT_NAME}" == "funannotate" ]]; then 
    cmd="funannotate"
else
    cmd=""
fi

# Parse args and re-insert quotes for final command
for arg in "$@"; do
    if [[ "$arg" =~ ' ' ]]; then
        cmd="$cmd '$arg'"
    else
        cmd="$cmd $arg"
    fi
done

# Run singularity and exectue funannotate args
singularity exec -B /bigdata:/bigdata $HPCC_MODULES/funannotate/1.7.2_sing/funannotate-hpcc.sif /bin/bash -l << EOF
# Activate funannotate conda environment
conda activate funannotate

# Overwrite conda environment varaibles
if [[ ! -z "${FUNANNOTATE_DB}" ]]; then export FUNANNOTATE_DB=${FUNANNOTATE_DB}; fi
if [[ ! -z "${AUGUSTUS_CONFIG_PATH}" ]]; then export AUGUSTUS_CONFIG_PATH=${AUGUSTUS_CONFIG_PATH}; fi

# Move to initial directory 
cd ${PWD}

# Run command
${cmd}
EOF

