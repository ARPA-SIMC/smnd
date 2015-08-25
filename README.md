# SMND

### Software for Meteorology Normally Distributed ###
> whatever this may mean

SMND is a container for simplifying the build and the deployment of various meteorological software packages mainly developed by [ARPA-SIMC](http://www.arpa.emr.it/sim). Version 0.9 is a first working version including a Linux x86_64 universal binary release.

The software packages involved, all open source and freely redistributable, are:

 - [grib_api](https://software.ecmwf.int/wiki/display/GRIB/Home) from ECMWF
 - cnf, a C-Fortran interface part of [Starlink software package](http://star-www.rl.ac.uk/docs/sun209.htx/sun209.html)
 - [wreport](https://github.com/ARPA-SIMC/wreport)
 - [bufr2netcdf](https://github.com/ARPA-SIMC/bufr2netcdf)
 - [DB.All-e](https://github.com/ARPA-SIMC/wreport)
 - libsim, free software but not yet published, temporary available at [ARPA-SIMC ftp server](ftp://ftp.smr.arpa.emr.it/incoming/dav/versus/)


## Building the software from source ##
If you wish to build the software packages on your own, you should download a source package in the [release section](https://github.com/dcesari/smnd/releases) of the project, install the required list of dependencies, ensure to have the gcc compiler collection version >= 4.8 and the `wget` command and run the following commands:

```
# download and setup the packages
install_from_source -d
# build and install the packages in $PREFIX
PREFIX=$HOME/installdir install_from_source -b
# at this point you are  have an installation working locally,
# if this is not enough you can continue with:
# make the installation universal
PREFIX=$HOME/installdir install_from_source -b
# make a binary package
PREFIX=$HOME/installdir install_from_source -p
# make a source package
PREFIX=$HOME/installdir install_from_source -s
```

The build process has been tested on Fedora 20 x84_64 GNU/Linux dstribution, it is not supported on other distros/platforms at the moment. For more information, please see the relevant [wiki page](https://github.com/dcesari/smnd/wiki/BuildDoc).

## Installing the universal binary package ##

The most interesting feature ot this project is the universal binary package.

The binary package has been built on a Fedora 20 x86_64 GNU/Linux distribution, however it contains all the necessary libraries, so that, in principle, it can work on any Linux x86_64 system with kernel 2.6.32 or newer.

For installation you just have to unpack the package and run a script:

```
# cd to the desired intallation directory and unpack the package
tar -zxvf smnd-0.9_unibin.tar.gz
# enter the newly created directory
cd smnd
# complete the installation by creating the `$HOME/smnd_profile`
./install_from_bin.sh
```

Before using the software, in an interactive session, you have to source the generated profile with the command `. $HOME/smnd_profile`.

The binary distribution contains various libraries in binary form from Fedora rpms, plese contact the author in order to receive the corresponding source packages for GPL compliance.
