#! /bin/bash

#==================
export DATE_START=date_start
export DATE_END=date_end
export HOUR_INTERVAL=06

#=== ExtractGRB.sh
#export DATA_PATH="/home/wpuho/Models/DATA/GFS/2017082112-2017082124/SST/"
#export INP_INVENTORY=":TMP:surface:"
export DATA_PATH="/home/wpuho/Models/DATA/ERA5/"$DATE_START"-"$DATE_END"/"
export INP_INVENTORY=":WTMP:surface:"
#export DATA_PATH="/home/wpuho/Models/DATA/ERA5/2015100212-2015100500/"
#export INP_INVENTORY=":WTMP:surface:"

#=== grb2nc.sh
export var="SST"

#=== new grib2
export NEW_HEADER="SST+-0_"

#==================
rm sst_out/SST*

source ./datecalc.sh
source ./ExtractGRB.sh
source ./grb2nc.sh
source ./bin2grb.sh

datecalc $DATE_START $DATE_END

while [ $date1 -le $date2 ]
do

    export DATE=`date "+%Y%m%d%H" --date=@$date1`
    export iyear=`echo $DATE | cut -c1-4`
    export imon=`echo $DATE | cut -c5-6`
    export iday=`echo $DATE | cut -c7-8`
    export ihr=`echo $DATE | cut -c9-10`

    echo ' '
    echo "EXTRACT GRIB2 FILES ..."  # Generate SST grib2 files
    ExtractGRB $DATA_PATH $DATE
    if [ $? = 1 ]; then exit 1; fi

    echo ' '
    echo "CONVERT THEM TO NC FILES ..."  # Transfer SST grib2 file to netcdf format
    grb2nc $var $DATE
    if [ $? = 1 ]; then exit 2; fi

    echo ' '
    echo "GENERATE BINARY FILES ..."
    gfortran TCname_ExtractNC.f90 -o ExtractNC `nf-config --fflags --flibs` # Compile
    ./ExtractNC     # Execute and generate binary files
    if [ $? = 1 ]; then exit 3; fi

    echo ' '
    echo "CONVERT BINARY FILES TO GRIB2 ..."
    bin2grb $NEW_HEADER $DATE
    if [ $? = 1 ]; then exit 4; fi

    date1=`expr $date1 +  3600 \* $HOUR_INTERVAL`

#    echo $DATE
done

rm *.bin
mv $NEW_HEADER* "./sst_out"

rm SST*

# =====================
