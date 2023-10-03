#!/bin/bash

#!!!!! Rain ONLY

source ~/.runROMSintel

# The dates are specified in the dates.txt file

window=23
#hours=( $(seq -w 0 $window))
hours=( $(seq -w 0 6 $window))
hoursRain=( $(seq -w 6 6 50))
echo "hours" $hours
nSnapshots=${#hours[@]}
echo "nSnapshots = $nSnapshots"

urlFile=url.txt

year=`head -1 dates.txt | cut -d '-' -f1`
echo "year = " $year

\rm NAR* out* url*


names=("rain")
times=("rain_time")

longNames=names
longNames[0]="Pressure_surface"
longNames[1]="Specific_humidity_height_above_ground"
longNames[2]="Temperature_height_above_ground"
longNames[3]="Total_precipitation_surface_Mixed_intervals_Accumulation"
longNames[4]="Downward_Long-Wave_Radp_Flux_surface"
longNames[5]="Downward_Short-Wave_Radiation_Flux_surface"
longNames[6]="u-component_of_wind_height_above_ground"
longNames[7]="v-component_of_wind_height_above_ground"
longNames[8]="Albedo_surface"
longNames[9]="Total_cloud_cover_entire_atmosphere_single_layer"

longNames3h="Total_precipitation_surface_3_Hour_Accumulation"
longNames6h="Total_precipitation_surface_6_Hour_Accumulation"

latMin=35
latMax=45
lonMin=-75
lonMax=-69



    name=${names[$nn]}
    time=${times[$nn]}
    longName=${longNames[$nn]}

    echo ${names[$nn]} ${times[$nn]} ${longNames[$nn]}

    while read line
    do

        dum=`echo $line | cut -d ',' -f1`
        now=`date -d $dum "+%Y%m%d"`
		month=`echo $now | cut -c 1-6`
        echo $now $month

        for ((ii=0;ii<$nSnapshots;ii+=1));
        do
            outFile="out_"$now"_${hours[$ii]}.nc"

            part1="https://www.ncei.noaa.gov/thredds/ncss/model-namanl/$month/"
            part2="$now/nam_218_"
            if [ $nn -eq 3 ]
			then
				echo "hoursRain" ${hoursRain[$ii]}
				part3=$now"_"${hours[$ii]}"00_006.grb2?"
				rainDate=`date -d "$now + ${hoursRain[$ii]} hours " "+%Y-%m-%d"`
				rainHour=`date -d "$now + ${hoursRain[$ii]} hours " "+%H"`
echo "rainDate" $rainDate
echo "rainHour" $rainHour

                datePlus=$rainDate"T"$rainHour"%3A00%3A00"
			else
            	part3=$now"_"${hours[$ii]}"00_000.grb2?"
                datePlus=`date -d "$now" "+%Y-%m-%d"`"T"${hours[$ii]}"%3A00%3A00"
			fi

echo "part3   " $part3
echo "datePlus" $datePlus

            part4="var=$longName&north=$latMax&west=$lonMin&east=$lonMax&south=$latMin&disableProjSubset=on&horizStride=1&time_start="
            part5=$datePlus"Z&time_end="
            part6=$datePlus"Z&timeStride=1&vertCoord=&addLatLon=true"

            echo $part1$part2$part3$part4$part5$part6 > $urlFile
            echo $part1$part2$part3$part4$part5$part6 

#            part1="https://rda.ucar.edu/thredds/ncss/grid/files/g/ds084.1/$year/"
#            part2="$now/NAR.0p25."
#            part3=$now"00.f0"
#            part4="${hours[$ii]}.grib2?var=$longName&north=$latMax&west=$lonMin&east=$lonMax&south=$latMin&horizStride=1&time_start="
#            datePlus=`date -d "$now + ${hours[$ii]} hours" "+%Y-%m-%dT%H:%M:%S"`
#            part5=$datePlus"Z&time_end="
#            part6=$datePlus"Z&timeStride=1&vertStride=1&accept=netcdf3&addLatLon=true"
#            echo $part1$part2$part3$part4$part5$part6 > $urlFile

			echo $ii " of " $nSnapshots

#: <<'BLOCK'
            wget -O $outFile -i $urlFile

            if [ $nn -eq 3 ]
            then
				if [ ! -s $outFile ]
				then
					part4="var=$longNames3h&north=$latMax&west=$lonMin&east=$lonMax&south=$latMin&disableProjSubset=on&horizStride=1&time_start="
					echo $part1$part2$part3$part4$part5$part6 > $urlFile
					wget -O $outFile -i $urlFile
					ncrename -O -h -v $longNames3h,$longName               $outFile
				fi

	
                if [ ! -s $outFile ]
                then                
					part4="var=$longNames6h&north=$latMax&west=$lonMin&east=$lonMax&south=$latMin&disableProjSubset=on&horizStride=1&time_start="
   	             	echo $part1$part2$part3$part4$part5$part6 > $urlFile
   	             	wget -O $outFile -i $urlFile
                    ncrename -O -h -v $longNames6h,$longName               $outFile
				fi

			fi


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
#BLOCK
        done
    done < dates.txt

exit

    outName="NAR_"$name"_"$year".nc_ORIG"

    ncrcat out*.nc                            $outName
    ncrename -O -h -d y,lat           	$outName
    ncrename -O -h -d x,lon          	$outName
#    ncrename -O -h -v latitude,lat           $outName
#    ncrename -O -h -v longitude,lon           $outName

#    \rm out*.nc





exit

/bin/bash fixNamesTimes.bash


