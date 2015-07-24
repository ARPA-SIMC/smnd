#!/bin/sh

# stop at first error
set -e
# redirect all to stderr
exec 1>&2
# default configuration
INPUT_WMO_TEMPLATE=wmo_flat_file_template.txt
SPACE_PROC=average
BUFR_TEMPLATE=synop-wmo
# source the provided configuration ("namelist")
if [ -n "$1" -a "${1#-}" = "$1" ]; then
    if [ "${1#.}" = "$1" -a "${1#/}" = "$1" ]; then
	. ./$1
    else
	. $1
    fi
fi


exit_err() {
    echo $@
    exit 1
}

check_defined() {
    for var in $@; do
	val=`eval echo '$'$var`
	if [ -z "$val" ]; then exit_err "variable \$$var must be defined"
	fi
    done
}

check_defined OPERATION

case "$OPERATION" in
    MAKE-OBS)
	echo '### creating bufr observations from a text file ###'
	check_defined INPUT_OBS_FILE OUTPUT_OBS_FILE BUFR_TEMPLATE

	if [ -n "$START_BLOCK_NUMBER" -a -n "$START_STATION_NUMBER" ]; then

	    dbamsg convert -t csv -d bufr --template=generic \
		$INPUT_OBS_FILE > tmp$$.bufr


# add WMO information and convert to ECMWF/WMO template
	    v7d_add_wmo_info --input-format=BUFR --output-format=BUFR:$BUFR_TEMPLATE \
		--block-number=$START_BLOCK_NUMBER \
		--station-number=$START_STATION_NUMBER \
		tmp$$.bufr $OUTPUT_OBS_FILE

# create WMO flat file (to be done just once)
	    if [ -n "$OUTPUT_WMO_FILE" ]; then
		rm -f $OUTPUT_WMO_FILE
		v7d_add_wmo_info --input-format=BUFR \
		    --output-format=WMOFLAT:$INPUT_WMO_TEMPLATE \
		    --block-number=$START_BLOCK_NUMBER \
		    --station-number=$START_STATION_NUMBER \
		    tmp$$.bufr $OUTPUT_WMO_FILE
	    fi

	    rm -f tmp$$.bufr
	else
	    dbamsg convert -t csv -d bufr --template=$BUFR_TEMPLATE \
		$INPUT_OBS_FILE > $OUTPUT_OBS_FILE

	fi
	;;

    RECUM-SYNOP)
	;;

    POLY-OBS)
	echo '### verification on polygons - processing observations ###'
	check_defined INPUT_OBS_FILE INPUT_POLYGON_FILE OUTPUT_OBS_FILE \
	    SPACE_PROC BUFR_TEMPLATE START_BLOCK_NUMBER START_STATION_NUMBER
	rm -f $OUTPUT_OBS_FILE tmp$$.bufr
# process observational data on catchments converting to bufr message
# with a "generic" template'
	v7d_transform --input-format=BUFR --output-format=BUFR:generic \
	    --pre-trans-type=polyinter:$SPACE_PROC --disable-qc \
	    --coord-format=shp --coord-file=$INPUT_POLYGON_FILE \
	    $INPUT_OBS_FILE tmp$$.bufr

# add WMO information and convert to ECMWF/WMO template
	v7d_add_wmo_info --input-format=BUFR --output-format=BUFR:$BUFR_TEMPLATE \
	    --block-number=$START_BLOCK_NUMBER \
	    --station-number=$START_STATION_NUMBER \
	    tmp$$.bufr $OUTPUT_OBS_FILE

# create WMO flat file (to be done just once)
	if [ -n "$OUTPUT_WMO_FILE" ]; then
	    rm -f $OUTPUT_WMO_FILE
	    v7d_add_wmo_info --input-format=BUFR \
		--output-format=WMOFLAT:$INPUT_WMO_TEMPLATE \
		--block-number=$START_BLOCK_NUMBER \
		--station-number=$START_STATION_NUMBER \
		tmp$$.bufr $OUTPUT_WMO_FILE
	fi

	rm -f tmp$$.bufr
	;;

    POLY-MOD)
	echo '### verification on polygons - processing model data ###'
	check_defined INPUT_MODEL_FILE INPUT_POLYGON_FILE OUTPUT_MODEL_FILE \
	    SPACE_PROC
	rm -f $OUTPUT_MODEL_FILE

# process grib data on polygons; this is at the moment very slow,
# optimization required
	if [ -n "$TIME_PROC_INTERVAL" ]; then
	    vg6d_transform --comp-stat-proc=1:1 \
		--comp-step="$TIME_PROC_INTERVAL" --comp-full-steps \
		--trans-type=polyinter --sub-type=$SPACE_PROC \
		--coord-format=shp --coord-file=$INPUT_POLYGON_FILE \
		$INPUT_MODEL_FILE $OUTPUT_MODEL_FILE
	else
	    vg6d_transform --trans-type=polyinter --sub-type=$SPACE_PROC \
		--coord-format=shp --coord-file=$INPUT_POLYGON_FILE \
		$INPUT_MODEL_FILE $OUTPUT_MODEL_FILE
	fi
	;;

    BOX-OBS)
	echo '### verification on boxes - processing observations ###'
	check_defined INPUT_OBS_FILE INPUT_BOX_TEMPLATE OUTPUT_OBS_FILE \
	    SPACE_PROC BUFR_TEMPLATE START_BLOCK_NUMBER START_STATION_NUMBER
	rm -f $OUTPUT_OBS_FILE tmp$$.grib tmp$$.bufr

# process observational data on boxes converting to grib; a grib file
# is used as template in order to define the boxes
	v7d_transform --input-format=BUFR \
            --variable-list=B10004,B10051,B12101,B12103,B13003,B11001,B11002,B13011 \
	    --output-format=grib_api:$INPUT_BOX_TEMPLATE \
	    --post-trans-type=boxinter:$SPACE_PROC --disable-qc \
	    $INPUT_OBS_FILE tmp$$.grib

# convert back to bufr with a "generic" template
	vg6d_getpoint --trans-type=metamorphosis --sub-type=all \
	    --output-format=BUFR tmp$$.grib tmp$$.bufr

# add WMO information and convert to ECMWF/WMO template
	v7d_add_wmo_info --input-format=BUFR --output-format=BUFR:$BUFR_TEMPLATE \
	    --block-number=$START_BLOCK_NUMBER \
	    --station-number=$START_STATION_NUMBER \
	    tmp$$.bufr $OUTPUT_OBS_FILE

# create WMO flat file (to be done just once)
	if [ -n "$OUTPUT_WMO_FILE" -a -n "$INPUT_WMO_TEMPLATE" ]; then
	    v7d_add_wmo_info --input-format=BUFR \
		--output-format=WMOFLAT:$INPUT_WMO_TEMPLATE \
		--block-number=$START_BLOCK_NUMBER \
		--station-number=$START_STATION_NUMBER \
		tmp$$.bufr $OUTPUT_WMO_FILE
	fi

	rm -f tmp$$.grib tmp$$.bufr
	;;

    BOX-MOD)

	echo '### verification on boxes - processing model data ###'
	check_defined INPUT_MODEL_FILE INPUT_BOX_TEMPLATE OUTPUT_MODEL_FILE \
	    SPACE_PROC
	rm -f $OUTPUT_MODEL_FILE

# process grib data on boxes; a grib file is used as template in order
# to define the boxes
	if [ -n "$TIME_PROC_INTERVAL" ]; then
	    vg6d_transform --comp-stat-proc=1:1 \
		--comp-step="$TIME_PROC_INTERVAL" --comp-full-steps \
		--trans-type=boxinter --sub-type=$SPACE_PROC \
		--output-format=grib_api:$INPUT_BOX_TEMPLATE \
		$INPUT_MODEL_FILE $OUTPUT_MODEL_FILE
	else
	    vg6d_transform --trans-type=boxinter --sub-type=$SPACE_PROC \
		--output-format=grib_api:$INPUT_BOX_TEMPLATE \
		$INPUT_MODEL_FILE $OUTPUT_MODEL_FILE
	fi
	;;
esac
