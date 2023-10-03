sourceFile = 'Source_2020_07_01.nc';
newFile    = 'Source_2020_07_01_FLAT.nc';
gridFile   = '/import/c1/VERTMIX/jgpender/ROMS/DOPPIO/DOPPIO_2020/grid_DOPPIO.nc';



grd = roms_get_grid(gridFile,gridFile,0,1);

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

lat0 = 71;
lon0 = 127;

lon = lonRho(lat0,lon0)
lat = latRho(lat0,lon0)

temp = nc_varget(newFile,'temp');
salt = nc_varget(newFile,'salt');
mask = nc_varget(newFile,'mask_rho');
[nz,ny,nx] = size(temp);

temp0 = temp(:,lat0,lon0);
salt0 = salt(:,lat0,lon0);
z0    = grd.z_r(:,lat0,lon0);

z1 = zeros(length(z0)+3,1);
z1(1)       = -5000;
z1(2)       = -1000;
z1(3:end-1) = z0;
z1(end)     = 0;

temp1 = 0*z1;
temp1(1)       = temp0(1);
temp1(2)       = temp0(1);
temp1(3:end-1) = temp0;
temp1(end)     = temp1(end-1);

salt1 = 0*z1;
salt1(1)       = salt0(1);
salt1(2)       = salt0(1);
salt1(3:end-1) = salt0;
salt1(end)     = salt1(end-1);

fig(1);clf;
plot(z0,temp0);
fig(2);clf;
plot(z0,salt0);

fig(3);clf;
plot(z1,temp1);
fig(4);clf;
plot(z1,salt1);



%% Use the profile at lat0/lon0

%  temp

for ii=1:nx; for jj=1:ny

    if mask(jj,ii) == 1
        temp(:,jj,ii) = interp1(z1,temp1,grd.z_r(:,jj,ii));
        salt(:,jj,ii) = interp1(z1,salt1,grd.z_r(:,jj,ii));
    end;
end;end;


aaa=5;

dum2 = zeros(1,nz,ny,nx);
dum2(1,:,:,:) = temp;
nc_varput(newFile,'temp',dum2);

dum2 = zeros(1,nz,ny,nx);
dum2(1,:,:,:) = salt;
nc_varput(newFile,'salt',dum2);


