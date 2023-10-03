#!/bin/bash
source /import/home/jgpender/.runROMSintel

dStart=`ncdump -v ocean_time HIS0.nc | grep ocean_time | tail  -1 | cut -d " " -f4`
echo "DSTART = " $dStart >>log

cd /import/c1/VERTMIX/jgpender/coawst/PALAU_800m/Experiments
pwd

today=`date -d "yesterday" +"%Y_%m_%d" `
echo $today >> log
dirName="PALAU_800m_"$today"_auto"
echo $dirName >>log

/bin/rm -r $dirName
/bin/cp -r PALAU_800m_template $dirName
cd $dirName

# copy IC/BC/Forcing files into experiment directory
cp -r ../../InputFiles/automation/GFS_PALAU_forecast 	.
cp ../../InputFiles/automation/ini/HIS0_PALAU_800m.nc 	HIS0_ic_PALAU_800m.nc
cp ../../InputFiles/automation/bdry_PALAU_800.nc		.

# don't update DSTART in ocean.in file any more, so that the netcdf files have consistent names from one experiment to the next
#/bin/sed -i "s/XYXYX/$dStart/" Apps/ocean_palau_800m.in

# copy over some more files
cp /import/c1/VERTMIX/jgpender/coawst/PALAU_800m/InputFiles/automation/*reduce.nc .

# Start the batch job
/opt/scyld/slurm/bin/sbatch PALAUauto.sbat

# Fiddle with Brian's surface data

module purge
module load matlab/R2013a
/usr/local/pkg/matlab/matlab-R2013a/bin/matlab  -nodisplay -nosplash < rvort.m

myDate=`pwd | rev | cut -d '_' -f2-4 | rev`
/bin/mv surfaceTSUVZ_reduce.nc surfaceTSUVZ_$myDate.nc
/bin/cp surface* /import/VERTMIX/PALAU_2023/PacIOOS_Western_North_Pacific


