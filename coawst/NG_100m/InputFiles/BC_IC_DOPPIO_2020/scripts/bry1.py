import pycnal
import matplotlib
matplotlib.use('Agg')
import subprocess
import pdb
from multiprocessing import Pool
import os

import pycnal
import pycnal_toolbox

src_varname = ['zeta','temp','salt','u_eastward','v_northward']

#irange=(200,600)
#jrange=(250,720)
irange = None
jrange = None

# Change src_filename to your directory for the file's containing variable data
#part_filename = '../DOPPIO/DOPPIO'



data_dir = '/import/c1/VERTMIX/jgpender/ROMS/DOPPIO/DOPPIO_2020/data_DOPPIO/'

dst_dir='./'

myArg = 'ls ' + data_dir + 'DOPPIO*1_*'
print('myArg = ',myArg)
lst = subprocess.getoutput(myArg )
nfiles = subprocess.getoutput(myArg + "|wc -l")

lst_file = lst.splitlines()
#JGP - do a subset of the list of files, if desired
#lst_file = lst_file[0:102]

print('nfiles.split = ',nfiles.split()[0])
print('lst = \n', lst)
print('nfiles = ',nfiles)




wts_file = "./ini_183/remap_weights_DOPPIO_to_NG_100m_bilinear_*"
src_grd = pycnal.grid.get_ROMS_grid('DOPPIO')
dst_grd = pycnal.grid.get_ROMS_grid('NG_100m')
# Outfile is a parameter to allow you to place these created remap files in a different
# directory than the one that is default which is where the file came from.

for file in lst_file:

    print('current working file is   ' + file)

    lcopy = list(src_varname)


    nameStart = file[-23:]
    nameStart = nameStart[:20]
    print('nameStart ',nameStart)
    outName = nameStart + '_NG_100m_bdry.nc'
    print('outname',outName)

    if os.path.isfile('./' + outName):
        print('file exists')
    else:
        print('no such file')

        dst_var = pycnal_toolbox.remapping_bound(lcopy, file, \
                     wts_file, src_grd, dst_grd, rotate_uv=True, \
                     irange=irange, jrange=jrange, \
                     uvar='u_eastward', vvar='v_northward', rotate_part=True)

