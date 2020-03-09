BootStrap: library
From: ubuntu:18.04

#%setup

%files
    # Copy GeneMark (http://exon.gatech.edu/Genemark/license_download.cgi)
    #./misc/gm_et_linux_64.tar.gz /tmp
    
    # Copy RepBaseREpeatMasker (http://www.girinst.org/repbase/)
    #./misc/RepBaseRepeatMaskerEdition-20170127.tar.gz /tmp
    
    # Copy signalp (http://www.cbs.dtu.dk/cgi-bin/sw_request?signalp)
    #./misc/signalp-5.0b.Linux.tar.gz /tmp
    
    # Copy Phobius (http://software.sbc.su.se/cgi-bin/request.cgi?project=phobius)
    #./misc/phobius101_linux.tar.gz /tmp

%post
    # Hack to add additional repos
    echo "deb http://archive.ubuntu.com/ubuntu bionic multiverse
deb http://archive.ubuntu.com/ubuntu bionic-security multiverse
deb http://archive.ubuntu.com/ubuntu bionic-updates multiverse
deb http://archive.ubuntu.com/ubuntu bionic universe
deb http://archive.ubuntu.com/ubuntu bionic-security universe
deb http://archive.ubuntu.com/ubuntu bionic-updates universe" >> /etc/apt/sources.list

    # Update Ubuntu
    apt update -y
    # Install various softwares
    apt install -y curl mysql-client wget pbzip2

    # Phobius dependancies, use conda perl instead
    # libgetopt-long-descriptive-perl libfindbin-libs-perl

    # Install GeneMark (Place license at ~/.gm_key)
    export GENEMARK_PATH=/opt/genemark
    mkdir -p ${GENEMARK_PATH}
    find /tmp -maxdepth 1 -name "gm_et_linux_64.tar.gz" -exec tar -C ${GENEMARK_PATH} -xf {} \;
    find ${GENEMARK_PATH} -name '*.pl' -exec sed -i 's/^#!\/usr\/bin\/perl.*/#!\/usr\/bin\/env perl/' {} \;
    rm -f /tmp/gm_et_linux_64.tar.gz
    GM_PATH=$(dirname $(find ${GENEMARK_PATH} -type f -name 'gmes_petap.pl') || echo '')
    
    # Install RepBaseRepeatMasker
    export RBRM_PATH=/opt/RepBaseRepeatMasker
    mkdir -p ${RBRM_PATH}
    find /tmp -maxdepth 1 -name "RepBaseRepeatMaskerEdition*.tar.gz" -exec tar -C ${RBRM_PATH} -xf {} \;
    rm -f /tmp/RepBaseRepeatMaskerEdition*.tar.gz

    # Install signalp
    export SIGNALP_PATH=/opt/signalp
    mkdir -p ${SIGNALP_PATH}
    find /tmp -maxdepth 1 -name "signalp*.tar.gz" -exec tar -C ${SIGNALP_PATH} -xf {} \;
    rm -f /tmp/signalp*.tar.gz
    SP_PATH=$(dirname $(find ${SIGNALP_PATH} -type f -name 'signalp') || echo '')
    
    # Install Phobius
    export PHOBIUS_PATH=/opt/phobius
    mkdir -p ${PHOBIUS_PATH}
    find /tmp -maxdepth 1 -name "phobius101_linux.tar.gz" -exec tar --no-same-owner -C ${PHOBIUS_PATH} -xf {} \;
    find ${PHOBIUS_PATH} -name '*.pl' -exec sed -i 's/^#!\/usr\/bin\/perl.*/#!\/usr\/bin\/env perl/' {} \;
    rm -f /tmp/phobius101_linux.tar.gz
    P_PATH=$(dirname $(find ${PHOBIUS_PATH} -type f -name 'phobius.pl') || echo '')
    chmod -R 755 ${PHOBIUS_PATH}

    # Install conda
    curl https://repo.anaconda.com/miniconda/Miniconda2-latest-Linux-x86_64.sh > ~/miniconda.sh
    bash ~/miniconda.sh -b -p /opt/miniconda2

    # Setup conda activation
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
    
    # Setup conda activate PATHs
    echo "export PATH=${GM_PATH}:${SP_PATH}:${P_PATH}:\$PATH" >> /opt/miniconda2/envs/funannotate/etc/conda/activate.d/licensed_software.sh
    chmod 644 /opt/miniconda2/envs/funannotate/etc/conda/activate.d/licensed_software.sh

    # Install some R packages
    conda install -n funannotate -c conda-forge r-ggplot2
    conda install -n funannotate -c bioconda bioconductor-seqlogo

    # Set build date
    NOW=$(date)
    echo "export NOW=\"${NOW}\"" >> $SINGULARITY_ENVIRONMENT

#%test
    # Download/setup databases to a writable/readable location
    #/bin/bash -l -c 'conda activate funannotate; funannotate setup -d /opt/funannotate_db'

    # Check that all modules are installed
    #/bin/bash -l -c 'conda activate funannotate; funannotate check --show-versions'

    # Run tests -- requires internet connection to download data
    #/bin/bash -l -c 'conda activate funannotate; funannotate test -t all --cpus 1'

%environment
    # Manually configure
    #export FUNANNOTATE_DB=/path/to/funannotate/db
    #export GENEMARK_PATH=/opt/genemark/gm_et_linux_64

    # Preset by conda
    #export PASAHOME=/opt/miniconda2/envs/funannotate/opt/pasa-2.4.1
    #export TRINITY_HOME=/opt/miniconda2/envs/funannotate/opt/trinity-2.8.5
    #export EVM_HOME=/opt/miniconda2/envs/funannotate/opt/evidencemodeler-1.1.1
    #export AUGUSTUS_CONFIG_PATH=/opt/miniconda2/envs/funannotate/config/

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
if [[ ! -z "${PASACONF}" ]]; then export PASACONF=${PASACONF}; fi
if [[ ! -z "${GENEMARK_PATH}" ]]; then export GENEMARK_PATH=${GENEMARK_PATH}; fi

# Run command
${cmd}
EOF
