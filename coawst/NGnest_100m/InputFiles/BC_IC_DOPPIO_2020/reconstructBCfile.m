origFile = 'DOPPIO_2020_bdry_NGb_1km.nc_hourly_ORIG';
newFile  = 'DOPPIO_2020_bdry_NGb_1km.nc_hourly';
flatFile = 'Flat_2020_bdry_NGb_1km.nc_hourly';

unix(['cp ',flatFile,' ',newFile]);

root = 'temp';

dum = nc_varget(origFile,[root,'_west']);
nc_varput(newFile,[root,'_west'],dum);

dum = nc_varget(origFile,[root,'_south']);
nc_varput(newFile,[root,'_south'],dum);

dum = nc_varget(origFile,[root,'_north']);
nc_varput(newFile,[root,'_north'],dum);



root = 'salt';

dum = nc_varget(origFile,[root,'_west']);
nc_varput(newFile,[root,'_west'],dum);

dum = nc_varget(origFile,[root,'_south']);
nc_varput(newFile,[root,'_south'],dum);

dum = nc_varget(origFile,[root,'_north']);
nc_varput(newFile,[root,'_north'],dum);



root = 'u';

dum = nc_varget(origFile,[root,'_west']);
nc_varput(newFile,[root,'_west'],dum);

dum = nc_varget(origFile,[root,'_south']);
nc_varput(newFile,[root,'_south'],dum);

dum = nc_varget(origFile,[root,'_north']);
nc_varput(newFile,[root,'_north'],dum);



root = 'ubar';

dum = nc_varget(origFile,[root,'_west']);
nc_varput(newFile,[root,'_west'],dum);

dum = nc_varget(origFile,[root,'_south']);
nc_varput(newFile,[root,'_south'],dum);

dum = nc_varget(origFile,[root,'_north']);
nc_varput(newFile,[root,'_north'],dum);



root = 'v';

dum = nc_varget(origFile,[root,'_west']);
nc_varput(newFile,[root,'_west'],dum);

dum = nc_varget(origFile,[root,'_south']);
nc_varput(newFile,[root,'_south'],dum);

dum = nc_varget(origFile,[root,'_north']);
nc_varput(newFile,[root,'_north'],dum);



root = 'vbar';

dum = nc_varget(origFile,[root,'_west']);
nc_varput(newFile,[root,'_west'],dum);

dum = nc_varget(origFile,[root,'_south']);
nc_varput(newFile,[root,'_south'],dum);

dum = nc_varget(origFile,[root,'_north']);
nc_varput(newFile,[root,'_north'],dum);



