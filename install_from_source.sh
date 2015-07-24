#!/bin/sh

#set -x
set -e

# the PREFIX indicates the installation path of the software
# it can be changed to any value here before compiling
PREFIX=$SCRATCH/smnd
VERSION=1.8
PACKAGE=smnd
# used only for cleaning at the moment
BUILDDIRLIST="bufr2netcdf-1.2 cnf-4.0 dballe-7.1 fortrangis-2.4 grib_api-1.10.0 libsim-6.0.2 shapelib-1.3.0 wreport-2.15"


if [ "$1" = "-b" -o -z "$1" ]; then # default action build and install

# temporarily required for compiling
export LD_LIBRARY_PATH=$PREFIX/lib
export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig
export PATH=$PATH:$PREFIX/bin
export FCFLAGS="-I$PREFIX/include"
export CPPFLAGS="-I$PREFIX/include -I$PREFIX/include/dballe"
export LDFLAGS="-L$PREFIX/lib"

mkdir -p $PREFIX

# grib_api (it has to be recompiled because we are using a newer gfortran
# compiler and the .mod are incompatible)
tar -zxvf grib_api-1.10.0.tar.gz
cd grib_api-1.10.0
patch -p0 < ../grib_api-1.10.0_sharepath.diff
rm -rf definitions
tar -zxvf ../grib_api-1.10.0-20130304def.tar.gz
cd definitions
patch -p1 < ../../grib_def_all_simc.patch
cd ..
autoreconf -if
./configure --with-png-support --datadir=$PREFIX/share/grib_api-1.10.0 --with-ifs-samples=$PREFIX/grib_api-1.10.0 --prefix=$PREFIX
make
make install
cd ..

# wreport (low level bufr decoding library)
tar -zxvf wreport-2.15.tar.gz
cd wreport-2.15
./configure --disable-docs --prefix=$PREFIX
make
make install
cd ..

# bufr2netcdf
tar -zxvf bufr2netcdf-1.2.tar.gz
cd bufr2netcdf-1.2
./configure  --prefix=$PREFIX
make
make install
cd ..

# cnf (old C-Fortran interface)
tar -zxvf cnf-4.0.tar.gz
cd cnf-4.0
make
make install prefix=$PREFIX
cd ..

# db-All.e (high level bufr & c. library and tools)
tar -zxvf dballe-7.1.tar.gz
cd dballe-7.1
./configure --disable-dballe-python --enable-dballef --disable-docs --disable-benchmarks --prefix=$PREFIX
make
make install
cd ..

# shapelib (shapefile I/O C library)
#wget http://download.osgeo.org/shapelib/shapelib-1.3.0.tar.gz
tar -zxvf shapelib-1.3.0.tar.gz 
cd shapelib-1.3.0/
make
make install PREFIX=$PREFIX
cd ..

# FortranGIS (Fortran interface to shapelib)
#wget http://sourceforge.net/projects/fortrangis/files/fortrangis/fortrangis-2.4.tar.gz/download
tar -zxvf fortrangis-2.4.tar.gz 
cd fortrangis-2.4
./configure --disable-gdal --disable-proj --disable-doxydoc --prefix=$PREFIX
make
make install
cd ..

# libsim (putting all together)
tar -zxvf libsim-6.0.2.tar.gz
cd libsim-6.0.2
#FCFLAGS="$FCFLAGS -DDBALLELT67" ./configure --enable-f2003-features --enable-f2003-extended-features --enable-f2003-full-features --disable-log4c --disable-oraclesim --enable-alchimia --disable-ngmath --disable-ncarg --disable-netcdf --disable-doxydoc --prefix=$PREFIX
./configure --enable-f2003-features --enable-f2003-extended-features --disable-log4c --disable-oraclesim --enable-alchimia --disable-ngmath --disable-ncarg --disable-netcdf --disable-doxydoc --prefix=$PREFIX
make
make install
cd ..

# documentation
cd doc
make
make install PREFIX=$PREFIX
cd ..

# manual install of the non-packaged files
cp -p install_from_bin.sh $PREFIX
cp -p smnd_preprocess.sh $PREFIX/bin
mkdir -p $PREFIX/share/smnd
cp -a test $PREFIX/share/smnd
# clean ruins of an universal installation
rm -f $PREFIX/unilib/* $PREFIX/unibin/*
rmdir $PREFIX/unilib $PREFIX/unibin || true
# create the profile for local installation
$PREFIX/install_from_bin.sh $PREFIX

echo "The build and installation process has finished,"
echo "all the smnd software suite has been installed"
echo "in $PREFIX directory."
echo "The profile file $HOME/smnd_profile has been created,"
echo "it has to be sourced before using any of the installed commands."
echo "If you decide to relocate the install tree elsewhere from $PREFIX,"
echo "please run the install_from_bin.sh script from the new"
echo "install directory in order to recreate the smnd_profile file."

elif [ "$1" = "-u" ]; then # make the installation universal

# add system libraries for an universal package
rm -f $PREFIX/unilib/* $PREFIX/unibin/*
mkdir -p $PREFIX/unilib $PREFIX/unibin
# install libraries
unset LANG
rm -f /tmp/liblist /tmp/rpmlist
for file in $PREFIX/bin/*; do ldd $file |sed -e 's/^.*>//g' -e 's/ (.*$//g' -e 's/^[ \t]*//g' -e 's/^[^/].*$//g'| egrep -v "$PREFIX|not a dynamic"; done | sort | uniq > /tmp/liblist
for lib in `cat /tmp/liblist`; do cp -p $lib $PREFIX/unilib; done

# create wrappers to executables
for file in $PREFIX/bin/*
do if file $file|grep -q 'ELF.*executable'; then
	ln -s smnd_exec.sh $PREFIX/unibin/${file##*/}
    else
	ln -s ../bin/${file##*/} $PREFIX/unibin
#	cp -p $file $PREFIX/unibin
    fi
done
# create the profile for universal installation
$PREFIX/install_from_bin.sh $PREFIX

echo "The system libraries and links for an universal installation"
echo "have been added in $PREFIX/uni* directories."
echo "Run $0 -p to create a tar package for installation"
echo "on another system."
# create a list of rpms to ditribute for GPL-compliance
if which rpm>/dev/null 2>&1; then
    for lib in `cat /tmp/liblist`; do rpm -qf $lib>>/tmp/rpmlist 2>/dev/null; done
    echo
    echo "If you distribute the package you may have to provide the source files"
    echo "of the following packages for complying with GPL license:"

    sort /tmp/rpmlist | uniq
    rm -f /tmp/rpmlist
fi
rm -f /tmp/liblist

elif [ "$1" = "-p" ]; then # make a package

    cd $PREFIX/..
    if [ -d "$PREFIX/unibin" ]; then # it's an universal install
	TARNAME=${PACKAGE}-${VERSION}_unibin.tar.gz
	tar -czf $TARNAME ${PREFIX##*/}

	echo "An universal installation tar package $TARNAME"
	echo "has been created."
	echo "After unpackaging on the target system, please run the"
	echo "install_from_bin.sh script from the new install directory"
	echo "in order to complete the installation"
	echo "and create the smnd_profile file."

    else
	TARNAME=${PACKAGE}-${VERSION}_bin.tar.gz
	tar -czf $TARNAME ${PREFIX##*/}

	echo "A specific installation tar package $TARNAME"
	echo "has been created."
	echo "After unpackaging on the target system, please run the"
	echo "install_from_bin.sh script from the new install directory"
	echo "in order to create the smnd_profile file."

    fi  

elif [ "$1" = "-s" ]; then # make a source package

    SRCPREFIX=${PWD##*/}
    cd ..
    TARNAME=${PACKAGE}-${VERSION}_src.tar.gz
    tar -czf $TARNAME $SRCPREFIX/*.tar.gz \
	$SRCPREFIX/*.diff \
	$SRCPREFIX/*.patch \
	$SRCPREFIX/*.sh \
	$SRCPREFIX/doc/*.tex \
	$SRCPREFIX/doc/*.eps \
	$SRCPREFIX/doc/Makefile \
	$SRCPREFIX/test

    echo "A source tar package $TARNAME has been created."

elif [ "$1" = "-c" ]; then # clean build directories

    [ -n "$BUILDDIRLIST" ] && rm -rf $BUILDDIRLIST
    (cd doc; make veryclean)

fi
