#! /bin/bash

function error_msg {
    local return_val=$1

    if [ $return_val = 1 ]; then echo "Error in ExtractGRB.sh ..."; fi
    if [ $return_val = 2 ]; then echo "Error in grb2nc.sh ..."; fi
    if [ $return_val = 3 ]; then echo "Error in ExtractGRB.f90 ..."; fi
    if [ $return_val = 4 ]; then echo "Error in bin2grb.sh ..."; fi
    if [ $return_val = 5 ]; then echo "No such file in /home/wpuho/Models/DATA/ERA5/. Now stop ungrib meteorology data in WPS ..."; fi
    if [ $return_val = 6 ]; then echo "No such file in /home/wpuho/Models/Build_WRFV4/build_wrfinput/Extract_GRB2/sst_out/, Now stop ungrib SST data in WPS ..."; fi
}
