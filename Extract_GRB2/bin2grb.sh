#! /bin/bash

function bin2grb {

    local NEW_HEADER=$1
    local date=$2
    local TARGET_FILE="SST_"$date".grib2"
    NEW_FILE=$NEW_HEADER$date

    echo $NEW_FILE
    #wgrib2 $INP_FILE | egrep '(:TMP:surface|:LAND:surface)' | wgrib2 -no_header $INP_FILE -i -grib_out $TARGET_FILE

    if [ -f $NEW_FILE".bin" ]; then

    wgrib2 $TARGET_FILE -set_grib_type same -import_bin $NEW_FILE".bin" -no_header -set_bin_prec 11 -set_scaling -1 0 -grib_out $NEW_FILE".grib2"
    #wgrib2 $TARGET_FILE -import_bin $NEW_FILE".bin" -no_header -set_bin_prec same -set_scaling same same -grib_out OUT.grib2

    wgrib2 $NEW_FILE".grib2" -set_grib_type same -set_date $date -no_header -set_bin_prec 11 -set_scaling -1 0 -grib_out OUT.grib2 
    
    mv OUT.grib2 $NEW_FILE".grib2"
    
    else

        echo "Error: No input file"
        exit 4

    fi

}
