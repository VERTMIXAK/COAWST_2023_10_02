gfsFile = 'GFS_NG/GFS_swrad_2020.nc';
namFile = 'NAM_NG/NAM_swrad_2020.nc';
merFile = 'dum.nc';

swG = nc_varget(gfsFile,'swrad');
swN = nc_varget(namFile,'swrad');
swM = nc_varget(merFile,'swrad');

nyG=20;nxG=12;
fig(1);clf
plot(sq(swG(:,nyG,nxG)))
title('GFS');

nyN=90;nxN=60;
fig(2);clf
plot(sq(swN(:,nyN,nxN)))
title('NAM')

nyM=10;nxM=5;
fig(3);clf
plot(sq(swM(:,nyM,nxM)))
title('MERRA')

GFSmean = mean(sq(swG(:,nyG,nxG)))

NAMmean = mean(sq(swN(:,nyN,nxN)))

MERRAmean = mean(sq(swM(:,nyM,nxM)))

