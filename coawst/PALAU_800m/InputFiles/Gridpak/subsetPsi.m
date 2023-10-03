file = 'PALAU_800m.nc';

x = nc_varget(file,'x_psi');
y = nc_varget(file,'y_psi');
mask = nc_varget(file,'mask_psi');

size(mask)

fig(1);clf;
pcolor(x);shading flat

iMin = 300;
iMax = 475

jMin = 140;
jMax = 300;

[x(jMax,iMin),y(jMax,iMin)]

[x(jMin,iMin),y(jMin,iMin)]

[x(jMin,iMax),y(jMin,iMax)]

[x(jMax,iMax),y(jMax,iMax)]

5*(iMax-iMin) + 1
5*(jMax-jMin) + 1
   