# ---------- Basic information ----------
#
#     This script used for building the wrfinput from ERA5 dataset.
# Before running this script, users should run DOWNLOAD_ERA5.sh first 
# to automatically download and move data to corresponding directory.
#
# Conceptual framework :
# (1, Extract the desired field of data
# (2, Run WPS
# (3, Run WRF
#
# Requirements :
# (1, Extract_GRB2/
# (2, util/
# (3, namelist/
#

extr_run=1
wps_run=1
ini_run=1
wrf_run=1

#tc_case=bwp152017
#declare -a tc_arr=("bwp172013" "bwp062013" "bwp042010" "bwp142012" "bwp092012" "bwp202011" "bwp112013" "bwp152010")
#declare -a tc_arr=("bwp142003" "bwp172005" "bwp022006" "bwp072006" "bwp022008" "bwp182008" "bwp032009")
#declare -a tc_arr=("bwp242017" "bwp252016" "bwp062016" "bwp102015" "bwp112013" "bwp152010")
declare -a tc_arr=("bwp152017")

ctrl_sst=-0.
#dsst2=-5.

data_dir=/home/wpuho/Models/DATA/ERA5/
wps_dir=/home/wpuho/Models/WPS-4.2/
wrf_dir=/home/wpuho/Models/WRF-4.2.2/
# ===========================

# ---------- Set up environmet
ulimit -s unlimited
start_time="$(date -u +%s.%N)"

wrk_dir=`pwd`
cd $wrk_dir
source ./util/displaytime.sh
source ./util/error_msg.sh
source ./util/tcinfo.sh

for tc_case in "${tc_arr[@]}"
do

# 

rm bwp*
rm ./Extract_GRB2/bwp*
rm ./Extract_GRB2/sst_out/*
tcinfo $tc_case
real_sst=$real_sst
ndre_sst=$ndre_sst
if [ $? = 1 ]; then 
    exit; 
else
    echo "Initializing the case: "$tc_case" ..."
fi

# Extract date information
yyyy1=`echo $date_start | cut -c1-4`
yyyy2=`echo $date_end | cut -c1-4`
mm1=`echo $date_start | cut -c5-6`
mm2=`echo $date_end | cut -c5-6`
dd1=`echo $date_start | cut -c7-8`
dd2=`echo $date_end | cut -c7-8`
hh1=`echo $date_start | cut -c9-10`
hh2=`echo $date_end | cut -c9-10`

# ----------

count=1
#while [ $dsst -ge $dsst2 ]
#for sst in $ctrl_sst $real_sst $ndre_sst
for sst in $ctrl_sst
do

# ---------- Extract and subtract regional SST
if [ $extr_run -eq 1 ]; then

cd $wrk_dir"/Extract_GRB2"

sed -e "4s/date_start/${date_start}/g; 5s/date_end/${date_end}/g; 53s/TCname/${TC_name}/g" ./main.sh > "./"$TC_name"_main.sh"
sed -e "156s/dsst/${sst}/g" ./ExtractNC.f90 > "./"$TC_name"_ExtractNC.f90"

chmod +x $TC_name"_main.sh"
"./"$TC_name"_main.sh"

fi

val=$?

if [ $val -ne 0 ]; then error_msg $val; exit 0; fi
# ----------

# ----------  WPS
if [ $wps_run -eq 1 ]; then
cd $wrk_dir

# Make namelist.wps
cp namelist/namelist.wps.main ./
sed -e "4,5s/yyyy1/${yyyy1}/g; 4,5s/mm1/${mm1}/g; 4,5s/dd1/${dd1}/g; 4,5s/hh1/${hh1}/g; 4,5s/yyyy2/${yyyy2}/g; 4,5s/mm2/${mm2}/g; 4,5s/dd2/${dd2}/g; 4,5s/hh2/${hh2}/g;" ./namelist.wps.main > $TC_name"_namelist.wps"
mv $TC_name"_namelist.wps" namelist.wps
mv namelist.wps $wps_dir
rm namelist.wps.main

cd $wps_dir

rm met_em.d0*
rm SST\:*

# Run geogrid.exe and ungrib meteorology data (i.e., PL*, SL*) at first time for the NEW TC case
if [ $ini_run -eq 1 ]; then
    rm geo_em.d0*
    rm PL\:*
    rm SL\:*
    ./geogrid.exe

    ln -sf ungrib/Variable_Tables/Vtable.ERA-interim.pl ./Vtable
    sed -i "47s/FILE/PL/g;" ./namelist.wps

    if [ ! -d "$data_dir"$date_start"-"$date_end"/" ]; then error_msg 5; exit 0; fi
    if [ -z "$(ls -A "$data_dir"$date_start"-"$date_end"/")" ]; then error_msg 5; exit 0; fi

    ./link_grib.csh "$data_dir"$date_start"-"$date_end"/pl-*"
    ./ungrib.exe
    sed -i "47s/PL/SL/g;" namelist.wps
    ./link_grib.csh "$data_dir"$date_start"-"$date_end"/sl-*"
    ./ungrib.exe
    sed -i "47s/SL/SST/g;" namelist.wps
    ini_run=9999            # After create the static (geo_em.d0*) and intermediate (PL*, SL*) data at first time, 
                            # set ini_run flag an arbitary number

# Otherwise, only ungrib SST data
else
    sed -i "47s/FILE/SST/g;" namelist.wps
fi

if [ -z "$(ls -A $wrk_dir"/Extract_GRB2/sst_out/")" ]; then error_msg 6; exit 0; fi

# Ungrib SST and metgrid
ln -sf ungrib/Variable_Tables/Vtable.SST.ERA5 ./Vtable
./link_grib.csh $wrk_dir"/Extract_GRB2/sst_out/SST*"
./ungrib.exe
./metgrid.exe

fi
# ----------

# ----------  WRF
if [ $wrf_run -eq 1 ]; then
cd $wrk_dir

# Calculate run_day and run_hour for namelist.input
date1=`date -d "$yyyy1-$mm1-$dd1 $hh1:00:00" +%s`
date2=`date -d "$yyyy2-$mm2-$dd2 $hh2:00:00" +%s`
dates=`expr $date2 - $date1`
displaytime $dates

# Make namelist.input
cp namelist/namelist.input.main ./
sed -e "2s/r_d/${run_d}/g; 3s/r_h/${run_h}/g;  6s/yyyy1/${yyyy1}/g; 7s/mm1/${mm1}/g; 8s/dd1/${dd1}/g; 9s/hh1/${hh1}/g; 12s/yyyy2/${yyyy2}/g; 13s/mm2/${mm2}/g; 14s/dd2/${dd2}/g; 15s/hh2/${hh2}/g;" namelist.input.main > $TC_name"_namelist.input"
mv $TC_name"_namelist.input" namelist.input
mv namelist.input $wrf_dir"/run"
rm namelist.input.main

# Run real.exe
cd $wrf_dir"run/"
rm met_em.d0* wrfinput_d0* wrfbdy_d0* rsl.*
ln -sf $wps_dir/met_em.d0* ./
#mpirun -np 24 ./real.exe
#qsub -sync run_real.sh
./real.exe

# Make directory if not exist and put wrfinput* to corresponding folder
if [ ! -d "results/"$TC_name ]; then    # If bwp folder not exist
    mkdir "results/"$TC_name
    mkdir "results/"$TC_name"/cSST"$sst
    mv wrfinput_d0* "results/"$TC_name"/cSST"$sst
    mv wrfbdy_d0* "results/"$TC_name"/cSST"$sst

else                                    # If bwp folder already exist
    if [ ! -d "results/"$TC_name"/cSST"$sst ]; then    # If bwp/cSST* folder not exist
        mkdir "results/"$TC_name"/cSST"$sst
        mv wrfinput_d0* "results/"$TC_name"/cSST"$sst
        mv wrfbdy_d0* "results/"$TC_name"/cSST"$sst

    else                                                # If exist
        if [ -z "$(ls -A "results/"$TC_name"/cSST"$sst)" ]; then   # If empty
            mv wrfinput_d0* "results/"$TC_name"/cSST"$sst
            mv wrfbdy_d0* "results/"$TC_name"/cSST"$sst
        else
            echo " "
            while read -p 'FILE already exist,  want to recover it? [y/n] ' option
            do
            if [ $option = y ] || [ $option = n ]; then
                if [ $option = y ]; then
                    mv wrfinput_d0* "results/"$TC_name"/cSST"$sst
                    mv wrfbdy_d0* "results/"$TC_name"/cSST"$sst
                    break
                elif [ $option = n ]; then
                    # do nothing
                    break
                fi
            fi
            done
        fi
    fi
fi

if [ $count -eq 1 ]; then
    mv "results/"$TC_name"/cSST"$sst "results/"$TC_name"/SST_CTRL"
elif [ $count -eq 2 ]; then
    mv "results/"$TC_name"/cSST"$sst "results/"$TC_name"/SST_REAL"
elif [ $count -eq 3 ]; then
    mv "results/"$TC_name"/cSST"$sst "results/"$TC_name"/SST_NDRE"
fi

if [ "$option" != "n" ]; then
cp namelist.input "results/"$TC_name
fi

fi  # END WRF
# ----------

#dsst=`expr $dsst + $dsst2`
#dsst=`echo $dsst+$dsst2 |bc`
count=`expr $count + 1`
done	# SST LOOP
ini_run=1

done	# TY CASE LOOP

end_time="$(date -u +%s.%N)"
elapsed="$(bc <<<"$end_time-$start_time")"
echo "Total of $elapsed seconds elapsed for process"
