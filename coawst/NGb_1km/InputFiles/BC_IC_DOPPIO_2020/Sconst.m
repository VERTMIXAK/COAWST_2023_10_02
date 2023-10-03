oldFile = 'Flat_2020_bdry_NGb_1km.nc_hourly';
newFile = 'Sconst_2020_bdry_NGb_1km.nc_hourly';

unix(['cp ',oldFile,' ',newFile]);

S = nc_varget(newFile,'salt_west');
newS = 30 + 0*S;
nc_varput(newFile,'salt_west',newS);

S = nc_varget(newFile,'salt_east');
newS = 30 + 0*S;
nc_varput(newFile,'salt_east',newS);

S = nc_varget(newFile,'salt_north');
newS = 30 + 0*S;
nc_varput(newFile,'salt_north',newS);

S = nc_varget(newFile,'salt_south');
newS = 30 + 0*S;
nc_varput(newFile,'salt_south',newS);