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

%test
    # Download/setup databases to a writable/readable location
    #/bin/bash -l -c 'conda activate funannotate; funannotate setup -d /opt/funannotate_db'

    # Check that all modules are installed
    /bin/bash -l -c 'conda activate funannotate; funannotate check --show-versions'

    # Run tests -- requires internet connection to download data
    #/bin/bash -l -c 'conda activate funannotate; funannotate test -t all --cpus 1'

%environment
    #export FUNANNOTATE_DB
    #export PASAHOME
    #export TRINITY_HOME
    #export EVM_HOME
    #export AUGUSTUS_CONFIG_PATH

%runscript
    echo "Container was created $NOW"
    /bin/bash -c "/etc/profile.d/miniconda2.sh; conda activate funannotate; funannotate $@"

