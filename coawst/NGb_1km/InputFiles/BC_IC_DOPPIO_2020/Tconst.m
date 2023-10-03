oldFile = 'Flat_2020_bdry_NGb_1km.nc_hourly';
newFile = 'Tconst_2020_bdry_NGb_1km.nc_hourly';

unix(['cp ',oldFile,' ',newFile]);

T = nc_varget(newFile,'temp_west');
newT = 20 + 0*T;
nc_varput(newFile,'temp_west',newT);

T = nc_varget(newFile,'temp_east');
newT = 20 + 0*T;
nc_varput(newFile,'temp_east',newT);

T = nc_varget(newFile,'temp_north');
newT = 20 + 0*T;
nc_varput(newFile,'temp_north',newT);

T = nc_varget(newFile,'temp_south');
newT = 20 + 0*T;
nc_varput(newFile,'temp_south',newT);