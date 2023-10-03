clear; close all
tabwindow;

newFile = 'NGnest_100m_child.nc';

mask = nc_varget(newFile,'mask_rho');
h = nc_varget(newFile,'h');
[~,ny,nx] = size(h);



myI = [50:150];
myJ = [300:400];

fig(4);clf;
pcolor(myI,myJ,h(myJ,myI));shading flat;hold on;colorbar
caxis([0 55])


