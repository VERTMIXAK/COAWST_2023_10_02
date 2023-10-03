close all;

Fparent = 'netcdfOutput/ng_his_00004.nc';
Fchild  = 'netcdfOutput/ng_his_nest_00004.nc';

vParent = nc_varget(Fparent,'v');
vChild  = nc_varget(Fchild ,'v');

latP = nc_varget(Fparent,'lat_v');
lonP = nc_varget(Fparent,'lon_v');

latC = nc_varget(Fchild,'lat_v');
lonC = nc_varget(Fchild,'lon_v');

done('load')

%%

fig(1);clf;
pcolor(lonP,latP,sq(vParent(1,1,:,:)) ); shading flat
% hold on;
% pcolor(lonC,latC,sq(vChild(1,1,:,:)) ); shading flat