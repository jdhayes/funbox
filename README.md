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
```

At this point you could transfer the `funbox.img` image and `funannotate` symlink to a remote machine if needed.

   3. Add parent directory to PATH:
   
   ```bash
   export PATH=/path/to/image/and/symlink/directory:$PATH
   ```

   4. Setup database:
   
```bash
export SINGULARITY_BINDPATH=/path/to/needed/filesystem #optional
export FUNANNOTATE_DB=/path/to/funannotate_db
funannotate setup -i all
```

   5. Test (replace `--cpus 1` as desired):
   
```bash
funannotate test -t all --cpus 1
```
