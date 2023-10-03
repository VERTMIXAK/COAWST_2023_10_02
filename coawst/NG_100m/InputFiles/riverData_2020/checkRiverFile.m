clear; close all

riverFile  = 'NG_runoff_2020.nc';

lat = nc_varget(riverFile,'lat');
lon = nc_varget(riverFile,'lon');
friver = nc_varget(riverFile,'friver');

[ny,nx] = size(lon)

iRange=[1:nx-1];
jRange=[1:ny-1];
fig(2);clf
pcolor(iRange,jRange,sq(abs(friver(1,jRange,iRange))));shading flat;colorbar
hold on;

fig(12);clf
pcolor(iRange,jRange,sq(abs(friver(1,jRange,iRange))));shading flat;colorbar
xlim([440 460]);ylim([790 810])
hold on;
plot(myI,myJ)


%%
fig(10);clf;

[~,b]=find(sq(abs(flow(1,:)))>0)
plot(myI,myJ)
hold on
plot(myI(b),myJ(b),'.r')

