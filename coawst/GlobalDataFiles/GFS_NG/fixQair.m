oldFile = 'GFS_Qair_2020.nc_KgPerKg';
newFile = 'GFS_Qair_2020.nc';

unix(['cp ',oldFile,' ',newFile]);

qair = nc_varget(newFile,'Qair');

nc_varput(newFile,'Qair',1000*qair);