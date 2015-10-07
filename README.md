# SMND

## Software for Meteorology, Normally Distributed ##
> the software for sure, often the meteorology as well.

SMND is a container for simplifying the build and the deployment of a
collection of meteorological software packages, mainly developed by
[ARPA-SIMC](http://www.arpa.emr.it/sim). Version 0.9 is a first
working version including a Linux x86_64 universal binary release.

The software packages involved, all open source and freely redistributable, are:

 - [grib_api](https://software.ecmwf.int/wiki/display/GRIB/Home) from
 - ECMWF cnf, a C-Fortran interface part of [Starlink software
   package](http://star-www.rl.ac.uk/docs/sun209.htx/sun209.html)
 - [wreport](https://github.com/ARPA-SIMC/wreport)
 - [bufr2netcdf](https://github.com/ARPA-SIMC/bufr2netcdf)
 - [DB.All-e](https://github.com/ARPA-SIMC/wreport)
 - [libsim](https://github.com/ARPA-SIMC/libsim/archive/v6.1.0-1506.tar.gz)


### Building the software from source ###

If you wish to build the software packages on your own, you should
download a source package in the [release
section](https://github.com/dcesari/smnd/releases) of the project and
follow the instructions in the relevant [wiki
page](https://github.com/dcesari/smnd/wiki/BuildDoc).

The build process has been tested on Fedora 20 x84_64 GNU/Linux
dstribution, it is not supported on other distros/platforms at the
moment.

### Installing the universal binary package ###

The most interesting feature ot this project is the universal binary
package.

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
# complete the installation by creating the `$HOME/smnd_profile`
./install_from_bin.sh
```

In order to run any command of the SMND collection, you have to
preliminary source the profile once with `. $HOME/smnd_profile` in the
working session.

### GPL compliance ###

The universal binary distribution contains various libraries in binary
form from Fedora rpms, plese contact the author in order to receive
the corresponding source packages for GPL compliance.
