#!/bin/bash
source ~/.runPycnal

year=2020

python add_rivers.py USGS_NG_rivers_${year}.nc
python make_river_clim.py ../riverData_2020/NG_runoff_${year}.nc USGS_NG_rivers_${year}.nc



#python add_temp.py USGS_NG_rivers_${year}.nc

python set_vshape.py USGS_NG_rivers_${year}.nc
cp USGS_NG_rivers_${year}.nc USGS_NG_rivers_${year}.nc_bak


module purge
. /etc/profile.d/modules.sh
module load matlab/R2013a
matlab -nodisplay -nosplash < add_temp.m
