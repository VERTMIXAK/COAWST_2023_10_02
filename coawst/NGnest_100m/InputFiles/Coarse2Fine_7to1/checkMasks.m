close all;

tabwindow;

parentFile = '../Gridpak_parent/NGnest_100m_parent.nc';
childFile  = '../Gridpak_child/NGnest_100m_child.nc';

lonP  = nc_varget(parentFile,'lon_rho');
latP  = nc_varget(parentFile,'lat_rho');
maskP = nc_varget(parentFile,'mask_rho');

lonC  = nc_varget(childFile,'lon_rho');
latC  = nc_varget(childFile,'lat_rho');
maskC = nc_varget(childFile,'mask_rho');

fig(1);clf
pcolor(lonP,latP,maskP);shading flat

fig(2);clf
pcolor(lonP,latP,maskP);shading flat
hold on
pcolor(lonC,latC,.5*maskC);shading flat

fig(3);clf
pcolor(lonP,latP,maskP);shading flat
xlim([288.29 288.31]-360);
ylim([41.32 41.34]);
hold on
pcolor(lonC,latC,.5*maskC);shading flat

fig(4);clf
pcolor(lonP,latP,maskP);shading flat
xlim([288.99 289.01]-360);
ylim([41.5 41.515]);
hold on
pcolor(lonC,latC,.5*maskC);shading flat
