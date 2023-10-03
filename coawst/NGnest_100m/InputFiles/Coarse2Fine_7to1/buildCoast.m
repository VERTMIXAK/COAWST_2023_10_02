sourceCoast = '/import/c1/VERTMIX/jgpender/ROMS/BathyData/world_int.cst';
gridFile    = 'NGnest_100m_child.nc';

fileID = fopen(sourceCoast,'r');
coast = fscanf(fileID,'%f');

[dum,~] = size(coast);

lat = zeros(1,dum/2);
lon = lat;

for nn = 1:dum/2
    lon(nn) = coast(2*nn);
    lat(nn) = coast(2*nn-1);
end;

lon_rho = nc_varget(gridFile,'lon_rho');
lat_rho = nc_varget(gridFile,'lat_rho');

latMin = min(lat_rho(:))
lonMin = min(lon_rho(:))
latMax = max(lat_rho(:))
lonMax = max(lon_rho(:))

[ny,nx] = size(lon_rho);

latIn = [];
lonIn = [];

for nn=1:100000%length(lat)
    if lon(nn) > lonMin && lon(nn) < lonMax && lat(nn) > latMin && lat(nn) < latMax
        done(nn);
        latIn = [latIn lat(nn)];
        lonIn = [lonIn lon(nn)];
    end;
end

