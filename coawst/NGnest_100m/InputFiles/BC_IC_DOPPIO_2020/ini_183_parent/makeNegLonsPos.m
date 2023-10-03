% fileNeg = 'DOPPIO_2020_183_ic_NGnest_100m_parent.nc_negLons'
% filePos = 'DOPPIO_2020_183_ic_NGnest_100m_parent.nc'

fileNeg = 'Flat_2020_183_ic_NGnest_100m_parent.nc_negLons'
filePos = 'Flat_2020_183_ic_NGnest_100m_parent.nc'

unix(['cp ',fileNeg,' ',filePos]);

dum = nc_varget(filePos,'lon_rho');
dum = dum+360;
nc_varput(filePos,'lon_rho',dum);

dum = nc_varget(filePos,'lon_psi');
dum = dum+360;
nc_varput(filePos,'lon_psi',dum);

dum = nc_varget(filePos,'lon_u');
dum = dum+360;
nc_varput(filePos,'lon_u',dum);

dum = nc_varget(filePos,'lon_v');
dum = dum+360;
nc_varput(filePos,'lon_v',dum);



