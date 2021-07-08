## Running SMND from a container ##

The SMND project provides a container definition file suitable for
creating a [singularity](https://sylabs.io/singularity/) container
including all the software collection. The container is based on the
CentOS 7 packages, but it can be built and run on any Linux x86_64
distribution where the singularity package (version 2.5 or later) is
installed.

### Building the container ###

The container has to be built as `root` user, but it can be built on
any system, such as a personal laptop or a virtual machine; after
build it can be used, without being root, on any system where the
singularity software is installed, such as an HPC cluster.

For building a container, download the
[Singularity.smnd-run](https://github.com/ARPA-SIMC/smnd/blob/master/Singularity.smnd-run)
recipe file from the SMND repository and run:

```
singularity build ./smnd-run.sif Singularity.smnd-run
```

This will take some time and require a good internet connection for
downloading and installing the software packages and libraries in the
container. At the end of the process you will obtain a single big
executable file `smnd-run.sif` (also called "image") containing all
the tools and libraries. It can be ported on any system where
singularity software is installed.

### Downloading a pre-built container ###

A pre-built container for smnd is available on the [SylabsCloud
library public
service](https://cloud.sylabs.io/library/dcesari/default/smnd), as an
alternative to building it on one's own.

In order to download it you need to install the singularity package
version 3.0 or later and pull the container with the command:

```
singularity pull library://dcesari/default/smnd:latest
```

obtaining the file `smnd_latest.sif`. The container on SylabsCloud
library is built manually from time to time, so it may not contain the
latest versions of the software as it is the case with a self-built
container.

### Running executables within the container ###

To run a tool within the container, simply launch the container image
executable followed by the desired command and arguments, e.g. for
vg6d_transform:

```
./smnd-run.sif vg6d_transform --trans-type=zoom --sub-type=coord \
  --ilon=5. --flon=16. --ilat=40. --flat=48. input.grib output.grib
```

For more information, see the [singularity
documentation](https://sylabs.io/guides/3.3/user-guide/quick_start.html#interact-with-images).

