#!/bin/bash

function datecalc {

    local DATE_START=$1
    local DATE_END=$2

    local iyear1=`echo $DATE_START | cut -c1-4`
    local imon1=`echo $DATE_START | cut -c5-6`
    local iday1=`echo $DATE_START | cut -c7-8`
    local ihr1=`echo $DATE_START | cut -c9-10`
    date1=`date -d "$iyear1-$imon1-$iday1 $ihr1:00:00" +%s`
    date1=`expr $date1 +  3600 \* 0`

    local iyear2=`echo $DATE_END | cut -c1-4`
    local imon2=`echo $DATE_END | cut -c5-6`
    local iday2=`echo $DATE_END | cut -c7-8`
    local ihr2=`echo $DATE_END | cut -c9-10`
    date2=`date -d "$iyear2-$imon2-$iday2 $ihr2:00:00" +%s`

}
