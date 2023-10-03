#!/bin/bash

source ~/.runROMSintel

# The dates are specified in the dates.txt file
#date -d "-2 days" +"%Y-%m-%d" > dates.txt
#date -d "-1 days" +"%Y-%m-%d" >> dates.txt
#date              +"%Y-%m-%d" >> dates.txt
echo "date " `cat dates.txt`

#myDate=`cat dates.txt`
#echo "myDate" $myDate

#year=`echo $myDate | cut -c 1-4`
#echo "year " $year




window=23
hours=( $(seq -w 0 3 $window))
nSnapshots=${#hours[@]}
echo "nSnapshots = $nSnapshots"


window=47
hours=( $(seq -w 0 3 $window))

n2Snapshots=${#hours[@]}
#n2Snapshots=`echo " 2 * $nSnapshots " | bc`
echo "n2Snapshots = $n2Snapshots"

urlFile=url.txt
\rm GFS* out* url*

#names=("Pair" "Qair" "Tair" "rain" "lwrad_down" "swrad" "Uwind" "Vwind" "albedo" "cloud")
#times=("pair_time" "qair_time" "tair_time" "rain_time" "lrf_time" "srf_time" "wind_time" "wind_time" "albedo_time" "cloud_time")

names=("Uwind" "Vwind")
times=("wind_time" "wind_time")

longNames=names

longNames[0]="u-component_of_wind_height_above_ground"
longNames[1]="v-component_of_wind_height_above_ground"

#longNames[0]="Pressure_surface"
#longNames[1]="Specific_humidity_height_above_ground"
#longNames[2]="Temperature_height_above_ground"
#longNames[3]="Precipitation_rate_surface"
#longNames[4]="Downward_Long-Wave_Radp_Flux_surface_6_Hour_Average"
#longNames[5]="Downward_Short-Wave_Radiation_Flux_surface_3_Hour_Average"
#longNames[6]="u-component_of_wind_height_above_ground"
#longNames[7]="v-component_of_wind_height_above_ground"
#longNames[8]="Albedo_surface_6_Hour_Average"
#longNames[9]="Total_cloud_cover_entire_atmosphere_3_Hour_Average"

latMin=65
latMax=72.5
lonMin=-20
lonMax=10


#for nn in `seq 0 9`
#do
#    echo "first element" ${names[$nn]} ${times[$nn]} ${longNames[$nn]}
#done




#for nn in `seq 0 9`
for nn in `seq 0 1`
do
    name=${names[$nn]}
    time=${times[$nn]}
    longName=${longNames[$nn]}

    echo ${names[$nn]} ${times[$nn]} ${longNames[$nn]}

    while read line
    do

        dum=`echo $line | cut -d ',' -f1`
        now=`date -d $dum "+%Y%m%d"`
		nowP1=`date -d "$dum +1 days" "+%Y%m%d"`
        echo "now     " $now 
		echo "nowPlus1" $nowP1

		year=`echo $now | cut -c 1-4`
		echo "year " $year

# do "today"
        for ((ii=0;ii<$nSnapshots;ii+=1));
        do
            outFile="out_"$now"_${hours[$ii]}.nc"
			echo "outFile " $outFile

            part1="https://thredds.rda.ucar.edu/thredds/ncss/grid/files/g/ds084.1/$year/"
            part2="$now/gfs.0p25."
            part3=$now"00.f0"
            part4="${hours[$ii]}.grib2?var=$longName&north=$latMax&west=$lonMin&east=$lonMax&south=$latMin&horizStride=1&time_start="
            datePlus=`date -d "$now + ${hours[$ii]} hours" "+%Y-%m-%dT%H:%M:%S"`
            part5=$datePlus"Z&time_end="
            part6=$datePlus"Z&timeStride=1&vertStride=1&accept=netcdf3&addLatLon=true"
            echo $part1$part2$part3$part4$part5$part6 > $urlFile
			while [ ! -f $outFile ]
			do
    	        wget -O $outFile -i $urlFile
			done


            if [ -s $outFile ];then
                timeVar=`ncdump -h $outFile | grep time | head -1 |   tr -d '\t' | cut -d ' ' -f1`
                boundsVar=`ncdump -h $outFile | grep double | grep _ | cut -d '(' -f1 | rev | cut -d ' ' -f1 | rev`
                echo "time_bounds variable " $boundsVar
                echo "length" ${#boundsVar}

                if [ ${#boundsVar} -gt 0 ];then

                    echo "found extra dimension"
                    ncks -O -x -v $boundsVar $outFile $outFile
                fi    

                   ncrename -O -h -d $timeVar,$time               $outFile
                ncrename -O -h -v $timeVar,$time             $outFile
                ncrename -O -h -v $longName,$name            $outFile
#                ncks -O -v $time,$name,latitude,longitude     $outFile $outFile

                ncks    --mk_rec_dmn $time -O               $outFile $outFile
                echo "good download"

            else
                \rm $outFile
            fi
        done

    	outName="GFS_"$name"_"$now".nc_ORIG"

    	ncrcat -O out*.nc                            $outName
    	ncrename -O -h -d latitude,lat           $outName
    	ncrename -O -h -d longitude,lon          $outName
    	ncrename -O -h -v latitude,lat           $outName
    	ncrename -O -h -v longitude,lon           $outName
    	\rm out*.nc

# do "tomorrow

#        for ((ii=0;ii<$nSnapshots;ii+=1));		
        for ((ii=$nSnapshots;ii<$n2Snapshots;ii+=1));
        do
            outFile="out_"$now"_${hours[$ii]}.nc"
            echo "outFile " $outFile

            part1="https://thredds.rda.ucar.edu/thredds/ncss/grid/files/g/ds084.1/$year/"
            part2="$now/gfs.0p25."
            part3=$now"00.f0"
            part4="${hours[$ii]}.grib2?var=$longName&north=$latMax&west=$lonMin&east=$lonMax&south=$latMin&horizStride=1&time_start="
            datePlus=`date -d "$now + ${hours[$ii]} hours" "+%Y-%m-%dT%H:%M:%S"`
            part5=$datePlus"Z&time_end="
            part6=$datePlus"Z&timeStride=1&vertStride=1&accept=netcdf3&addLatLon=true"
            echo $part1$part2$part3$part4$part5$part6 > $urlFile
            while [ ! -f $outFile ]
            do
                wget -O $outFile -i $urlFile
            done


            if [ -s $outFile ];then
                timeVar=`ncdump -h $outFile | grep time | head -1 |   tr -d '\t' | cut -d ' ' -f1`
                boundsVar=`ncdump -h $outFile | grep double | grep _ | cut -d '(' -f1 | rev | cut -d ' ' -f1 | rev`
                echo "time_bounds variable " $boundsVar
                echo "length" ${#boundsVar}

                if [ ${#boundsVar} -gt 0 ];then

                    echo "found extra dimension"
                    ncks -O -x -v $boundsVar $outFile $outFile
                fi

                   ncrename -O -h -d $timeVar,$time               $outFile
                ncrename -O -h -v $timeVar,$time             $outFile
                ncrename -O -h -v $longName,$name            $outFile
#                ncks -O -v $time,$name,latitude,longitude     $outFile $outFile

                ncks    --mk_rec_dmn $time -O               $outFile $outFile
                echo "good download"

            else
                \rm $outFile
            fi
        done

        outName="GFS_"$name"_"$nowP1".nc_ORIG"
		echo "out name for forecast " $outName
        ncrcat -O out*.nc                            $outName
        ncrename -O -h -d latitude,lat           $outName
        ncrename -O -h -d longitude,lon          $outName
        ncrename -O -h -v latitude,lat           $outName
        ncrename -O -h -v longitude,lon           $outName
        \rm out*.nc





    done < dates.txt


done 


#cp *ORIG backup



/bin/bash fixNamesTimes.bash


