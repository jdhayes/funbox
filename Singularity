BootStrap: library
From: ubuntu

#%setup

%post
    # Update Ubuntu
    apt update -y
    apt install wget -y
    
    # Install conda
    wget https://repo.anaconda.com/miniconda/Miniconda2-latest-Linux-x86_64.sh -O ~/miniconda.sh
    bash ~/miniconda.sh -b -p /opt/miniconda2
    /opt/miniconda2/bin/conda shell.bash hook > /etc/profile.d/miniconda2.sh
    chmod 644 /etc/profile.d/miniconda2.sh
    . /etc/profile

    # Add appropriate channels
    conda config --add channels defaults
    conda config --add channels bioconda
    conda config --add channels conda-forge

    # Install mamba
    #conda install mamba

    # Create environment
    conda create -n funannotate funannotate

    # Set build date for later runtime
    NOW=$(date)
    echo "export NOW=\"${NOW}\"" >> $SINGULARITY_ENVIRONMENT

#%test
    # Download/setup databases to a writable/readable location
    #/bin/bash -l -c 'conda activate funannotate; funannotate setup -d /opt/funannotate_db'

    # Check that all modules are installed
    #/bin/bash -l -c 'conda activate funannotate; funannotate check --show-versions'

    # Run tests -- requires internet connection to download data
    #/bin/bash -l -c 'conda activate funannotate; funannotate test -t all --cpus 1'

#%environment
    #export FUNANNOTATE_DB
    #export PASAHOME
    #export TRINITY_HOME
    #export EVM_HOME
    #export AUGUSTUS_CONFIG_PATH

%runscript
# Print build date
echo "Container was created $NOW"

# Singularity alredy does this
# cd ${PWD}

# Get script name
SCRIPT_NAME=$(basename $0)
if [ "$SINGULARITY_NAME" = 'funannotate' ]; then
    cmd="funannotate"
else
    cmd=""
fi

# Parse args and re-insert quotes for final command
for arg in "$@"; do
    echo $arg | grep -P '\s' >/dev/null
    ecode=$?
    if [ $ecode -eq 0 ]; then
        cmd="$cmd '$arg'"
    else
        cmd="$cmd $arg"
    fi
done

# Run script as bash
/bin/bash << EOF
# Load miniconda2
source /etc/profile.d/miniconda2.sh

# Activate funannotate conda environment
conda activate funannotate

# Overwrite conda environment varaibles
if [[ ! -z "${FUNANNOTATE_DB}" ]]; then export FUNANNOTATE_DB=${FUNANNOTATE_DB}; fi
if [[ ! -z "${AUGUSTUS_CONFIG_PATH}" ]]; then export AUGUSTUS_CONFIG_PATH=${AUGUSTUS_CONFIG_PATH}; fi

# Run command
${cmd}
EOF
