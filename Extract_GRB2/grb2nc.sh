#! /bin/bash

function grb2nc {

    var=$1
    DATE=$2
    #FILE="gfs.0p25."$date".f000.grib2"
    FILE=$var"_"$DATE".grib2"

    if [ -f "$FILE" ]; then

        wgrib2 $FILE -no_header -netcdf $var"_"$DATE".nc"

        return 0

    else

        echo "Error: No input file"
        exit 2

    fi

}
