#! /bin/bash

function ExtractGRB {
    
    DATA_PATH=$1
    DATE=$2

    #local INP_FILE=$DATA_PATH"gfs.0p25."$DATE".f000.grib2"
    local INP_FILE=$DATA_PATH"sst-"$DATE".grb2"
    local OUT_FILE="SST_"$DATE".grib2"

    if [ -f "$INP_FILE" ]; then
        #wgrib2 $INP_FILE | grep $INP_INVENTORY | wgrib2 -no_header $INP_FILE -i -grib_out $OUT_FILE
        wgrib2 $INP_FILE | egrep '(:WTMP:surface|:LAND:surface)' | wgrib2 -no_header $INP_FILE -i -grib_out $OUT_FILE
        #wgrib2 $INP_FILE | egrep '(:TMP:surface|:LAND:surface)' | wgrib2 -no_header $INP_FILE -i -grib_out $OUT_FILE
        return 0

    else

        echo "Error: No input file"
        return 1
    fi

}
