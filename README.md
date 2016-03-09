# SMND

## Software for Meteorology, Normally Distributed ##
> the software for sure, the meteorological data not really.

SMND is a container for simplifying the build and the deployment of a
collection of meteorological software packages, mainly developed by
[Arpae-SIMC](http://www.arpa.emr.it/sim). Version 0.9 is a first
working version including a Linux x86_64 universal binary release.

The software packages involved, all open source and freely redistributable, are:

 - [grib_api](https://software.ecmwf.int/wiki/display/GRIB/Home) from
   ECMWF
 - cnf, a C-Fortran interface part of [Starlink software
   package](http://star-www.rl.ac.uk/docs/sun209.htx/sun209.html)
 - [wreport](https://github.com/ARPA-SIMC/wreport)
 - [bufr2netcdf](https://github.com/ARPA-SIMC/bufr2netcdf)
 - [DB.All-e](https://github.com/ARPA-SIMC/wreport)
 - [libsim](https://github.com/ARPA-SIMC/libsim/archive/v6.1.0-1506.tar.gz)


### Building the software from source ###

If you wish to build the software packages on your own, you should
download a source package in the [release
section](https://github.com/dcesari/smnd/releases) of the project, or
clone it from the git repository, and follow the instructions in the
relevant [wiki page](https://github.com/dcesari/smnd/wiki/BuildDoc).

The build process has been tested on Fedora 20 x84_64 GNU/Linux
dstribution, it is not supported on other distros/platforms at the
moment.

### Installing the universal binary package ###

The most interesting feature ot this project is however the universal
binary package, which is also downloadable in the [release
section](https://github.com/dcesari/smnd/releases).

The binary package has been built on a Fedora 20 x86_64 GNU/Linux
distribution, however it contains all the necessary libraries, so
that, in principle, it can work on any Linux x86_64 system with kernel
2.6.32 or newer.

For installation you do not need to be root, you just have to unpack
the package and run a script:

```
# cd to the desired intallation directory and unpack the package
tar -zxvf smnd-0.9_unibin.tar.gz
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
script has to be rerun from the new location. Alternatively, since
version 1.2, it is possible to set the environment variable
`SMND_PROFILE` to point to the root of the installation, making thus
unnecessary the rerun of `install_from_bin.sh`. This allows to access
the same physical installation of the package, e.g. on an nfs share,
from different mountpoints.

### GPL compliance ###

The universal binary distribution contains various libraries in binary
form from Fedora rpms, please contact the author in order to receive
the corresponding source packages for GPL compliance.

## SMND and SMND ##

The package SMND is not related to the SMND meant as *Servizio
Meteorologico Nazionale Distribuito*, because, according to our
knowledge, Servizio Meteorologico Nazionale Distribuito does not exist
yet. Please inform us when it will be created.
