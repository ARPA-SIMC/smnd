#!/bin/sh

if [ "$1" = "-h" ]; then
    echo "Usage: $0 [<install prefix>]"
    echo "where <install prefix> is the directory containing bin/ lib/ ..."
    echo "in which the smnd software suite has been installed,"
    echo "if it is not provided, the current directory is used."
    exit 1
fi

PREFIX=${1:-$PWD}

if [ ! -f "$PREFIX/bin/vg6d_transform" ]; then
    echo "Warning: $PREFIX does not seem to contain an installation"
    echo "of the smnd software suite, however I will continue anyway."
    echo "Please rerun $0 -h for more help"
fi

if [ -d "$PREFIX/unibin" ]; then

    echo "Creating profile in $HOME/smnd_profile for"
    echo "universal installation under path $PREFIX"

    cat <<EOF > $HOME/smnd_profile
if [ -z "\$SMND_PROFILE" ]; then
export PATH=$PREFIX/unibin:\$PATH
export SMND_PREFIX=$PREFIX
export SMND_PROFILE=1
fi
EOF

else

    echo "Creating profile in $HOME/smnd_profile for"
    echo "local installation under path $PREFIX"

    cat <<EOF > $HOME/smnd_profile
if [ -z "\$SMND_PROFILE" ]; then
export LD_LIBRARY_PATH=\${LD_LIBRARY_PATH:+\$LD_LIBRARY_PATH:}$PREFIX/lib
export PATH=$PREFIX/bin:\$PATH
export GRIB_DEFINITION_PATH=$PREFIX/share/grib_api/definitions
export LOG4C_PRIORITY=600
export WREPORT_TABLES=$PREFIX/share/wreport
export B2NC_TABLES=$PREFIX/share/bufr2netcdf
export DBA_TABLES=$PREFIX/share/wreport
export LIBSIM_DATA=$PREFIX/share/libsim
export SMND_PROFILE=1
fi
EOF

fi
