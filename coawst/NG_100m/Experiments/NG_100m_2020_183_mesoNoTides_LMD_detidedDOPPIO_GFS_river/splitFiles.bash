mkdir netcdfOutput_split

for file in `ls netcdfOutput/ng_his*.nc`
do
	echo $file
	rootNew=`echo $file | cut -d '/' -f2 | cut -d '.' -f1`
	echo $rootNew


	for ii in `seq -w 0 23`
	do
		ncks -d ocean_time,$ii --mk_rec_dmn  ocean_time  $file netcdfOutput_split/$rootNew"_"$ii".nc"
	done

done
