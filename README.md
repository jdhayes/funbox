# FunBox
This is a singularity container designed to be a portable and complete funannotate black box.

## How to use

  1. Download this repo:

```bash
git clone git@github.com:jdhayes/funbox.git
```

  2. Build container image:

```bash
cd funbox
singularity build images/funbox.img Singularity
export PATH=$PWD/images:$PATH
```

   3. Setup database:
   
```bash
export FUNANNOTATE_DB=/path/to/funannotate_db
funannotate setup -i all
```

   4. Test (replace `--cpus 1` as desired):
   
```bash
funannotate test -t all --cpus 1
```
