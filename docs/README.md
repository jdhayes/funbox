# Inital Setup
You need to create a Funannotate database, or you need to symlink an existing one to a directory in which you have read/write access.

## Create DB
After you have funannotate installed, you can create a Funannotate DB, like so:

```
funannotate setup -d /path/to/DB -i all -b all
```

## Shared DB
Might be better to share a single Funannotate DB, instead of creating a new one.
Try symlinking all the DB files into a writeable directory, like so:
```
mkdir funannotatedb
cd funannotatedb
ln -s /path/to/shared/DB/* .
```

# Databases
## SQLite
Funannotate is configured to utilize SQLite by default, and no additional setup is required.

## MySQL/MariaDB
Using MySQL/MariaDB is much faster than SQLite, however some additoinal setup is required.

1. First, create a database instance. To create a MySQL/MariaDB instance, all you need to do is run the following command:

```bash
create_mysql_db
```
More details regarding this command can be found [here](https://github.com/ucr-hpcc/hpcc_slurm_examples/tree/master/singularity/mariadb).

2. Decied whether you want to run a single job, or many funannotate jobs using the same database backend.

### Single Job
You can run the MySQL/MariaDB instance in the same job as funannotate.
An example of this is [here](https://raw.githubusercontent.com/jdhayes/funbox/master/scripts/fun_workflow.sh).
This is a simple self-contained example that allows a single database per funannotate job.

### Separate Jobs
You can use this [start_mariadb.sh](https://raw.githubusercontent.com/ucr-hpcc/hpcc_slurm_examples/master/singularity/mariadb/start_mariadb.sh) startup script to start your database in a separate job. Once started, subsequent funannotate jobs could all use this same database.
