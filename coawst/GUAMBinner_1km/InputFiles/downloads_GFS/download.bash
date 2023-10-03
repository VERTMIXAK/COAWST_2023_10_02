#!/bin/bash

module load data/NCL/6.4.0-binary-centos6

now=`date -d "-5 days" "+%Y%m%d"`

echo $now

window=12
hours=( $(seq -w 0 3 $window)) 
nSnapshots=${#hours[@]}

echo "nSnapshots = $nSnapshots"

#\rm url.* *.nc *.grib2




# TMVGRD, UGRD, PRES, TCDC, PRATE
# Uwind, Vwind
for ((ii=0;ii<$nSnapshots;ii+=1));
do
	echo $ii  ${hours[$ii]}
	outFile=out_${hours[$ii]}.grib2
    urlFile=url_${hours[$ii]}.txt
	echo $outFile

	part1="https://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_0p25.pl?file=gfs.t00z.pgrb2.0p25.f0"

echo "part1 $part1"

#	part2="${hours[$ii]}&all_lev=on&var_ALBDO=on&var_DLWRF=on&var_DSWRF=on&var_PRATE=on&var_PRES=on&var_SPFH=on&var_TCDC=on&var_TMP=on&var_UGRD=on&var_VGRD=on&subregion=&leftlon=141&rightlon=148&toplat=17&bottomlat=11&dir=%2Fgdas."
	                                                                                    
	part2="${hours[$ii]}&lev_10_m_above_ground=on&var_UGRD=on&var_VGRD=on&subregion=&leftlon=141&rightlon=148&toplat=17&bottomlat=11&dir=%2Fgfs."
	echo "part2 $part2"

	part3="$now00"

	echo $part1$part2$now$part3 > $urlFile
	wget -O $outFile -i $urlFile

done

cat out*.grib2 >> forecast.grib2
ncl_convert2nc forecast.grib2


exit
\rm out*.grib2 url_*


exit


wget 
http://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_0p25_1hr.pl'?'file'='gfs.t00z.pgrb2.0p25.f0
"$hour_padded"'&'lev_10_m_above_ground'='on'&'var_UGRD'='on'&'var_VGRD'='on'&'subregion'=&'leftlon'='"$lon_min"'&'rightlon'='"$lon_max"'&'toplat'='"$lat_max"'&'bottomlat'='"$lat_min"'&'dir'=%'2F

gfs."$now"00 



-O ./tmp/"$hour".grib2 --waitretry=1
