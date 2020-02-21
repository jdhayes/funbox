#!/bin/bash -l

# Define program name
PROGNAME=$(basename $0)

# Load software
module load funannotate/1.7.3_sing

# Define stop mysqldb
stop_mysqldb() { singularity instance stop mysqldb; }

# Set trap to ensure mysqldb is stopped
trap "stop_mysqldb; exit 130" SIGHUP SIGINT SIGTERM

# Define error handler
error_exit()
{
    stop_mysqldb
	echo "${PROGNAME}: ${1:-"Unknown Error"}" 1>&2
	exit 1
}

# Set some vars
export SINGULARITY_BINDPATH=/bigdata
export FUNANNOTATE_DB=/bigdata/operations/jhayes/singularity/funannotate/funannotate_db
export PASACONF=/rhome/jhayes/pasa.CONFIG.template
export GENEMARK_PATH=/opt/genemark/gm_et_linux_64

# Determin CPUS
if [[ -z ${SLURM_CPUS_ON_NODE} ]]; then
    CPUS=$1
else
    CPUS=${SLURM_CPUS_ON_NODE}
fi

# Validate CPUS
if [[ ${CPUS} -gt 64 ]] || [[ ${CPUS} -lt 1 ]]; then
    echo "You cannot run with $CPUS number of CPUS"
    exit 1
fi

# Go to database directory
OLD_PWD=${PWD}
cd ~/bigdata/mysql

# Start Database
PORT=$(singularity exec --writable-tmpfs -B db/:/var/lib/mysql mariadb.sif grep -oP '^port = \K\d{4}' /etc/mysql/my.cnf | head -1)
singularity instance start --writable-tmpfs -B db/:/var/lib/mysql mariadb.sif mysqldb
sleep 10

# Move back to initial directory
cd ${OLD_PWD}

# Update PASA DB config
sed -i "s/^MYSQLSERVER.*$/MYSQLSERVER=${HOSTNAME}:${PORT}/" ${SINGULARITYENV_PASACONF}

# Clean
funannotate clean -i FungiDB-46_AfumigatusAf293_Genome.fasta --minlen 100 -o ref.cleaned.fa || { error_exit "$LINENO: Failed to clean"; }

# Sort
funannotate sort -i ref.cleaned.fa -b scaffold -o ref.cleaned.sorted.fa || { error_exit "$LINENO: Failed to sort"; }

# SoftMask
funannotate mask -i ref.cleaned.sorted.fa --cpus 12 -o MyAssembly.fa || { error_exit "$LINENO: Failed to mask'"; }

# Train
funannotate train -i MyAssembly.fa -o fun --pasa_db mysql \
    --left PRJNA376829_R1.fq.gz \
    --right PRJNA376829_R2.fq.gz \
    --stranded RF --jaccard_clip --species "Aspergillus fumigatus" \
    --strain "Af293" --cpus $CPUS \
    || { error_exit "$LINENO: Failed to train"; }

# Stop Database
stop_mysqldb

