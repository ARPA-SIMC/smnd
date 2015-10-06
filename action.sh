# action function specific to every package (download, build and clean)

download_and_setup() {
    for url in $@; do
	file=${url##*/}
	[ -f "$file" ] || wget -O $file $url
	if [  "${file%tar.gz}" != "$file" ]; then
	    tar -zxvf $file
#	elif [ -z "${file%gz}" ]; then
#	    gunzip -c $file > ${file%gz}
	fi
    done
}

clean_source() {
    for url in $@; do
	file=${url##*/}
	rm -f $file
    done
}

do_grib_api() {
    dir=grib_api-1.13.1
    url=https://software.ecmwf.int/wiki/download/attachments/3473437/grib_api-1.13.1.tar.gz

    if [ "$1" = "-d" ]; then
	download_and_setup $url
    elif [ "$1" = "-b" ]; then
	cd $dir
# --with-ifs-samples=$PREFIX/$dir
	./configure --with-png-support --datadir=$PREFIX/share --prefix=$PREFIX
	make
	make install
	cd ..
    elif [ "$1" = "-c" ]; then
	[ -n "$dir" ] && rm -rf $dir
    elif [ "$1" = "-l" ]; then
	clean_source $url
    fi
}

do_wreport() {
    dir=wreport-2.15-4628
    url=https://github.com/ARPA-SIMC/wreport/archive/v2.15-4628.tar.gz

    if [ "$1" = "-d" ]; then
	download_and_setup $url
	cd $dir
	autoreconf -if
	cd ..
    elif [ "$1" = "-b" ]; then
	cd $dir
	./configure --disable-docs --prefix=$PREFIX
	make
	make install
	cd ..
    elif [ "$1" = "-c" ]; then
	[ -n "$dir" ] && rm -rf $dir
    elif [ "$1" = "-l" ]; then
	clean_source $url
    fi
}

do_bufr2netcdf() {
    dir=bufr2netcdf-1.2-3959
    url=https://github.com/ARPA-SIMC/bufr2netcdf/archive/v1.2-3959.tar.gz

    if [ "$1" = "-d" ]; then
	download_and_setup $url
	cd $dir
	autoreconf -if
	cd ..
    elif [ "$1" = "-b" ]; then
	cd $dir
	./configure --prefix=$PREFIX
	make
	make install
	cd ..
    elif [ "$1" = "-c" ]; then
	[ -n "$dir" ] && rm -rf $dir
    elif [ "$1" = "-l" ]; then
	clean_source $url
    fi
}

do_cnf() {
    dir=cnf-4.0
    url="http://ftp.debian.org/debian/pool/main/c/cnf/cnf_4.0.orig.tar.gz http://ftp.debian.org/debian/pool/main/c/cnf/cnf_4.0-2.diff.gz"

    if [ "$1" = "-d" ]; then
	download_and_setup $url
	cd $dir
	gunzip -c ../cnf_4.0-2.diff.gz | patch -p1
	cd ..
    elif [ "$1" = "-b" ]; then
	cd $dir
	make
	make install prefix=$PREFIX
	cd ..
    elif [ "$1" = "-c" ]; then
	[ -n "$dir" ] && rm -rf $dir
    elif [ "$1" = "-l" ]; then
	clean_source $url
    fi
}

do_dballe() {
    dir=dballe-7.1-4837
    url=https://github.com/ARPA-SIMC/dballe/archive/v7.1-4837.tar.gz

    if [ "$1" = "-d" ]; then
	download_and_setup $url
	cd $dir
	autoreconf -if
	cd ..
    elif [ "$1" = "-b" ]; then
	cd $dir
# --disable-benchmarks
	./configure --disable-dballe-python --enable-dballef --disable-docs --prefix=$PREFIX
	make
	make install
	cd ..
    elif [ "$1" = "-c" ]; then
	[ -n "$dir" ] && rm -rf $dir
    elif [ "$1" = "-l" ]; then
	clean_source $url
    fi
}

do_fortrangis() {
    dir=fortrangis-2.4
    url=http://sourceforge.net/projects/fortrangis/files/fortrangis/fortrangis-2.4.tar.gz

    if [ "$1" = "-d" ]; then
	download_and_setup $url
    elif [ "$1" = "-b" ]; then
	cd $dir
	./configure --disable-gdal --disable-proj --disable-doxydoc --prefix=$PREFIX
	make
	make install
	cd ..
    elif [ "$1" = "-c" ]; then
	[ -n "$dir" ] && rm -rf $dir
    elif [ "$1" = "-l" ]; then
	clean_source $url
    fi
}

do_libsim() {
    dir=libsim-6.1.0
    url=https://github.com/ARPA-SIMC/libsim/archive/v6.1.0-1506.tar.gz
#ftp://ftp.smr.arpa.emr.it/incoming/dav/versus/libsim-6.1.0.tar.gz

    if [ "$1" = "-d" ]; then
	download_and_setup $url
    elif [ "$1" = "-b" ]; then
	cd $dir
	./configure --enable-f2003-features --enable-f2003-extended-features --disable-log4c --disable-oraclesim --enable-alchimia --disable-ngmath --disable-ncarg --disable-netcdf --disable-doxydoc --prefix=$PREFIX
	make
	make install
	cd ..
    elif [ "$1" = "-c" ]; then
	[ -n "$dir" ] && rm -rf $dir
    elif [ "$1" = "-l" ]; then
	clean_source $url
    fi
}
