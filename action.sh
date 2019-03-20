# action function specific to every package ([d]ownload, [b]uild,
# [c]lean source tree, c[l]ean source package)

download_and_setup() {
    for url in $@; do
	# get file from url
	file=${url##*/}
	# get package name from unpack dir
	name=${dir%%-*}
	# if file from url is not unique, prepend package name
	tarname=${file%%-*}
	if [ "$tarname" != "$name" ]; then
	    file=$name$file
	fi
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
    dir=grib_api-1.16.0-Source
    url=https://software.ecmwf.int/wiki/download/attachments/3473437/grib_api-1.16.0-Source.tar.gz

    if [ "$1" = "-d" ]; then
	download_and_setup $url
    elif [ "$1" = "-b" ]; then
	cd $dir
# --with-ifs-samples=$PREFIX/$dir
	./configure --disable-static --with-png-support --datadir=$PREFIX/share --prefix=$PREFIX
	make
	make install
	cd ..
    elif [ "$1" = "-c" ]; then
	[ -n "$dir" ] && rm -rf $dir
    elif [ "$1" = "-l" ]; then
	clean_source $url
    fi
}

do_eccodes() {
    dir=-2.9.1-Source
    url="https://confluence.ecmwf.int/download/attachments/45757960/eccodes-2.9.2-Source.tar.gz?api=v2"

    if [ "$1" = "-d" ]; then
	download_and_setup $url
    elif [ "$1" = "-b" ]; then
	cd $dir
# --with-ifs-samples=$PREFIX/$dir
	./configure --disable-static --with-png-support --datadir=$PREFIX/share --prefix=$PREFIX
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
    dir=wreport-3.19-1
    url=https://github.com/ARPA-SIMC/wreport/archive/v3.19-1.tar.gz

    if [ "$1" = "-d" ]; then
	download_and_setup $url
	cd $dir
	autoreconf -if
	cd ..
    elif [ "$1" = "-b" ]; then
	cd $dir
	./configure --disable-static --disable-docs --disable-python --prefix=$PREFIX
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
    dir=bufr2netcdf-1.5-1
    url=https://github.com/ARPA-SIMC/bufr2netcdf/archive/v1.5-1.tar.gz

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

do_dballe() {
    dir=dballe-8.0-2
    url=https://github.com/ARPA-SIMC/dballe/archive/v8.0-2.tar.gz

    if [ "$1" = "-d" ]; then
	download_and_setup $url
	cd $dir
	autoreconf -if
	cd ..
    elif [ "$1" = "-b" ]; then
	cd $dir
# --disable-benchmarks
	./configure --disable-static --disable-dballe-python --enable-dballef --disable-docs --prefix=$PREFIX
	make
	make install
	cd ..
    elif [ "$1" = "-c" ]; then
	[ -n "$dir" ] && rm -rf $dir
    elif [ "$1" = "-l" ]; then
	clean_source $url
    fi
}

do_arkimet() {
    dir=arkimet-1.14-1
    url=https://github.com/ARPA-SIMC/arkimet/archive/v1.14-1.tar.gz
#    dir=arkimet-master
#    url=https://github.com/ARPA-SIMC/arkimet/archive/master.tar.gz

    if [ "$1" = "-d" ]; then
	download_and_setup $url
	cd $dir
	# patch for old linux versions
#	sed -e '19i#undef F_OFD_SETLKW\n#undef F_OFD_SETLK' -i arki/dataset/local.cc
#	sed -e '14i#undef F_OFD_SETLKW\n#undef F_OFD_SETLK' -i arki/utils/sys.cc
	autoreconf -if
	cd ..
    elif [ "$1" = "-b" ]; then
	cd $dir
#	./configure --disable-static --enable-bufr --disable-vm2 --disable-geos --disable-python --prefix=$PREFIX
	./configure --disable-static --enable-bufr --disable-vm2 --disable-python --prefix=$PREFIX
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
    dir=fortrangis-2.6
    url=https://github.com/dcesari/fortrangis/archive/v2.6.tar.gz
    if [ "$1" = "-d" ]; then
	download_and_setup $url
    elif [ "$1" = "-b" ]; then
	cd $dir
	autoreconf -if
	./configure --disable-static --disable-gdal --disable-proj --disable-doxydoc --prefix=$PREFIX
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
    dir=libsim-6.3.1-1
    url=https://github.com/ARPA-SIMC/libsim/archive/v6.3.1-1.tar.gz

    if [ "$1" = "-d" ]; then
	download_and_setup $url
	cd $dir
	autoreconf -if
	cd ..
    elif [ "$1" = "-b" ]; then
	cd $dir
	./configure --disable-static --enable-f2003-features --enable-f2003-extended-features --disable-log4c --enable-alchimia --disable-ngmath --disable-ncarg --disable-netcdf --disable-doxydoc --prefix=$PREFIX
	make
	make install
	cd ..
    elif [ "$1" = "-c" ]; then
	[ -n "$dir" ] && rm -rf $dir
    elif [ "$1" = "-l" ]; then
	clean_source $url
    fi
}

do_ma_utils() {
    dir=ma_utils-0.13
    url=ma_utils-0.13.tar.gz

    if [ "$1" = "-d" ]; then
	if [ -f "$url" ]; then
	    download_and_setup $url
	fi
    elif [ "$1" = "-b" ]; then
	if [ -f "$url" ]; then
	    cd $dir
	    ./configure --enable-smnd-build --prefix=$PREFIX
	    make
	    make install
# link in bin/ executables in libexec/ for simplifying universal installation
	    for path in $PREFIX/libexec/ma_utils/*; do
		if [ -f "$path" ]; then
		    file=${path##*/}
		    rm -f $PREFIX/bin/$file
		    ln -s ../libexec/ma_utils/$file $PREFIX/bin
		fi
	    done
	    cd ..
	fi
    elif [ "$1" = "-c" ]; then
	[ -n "$dir" ] && rm -rf $dir
    elif [ "$1" = "-l" ]; then
	clean_source $url
    fi
}
