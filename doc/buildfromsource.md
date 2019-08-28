## Building the SMND package from source ##

### Building and installing ###

The build process has been tested on Fedora 28 and CentOS 7 x84_64
GNU/Linux distributions, it is not supported on other
distros/platforms at the moment.

If you wish to build all the software packages on your own, you should
download a copy of the SMND source package (which does not include the
real software sources, just the build system) in the [releases
section](https://github.com/dcesari/smnd/releases) of the project or
by cloning the github master branch, install the required [list of
dependencies](ListOfDependencies), including the gcc compiler
collection version >= 4.8 and the `wget` command, and run the
following list of commands:

```
# untar (or unzip)
tar -zxvf vX.Y.tar.gz
cd smnd-X.Y
# download and setup the source packages
# (only missing sources are downloaded, wget must be configured to work)
install_from_source.sh -d
# build all the packages and install in $PREFIX (takes a long time)
PREFIX=$HOME/smnd_install install_from_source.sh -b
```

If you are lucky, at this point you have a working local installation
in `$PREFIX` and a profile file installed in `$HOME/smnd_profile`, no
other parts of the filesystem are touched; in order to run any command
of the SMND collection, you have to preliminary source the profile
once with `. $HOME/smnd_profile` in the working session.

At this point you can create a binary package for deployment on an
analogous system with the command:

```
# make a binary package
PREFIX=$HOME/installdir install_from_source.sh -p
```

When you unpack the binary package on a different system or when you
relocate an installation after a build, you have to run the
`install_from_bin.sh` script located in the main installation
directory in order to recreate the profile for the new or relocated
installation.

### Making an universal installation ###

If you wish to deploy an installation on a distribution different from
the one where the software has been built, you can make the
installation universal before creating the binary package:

```
# make the installation universal
PREFIX=$HOME/installdir install_from_source.sh -u
# make a binary package
PREFIX=$HOME/installdir install_from_source.sh -p
```

this will embed in the binary package all the shared libraries upon
which the executables depend and create wrappers to executables where
the environment is properly set up.

### Making a source package ###

```
# make a source package
PREFIX=$HOME/installdir install_from_source.sh -s
```

### Cleaning up ###

```
# remove build directories
install_from_source.sh -c
# remove source files
install_from_source.sh -l
```

