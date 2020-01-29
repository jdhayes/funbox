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
sudo singularity build images/funbox.img Singularity # Root privileges are required
export PATH=$PWD/images:$PATH
```

At this point you could transfer the `funbox.img` image to a remote machine if needed.

   3. Setup database:
   
```bash
export SINGULARITY_BINDPATH=/path/to/needed/filesystem #optional
export FUNANNOTATE_DB=/path/to/funannotate_db
funannotate setup -i all
```

   4. Test (replace `--cpus 1` as desired):
   
```bash
funannotate test -t all --cpus 1
```
