sourceFile = 'Source_2020_07_01.nc';
newFile    = 'Source_2020_07_01_FLAT.nc';
unix(['cp ',sourceFile,' ',newFile]);

dum = nc_varget(newFile,'zeta');
[ny,nx] = size(dum);
dum2 = zeros(1,ny,nx);
nc_varput(newFile,'zeta',dum2)

dum = nc_varget(newFile,'vbar_northward');
[ny,nx] = size(dum);
dum2 = zeros(1,ny,nx);
nc_varput(newFile,'vbar_northward',dum2)

dum = nc_varget(newFile,'ubar_eastward');
[ny,nx] = size(dum);
dum2 = zeros(1,ny,nx);
nc_varput(newFile,'ubar_eastward',dum2)

dum = nc_varget(newFile,'u_eastward');
[nz,ny,nx] = size(dum);
dum2 = zeros(1,nz,ny,nx);
nc_varput(newFile,'u_eastward',dum2);

dum = nc_varget(newFile,'v_northward');
[nz,ny,nx] = size(dum);
dum2 = zeros(1,nz,ny,nx);
nc_varput(newFile,'v_northward',dum2);

latRho = nc_varget(sourceFile,'lat_rho');
lonRho = nc_varget(sourceFile,'lon_rho');

% % This is a really shallow area (max depth is about 90m)
% % Pick the deepest spot, 
% 
% lat0 = 1;
% lon0 = 1;

% Actually, the deepest spot is a bad choice because the temperature has a
% an inversion in the water column there. This spot is pretty deep too and
% has a better T/S profile for a deadStill experiment.

lat0 = 1;
lon0 = 17;

lon = lonRho(lat0,lon0)
lat = latRho(lat0,lon0)

%% Use the profile at lat0/lon0

%  temp

myLat = lat0;
myLon = lon0;

temp = nc_varget(newFile,'temp');
[nz,ny,nx] = size(temp);
for kk=1:nz
    temp(kk,:,:) = temp(kk,myLat,myLon);
end;
temp(end,:,:) = temp(end-1,:,:);


aaa=5;

dum2 = zeros(1,nz,ny,nx);
dum2(1,:,:,:) = temp;
nc_varput(newFile,'temp',dum2);

salt = nc_varget(newFile,'salt');
[nz,ny,nx] = size(salt);

for kk=1:nz
    salt(kk,:,:) = salt(kk,myLat,myLon);
end;
salt(end,:,:) = salt(end-1,:,:);

dum2 = zeros(1,nz,ny,nx);
dum2(1,:,:,:) = salt;
nc_varput(newFile,'salt',dum2);


