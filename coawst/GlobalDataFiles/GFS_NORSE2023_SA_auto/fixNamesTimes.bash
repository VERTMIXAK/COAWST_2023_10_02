#!/bin/bash

source ~/.runROMSintel

# The dates are specified in the dates.txt file

dum=`head dates.txt | cut -d ',' -f1`        
now=`date -d $dum "+%Y%m%d"`
echo "now     " $now
        
nowP1=`date -d "$dum +1 days" "+%Y%m%d"`
echo "nowPlus1" $nowP1

names=("Uwind" "Vwind")
times=("wind_time" "wind_time")

#names=("Pair" "Qair" "Tair" "rain" "lwrad_down" "swrad" "Uwind" "Vwind" "albedo" "cloud")
#times=("pair_time" "qair_time" "tair_time" "rain_time" "lrf_time" "srf_time" "wind_time" "wind_time" "albedo_time" "cloud_time")

#source ~/.runPycnal
#python rescale.py             GFS_albedo_$now.nc_ORIG albedo
#python rescale.py             GFS_cloud_$now.nc_ORIG cloud
#python Kelvin2Celsius.py     GFS_Tair_$now.nc_ORIG
#source ~/.runROMSintel


#for nn in `seq 0 9`
for nn in `seq 0 1`
do
    name=${names[$nn]}
    time=${times[$nn]}

    echo ${names[$nn]} ${times[$nn]}


	for file in `ls GFS_"$name"*.nc_ORIG`
	do
		now=`echo $file | cut -d '.' -f1 | cut -d '_' -f3`	
		echo $now

	    file="GFS_"$name"_"$now".nc_ORIG"
	    ncks -O -v $time,$name,lat,lon     $file $file
	
	    baseTime=`ncdump -h $file |grep "time:units" |rev | cut -d ' ' -f2 | rev | cut -d 'T' -f1`
	    baseDays=`grep $baseTime /import/VERTMIXFS/jgpender/roms-kate_svn/addl_Scripts/dayConverterCommas.txt | cut -d ',' -f2`
	    echo "baseTime $baseTime    baseDays $baseDays"
	
	    ncatted -O -a units,$time,o,c,"days since 1900-01-01 00:00:00" $file
		
	    source ~/.runPycnal
	    python settime.py $file $time $baseDays
	    source ~/.runROMSintel

		if [ $name == 'albedo' ]
		then
			echo "doing albedo now"
			ncatted -O -a units,albedo,o,c,' ' $file
		fi

	    if [ $name == 'cloud' ]
	    then
	        echo "doing cloud now"
	        ncatted -O -a units,cloud,o,c,' ' $file
	    fi	

	done

done


module purge
. /etc/profile.d/modules.sh  
module load matlab/R2013a
matlab -nodisplay -nosplash < shoeHorn.m




#!!!!!!!!!! Double check typical size
sizeTarget="120K"

archiveDir='/import/VERTMIX/NORSE2023_SA/GFS_surface_forcing/'
for file in `ls G*.nc`
do
	size=`\ls -lh $file | cut -c 31-34`
	echo $size
	if [[ "$size" == "$sizeTarget" ]]
	then
		echo "strings are equal"
		mv $file $archiveDir
	else
		echo "file size is wrong"
	fi
done

#\rm out* GFS*ORIG *.tmp *.nc




