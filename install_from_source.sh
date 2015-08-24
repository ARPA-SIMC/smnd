#!/bin/sh

#set -x
set -e

# the PREFIX indicates the installation path of the software
# it can be changed to any value here before compiling
PREFIX=$SCRATCH/smnd
VERSION=0.9
PACKAGE=smnd
# list of action functions
ACTIONLIST="do_grib_api do_wreport do_bufr2netcdf do_cnf do_dballe do_fortrangis do_libsim"
# source package specific action functions
. ./action.sh

if [ "$1" = "-d" ]; then # download and setup
    for act in $ACTIONLIST; do $act -d; done

elif [ "$1" = "-b" -o -z "$1" ]; then # default action build and install

# temporarily required for compiling
export LD_LIBRARY_PATH=$PREFIX/lib
export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig
export PATH=$PATH:$PREFIX/bin
export FCFLAGS="-I$PREFIX/include"
export CPPFLAGS="-I$PREFIX/include -I$PREFIX/include/dballe"
export LDFLAGS="-L$PREFIX/lib"

mkdir -p $PREFIX
for act in $ACTIONLIST; do $act -b; done

# documentation
#cd doc
#make
#make install PREFIX=$PREFIX
#cd ..

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
    tar -czf $TARNAME $SRCPREFIX/*.sh \
	$SRCPREFIX/LICENSE \
	$SRCPREFIX/README* \
	$SRCPREFIX/test

    # tar -czf $TARNAME $SRCPREFIX/*.tar.gz \
    # 	$SRCPREFIX/*.diff \
    # 	$SRCPREFIX/*.patch \
    # 	$SRCPREFIX/*.sh \
    # 	$SRCPREFIX/doc/*.tex \
    # 	$SRCPREFIX/doc/*.eps \
    # 	$SRCPREFIX/doc/Makefile \
    # 	$SRCPREFIX/test

    echo "A source tar package $TARNAME has been created."

elif [ "$1" = "-c" ]; then # clean build directories

    for act in $ACTIONLIST; do $act -c; done
#    (cd doc; make veryclean)

fi
