# SMND

## Software for Meteorology, Normally Distributed ##
> the software for sure, the meteorological data not really.

SMND is a helper package for simplifying the build and the deployment
of a collection of meteorological software packages, mainly developed
by [Arpae-SIMC](http://www.arpa.emr.it/sim). The current version is
relatively stable, including the universal binary package.

The software packages involved, all open source and freely redistributable, are:

 - [grib_api](https://software.ecmwf.int/wiki/display/GRIB/Home) from
   ECMWF
 - [wreport](https://github.com/ARPA-SIMC/wreport)
 - [bufr2netcdf](https://github.com/ARPA-SIMC/bufr2netcdf)
 - [DB.All-e](https://github.com/ARPA-SIMC/dballe)
 - [arkimet](https://github.com/ARPA-SIMC/arkimet)
 - [libsim](https://github.com/ARPA-SIMC/libsim)

### Building the software from source ###

If you wish to build the software packages on your own, please follow
the instructions in the relevant [wiki
page](https://github.com/ARPA-SIMC/smnd/wiki/BuildFromSource).

The build process has been tested on Fedora 20 and 24 and on CentOS 7
x84_64 GNU/Linux dstributions, it is not supported on other
distros/platforms at the moment.

### Installing the universal binary package ###

The most interesting feature ot this project is however the universal
binary package, which is also downloadable in the [release
section](https://github.com/dcesari/smnd/releases).

The binary package has been built on a Fedora 24 x86_64 GNU/Linux
distribution, however it contains all the necessary libraries, so
that, in principle, it can work on any Linux x86_64 system with kernel
2.6.32 or newer.

For installation you do not need to be root, you just have to unpack
the package and run a script:

```
# cd to the desired intallation directory and unpack the package
tar -zxvf smnd-*.*_unibin.tar.gz
# enter the newly created directory
cd smnd
# complete the installation by creating wrappers to executables
# and the `$HOME/smnd_profile`
./install_from_bin.sh
```

In order to run any command of the SMND collection, you have to
preliminary source the profile once with `. $HOME/smnd_profile` in the
working session. The profile for universal installation just prepends
`unibin/` to the `PATH` environment variable, so it can be integrated
with the user's shell profile scripts or moved to a different
location.

If you relocate the binary installation, the `install_from_bin.sh`
script has to be rerun from the new location.

Before version 2.0, a single universal binary installation, after
running the `install_from_bin.sh` script, records an hardcoded value
of the absolute installation path, so it is usable only if reached
under that path. Since version 2.0 it is possible to access the same
physical installation from different paths, e.g. when it is on an nfs
share having different mountpoints on different systems; for that
purpose, the `install_from_bin.sh` should be run from within every
system involved for creating a specialized `smnd_profile` file.

The binary installation turns out to be a self-made container. For the
use within a real container, please read further.

### GPL compliance ###

The universal binary distribution contains various libraries in binary
form from Fedora rpms, please contact the author in order to receive
the corresponding source packages for GPL compliance.

### SMND within a container ###

The project provides also 3 container definition files to help using,
building **with** or building the software on one's own:

 * `centos7-smnd-run.def` allows to run the tools of smnd package
   within a CentOS 7 container, more or less eqivalent to the unibin
   package

 * `centos7-smnd-devel.def` allows to build and run software that
   makes use of the C/C++/Fortran libraries provided by the various
   smnd package (wreport, DB-All.e, arkimet, libsim) within a CentOS 7
   container

 * `centos7-smnd-build.def` provides an environment where you can
   build all the smnd software from source.

The first and second containers make use of the precompiled packages
in the SIMC
[copr](https://copr.fedorainfracloud.org/coprs/simc/stable/)
repository, available for CentOS 7 and for the latest Fedora GNU/Linux
distributions, while the third container makes use of only standard
packages provided in the distribution. With minor adaptations the
containers could be built on the base of Fedora 26-28 as well.

The containers have been tested with
[singularity](https://github.com/singularityware/singularity), version
2.5.1 on a Fedora 24 system. This work is still experimental and has
undergone limited testing. The following paragraphs explain how to
build and use the containers.

#### centos7-smnd-run.def ####

For this container it is suggested to build a squashfs read-only image
(singularity default as of version 2.5.1):

```
singularity build ./centos7-smnd centos7-smnd-run.def
```

to run a tool within the container, simply run the container file
followed by the desired command and arguments, e.g. for
vg6d_transform:

```
./centos7-smnd vg6d_transform --trans-type=zoom --sub-type=coord \
  --ilon=5. --flon=16. --ilat=40. --flat=48. input.grib output.grib
```

#### centos7-smnd-devel.def ####

For this container it is suggested to build a "sandbox" writable
image:

```
singularity build --sandbox ./centos7-smnd centos7-smnd-run.def
```

for building software within the container, simply open a shell and
work normally within the container:

```
singularity shell -w ./centos7-smnd
Singularity: Invoking an interactive shell within container...

Singularity centos7-smnd:~> gfortran -c myprogram.f90 -I/usr/lib64/gfortran/modules
...

```

#### centos7-smnd-build.def ####

Also for this container it is suggested to build a "sandbox" writable
image:

```
singularity build --sandbox ./centos7-smnd centos7-smnd-build.def
```

for building all the smnd software within the container, open a shell,
dounload the smnd package and build it inside the container:

```
singularity shell -w ./centos7-smnd
Singularity: Invoking an interactive shell within container...

Singularity centos7-smnd:~> git clone https://github.com/ARPA-SIMC/smnd.git
Singularity centos7-smnd:~> cd smnd
Singularity centos7-smnd:~> ./install_from_source.sh -d
Singularity centos7-smnd:~> ./install_from_source.sh
...

```

## SMND and SMND ##

The package SMND is not related to the **SMND** meant as the Italian
*Servizio Meteorologico Nazionale Distribuito*, which does not exist
at the moment.

> Il pacchetto software SMND non ha nessun legame con il **Servizio
> Meteorologico Nazionale Distribuito** che al momento non esiste.
