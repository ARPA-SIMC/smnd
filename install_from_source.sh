#!/bin/sh

set -e

VERSION=2.4
PACKAGE=smnd
EXTRA_LIBRARIES1="libnss_files libnss_dns libnss_myhostname libcap libdw libattr libelf liblzma libbz2"
EXTRA_LIBRARIES2="libsoftokn3 libfreeblpriv3 libnsssysinit"
LIBDIR=/usr/lib64

# the PREFIX indicates the installation path of the software
# if not set it takes the default here
: ${PREFIX:=$SCRATCH/$PACKAGE-$VERSION}

# list of action functions
ACTIONLIST="do_grib_api do_wreport do_bufr2netcdf do_dballe do_arkimet do_fortrangis do_libsim do_ma_utils"
# source package specific action functions
. ./action.sh

if [ "$1" = "-d" ]; then # download and setup (unpack, autoreconf if needed)
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

# manual install of the non-packaged files
cp -p install_from_bin.sh $PREFIX
cp -p smnd_preprocess.sh $PREFIX/bin
mkdir -p $PREFIX/share/smnd
cp -a test $PREFIX/share/smnd
# clean ruins of an universal installation
rm -f $PREFIX/unilib/* $PREFIX/unibin/*
rmdir $PREFIX/unilib $PREFIX/unibin 2>/dev/null || true
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
# extra dl-opened libraries (empirically determined)
for lib in $EXTRA_LIBRARIES1; do cp -p $LIBDIR/$lib.so.* $PREFIX/unilib; done
# special treatment
for lib in $EXTRA_LIBRARIES2; do cp -p $LIBDIR/$lib.* $PREFIX/unilib; done
# create links to executables' wrapper
for file in $PREFIX/bin/*
do if file -L $file|grep -q 'ELF.*executable'; then
	ln -s smnd_exec.sh $PREFIX/unibin/${file##*/}
    else
	ln -s ../bin/${file##*/} $PREFIX/unibin
    fi
done

# create executables wrapper
LD=`echo $PREFIX/unilib/ld*`
LD=${LD##*/}

cat > $PREFIX/unibin/smnd_exec.sh <<EOF
#!/bin/sh
: \${GRIB_DEFINITION_PATH:=\$SMND_PREFIX/share/grib_api/definitions}
export GRIB_DEFINITION_PATH
export LOG4C_PRIORITY=600
export WREPORT_TABLES=\$SMND_PREFIX/share/wreport
export B2NC_TABLES=\$SMND_PREFIX/share/bufr2netcdf
export DBA_TABLES=\$SMND_PREFIX/share/wreport
export DBA_REPINFO=\$SMND_PREFIX/share/wreport/repinfo.csv
export LIBSIM_DATA=\$SMND_PREFIX/share/libsim
export ARKI_SCAN_GRIB1=\$SMND_PREFIX/etc/arkimet/scan-grib1
export ARKI_SCAN_GRIB2=\$SMND_PREFIX/etc/arkimet/scan-grib2
export ARKI_SCAN_BUFR=\$SMND_PREFIX/etc/arkimet/scan-bufr
export ARKI_SCAN_ODIMH5=\$SMND_PREFIX/etc/arkimet/scan-odimh5
export ARKI_FORMATTER=\$SMND_PREFIX/etc/arkimet/format
export ARKI_REPORT=\$SMND_PREFIX/etc/arkimet/report
export ARKI_BBOX=\$SMND_PREFIX/etc/arkimet/bbox
export ARKI_QMACRO=\$SMND_PREFIX/etc/arkimet/qmacro
export ARKI_TARGETFILE=\$SMND_PREFIX/etc/arkimet/targetfile
: \${ARKI_ALIASES:=\$SMND_PREFIX/etc/arkimet/match-alias.conf}
export ARKI_ALIASES
CMD=\${0##*/}
exec \$SMND_PREFIX/unilib/$LD --library-path \$SMND_PREFIX/unilib:\$SMND_PREFIX/lib \$SMND_PREFIX/bin/\$CMD "\$@"
EOF

chmod +x $PREFIX/unibin/smnd_exec.sh

# create the profile for universal installation
$PREFIX/install_from_bin.sh $PREFIX

echo "The system libraries and links for an universal installation"
echo "have been added in $PREFIX/uni* directories."
echo "Run $0 -p to create a tar package for installation"
echo "on another system."
# create a list of rpms to distribute for GPL-compliance
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

    if [ -d "$PREFIX/unibin" ]; then # it's an universal install
	TARNAME=${PACKAGE}-${VERSION}_unibin.tar.gz
	tar -C $PREFIX/.. -czf $TARNAME \
	    --exclude=${PREFIX##*/}/include --exclude=${PREFIX##*/}/share/doc \
	    ${PREFIX##*/}

	echo "An universal installation tar package $TARNAME"
	echo "has been created."
	echo "After unpackaging on the target system, please run the"
	echo "install_from_bin.sh script from the new install directory"
	echo "in order to complete the installation"
	echo "and create the smnd_profile file."

    else
	TARNAME=${PACKAGE}-${VERSION}_bin.tar.gz
	tar -C $PREFIX/.. -czf $TARNAME \
	    --exclude=${PREFIX##*/}/include --exclude=${PREFIX##*/}/share/doc \
	    ${PREFIX##*/}

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

    echo "A source tar package $TARNAME has been created"
    echo "in upper-level directory."

elif [ "$1" = "-c" ]; then # clean build directories
    for act in $ACTIONLIST; do $act -c; done
    [ -n "$PREFIX" -a "$PREFIX" != "/" ] && rm -rf $PREFIX/

elif [ "$1" = "-l" ]; then # clean source files

    for act in $ACTIONLIST; do $act -l; done

fi
