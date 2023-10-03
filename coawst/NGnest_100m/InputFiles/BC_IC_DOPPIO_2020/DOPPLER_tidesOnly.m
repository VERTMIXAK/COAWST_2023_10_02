fullFile      = 'DOPPIO_2020_bdry_NGnest_100m_parent.nc';
detidedFile   = 'DOPPIO_2020_bdry_NGnest_100m_parent_detided.nc_hourly';
tidesOnlyFile = 'DOPPIO_2020_bdry_NGnest_100m_parent_tidesOnly.nc_hourly';

unix(['cp ',fullFile,' ',tidesOnlyFile]);

root = 'temp';

dumFull    = nc_varget(fullFile   ,[root,'_west']);
dumDetided = nc_varget(detidedFile,[root,'_west']);
nc_varput(tidesOnlyFile,[root,'_west'],dumFull-dumDetided);

dumFull    = nc_varget(fullFile   ,[root,'_south']);
dumDetided = nc_varget(detidedFile,[root,'_south']);
nc_varput(tidesOnlyFile,[root,'_south'],dumFull-dumDetided);

dumFull    = nc_varget(fullFile   ,[root,'_north']);
dumDetided = nc_varget(detidedFile,[root,'_north']);
nc_varput(tidesOnlyFile,[root,'_north'],dumFull-dumDetided);


root = 'salt';

dumFull    = nc_varget(fullFile   ,[root,'_west']);
dumDetided = nc_varget(detidedFile,[root,'_west']);
nc_varput(tidesOnlyFile,[root,'_west'],dumFull-dumDetided);

dumFull    = nc_varget(fullFile   ,[root,'_south']);
dumDetided = nc_varget(detidedFile,[root,'_south']);
nc_varput(tidesOnlyFile,[root,'_south'],dumFull-dumDetided);

dumFull    = nc_varget(fullFile   ,[root,'_north']);
dumDetided = nc_varget(detidedFile,[root,'_north']);
nc_varput(tidesOnlyFile,[root,'_north'],dumFull-dumDetided);




root = 'u';

dumFull    = nc_varget(fullFile   ,[root,'_west']);
dumDetided = nc_varget(detidedFile,[root,'_west']);
nc_varput(tidesOnlyFile,[root,'_west'],dumFull-dumDetided);

dumFull    = nc_varget(fullFile   ,[root,'_south']);
dumDetided = nc_varget(detidedFile,[root,'_south']);
nc_varput(tidesOnlyFile,[root,'_south'],dumFull-dumDetided);

dumFull    = nc_varget(fullFile   ,[root,'_north']);
dumDetided = nc_varget(detidedFile,[root,'_north']);
nc_varput(tidesOnlyFile,[root,'_north'],dumFull-dumDetided);




root = 'ubar';

dumFull    = nc_varget(fullFile   ,[root,'_west']);
dumDetided = nc_varget(detidedFile,[root,'_west']);
nc_varput(tidesOnlyFile,[root,'_west'],dumFull-dumDetided);

dumFull    = nc_varget(fullFile   ,[root,'_south']);
dumDetided = nc_varget(detidedFile,[root,'_south']);
nc_varput(tidesOnlyFile,[root,'_south'],dumFull-dumDetided);

dumFull    = nc_varget(fullFile   ,[root,'_north']);
dumDetided = nc_varget(detidedFile,[root,'_north']);
nc_varput(tidesOnlyFile,[root,'_north'],dumFull-dumDetided);




root = 'v';

dumFull    = nc_varget(fullFile   ,[root,'_west']);
dumDetided = nc_varget(detidedFile,[root,'_west']);
nc_varput(tidesOnlyFile,[root,'_west'],dumFull-dumDetided);

dumFull    = nc_varget(fullFile   ,[root,'_south']);
dumDetided = nc_varget(detidedFile,[root,'_south']);
nc_varput(tidesOnlyFile,[root,'_south'],dumFull-dumDetided);

dumFull    = nc_varget(fullFile   ,[root,'_north']);
dumDetided = nc_varget(detidedFile,[root,'_north']);
nc_varput(tidesOnlyFile,[root,'_north'],dumFull-dumDetided);




root = 'vbar';

dumFull    = nc_varget(fullFile   ,[root,'_west']);
dumDetided = nc_varget(detidedFile,[root,'_west']);
nc_varput(tidesOnlyFile,[root,'_west'],dumFull-dumDetided);

dumFull    = nc_varget(fullFile   ,[root,'_south']);
dumDetided = nc_varget(detidedFile,[root,'_south']);
nc_varput(tidesOnlyFile,[root,'_south'],dumFull-dumDetided);

dumFull    = nc_varget(fullFile   ,[root,'_north']);
dumDetided = nc_varget(detidedFile,[root,'_north']);
nc_varput(tidesOnlyFile,[root,'_north'],dumFull-dumDetided);




