## Running SMND from a container ##

The project provides a container definition file suitable for creating
a [singularity](https://sylabs.io/singularity/) container including
all the software collection. The container is based on the CentOS 7
packages, but it can be built and run on any Linux x86_64 distribution
where the singularity package (version 2.5 or later) is installed.

The container has to be built as `root` user, but it can be built on
any system, such as a personal laptop or a virtual machine; after
build it can be used, without being root, on any system where the
singularity software is installed, such as an HPC cluster.

For building a container, download the
[centos7-smnd-run.def](https://github.com/ARPA-SIMC/smnd/blob/master/centos7-smnd-run.def)
recipe file from the SMND repository and run:

```
singularity build ./centos7-smnd.sif centos7-smnd-run.def
```

This will take some time and require a good internet connection for
downloading and installing the software packages and libraries in the
container. At the end of the process you will obtain a single big
executable file `centos7-smnd.sif` (also called "image") containing
all the tools and libraries. It can be ported on any system where
singularity software is installed.

To run a tool within the container, simply launch the container image
executable followed by the desired command and arguments, e.g. for
vg6d_transform:

```
./centos7-smnd.sif vg6d_transform --trans-type=zoom --sub-type=coord \
  --ilon=5. --flon=16. --ilat=40. --flat=48. input.grib output.grib
```

For more information, see the [singularity
documentation](https://sylabs.io/guides/3.3/user-guide/quick_start.html#interact-with-images).

