## List of dependencies ##

If you wish to build all the software packages on your own, here you
find the approximate list of packages that have to be installed for
building and deploying the SMND collection from source. The list is
based on a Fedora distribution and rpm packages, so it has to be
adapted if a different distribution is used. Notice that the use of
gcc compiler collection version 4.8 or higher is a strict
requirement. The lists are not guaranteed to be complete.

### Build and runtime dependencies ###

The following packages have to be installed on the system where you
are going to build the SMND collection, as well as on a system where
you wish to simply deploy a binary (non universal) installation:

cyrus-sasl-lib, geos, glibc, hdf5, jasper-libs, keyutils-libs,
krb5-libs, libcom_err, libcurl, libgcc, libgfortran, libidn,
libjpeg-turbo, libpng, libquadmath, libselinux, libssh2, libstdc++,
libtool-ltdl, lua, lzo, mariadb-libs, ncurses-libs, netcdf,
netcdf-cxx, nspr, nss, nss-softokn-freebl, nss-util, openjpeg-libs,
openldap, openssl-libs, pcre, popt, postgresql-libs, readline,
shapelib, sqlite, unixODBC, xz-libs, zlib.

### Build dependencies ###

The following packages have to be installed on the system where you
are going to build the SMND collection, in addition to the previous
package list:

gcc* >=4.8, wget, make, patch, autoconf, automake, libtool, gperf,
help2man, file, flex, geos-devel, glibc-devel, hdf5-devel,
keyutils-libs-devel, libcom_err-devel, libcurl-devel, libidn-devel,
libjpeg-turbo-devel, libpng-devel, libquadmath-devel,
libselinux-devel, libssh2-devel, libstdc++-devel, libtool-ltdl-devel,
lzo-devel, lua-devel, netcdf-devel, netcdf-cxx-devel, nspr-devel,
nss-devel, nss-softokn-freebl-devel, nss-util-devel, openldap-devel,
pcre-devel, popt-devel, shapelib-devel, sqlite-devel, unixODBC-devel,
zlib-devel, jasper-devel, krb5-devel, mariadb-devel, openjpeg-devel,
openssl-devel, postgresql-devel, readline-devel, xz-devel.
