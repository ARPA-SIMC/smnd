#!/bin/sh

set -e

if [ "$1" = "clean" ]; then
    rm -f output*/*
    rm -f input/obsprec_for_box_poly.bufr input/boxtemplate.grib
    exit 0
fi


# 4.1 Defining the boxes
grib_copy -w count=1 input/model.grib tmp.grib
vg6d_transform \
  --trans-type=boxinter --sub-type=average --type=regular_ll \
  --nx=21 --ny=31 --x-min=0. --x-max=20. --y-min=30. --y-max=60. \
  tmp.grib input/boxtemplate.grib
rm -f tmp.grib

# 3. Preparing non-GTS observations
smnd_preprocess.sh make_obs.naml
smnd_preprocess.sh make_obs_for_box_poly.naml
# 4. Verification on regular boxes
smnd_preprocess.sh box_obs.naml
smnd_preprocess.sh box_mod.naml
# 5. Verification on arbitrary polygons
smnd_preprocess.sh poly_obs.naml
smnd_preprocess.sh poly_mod.naml
