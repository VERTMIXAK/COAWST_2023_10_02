file = 'NAR_albedo_2020.nc';

lat = nc_varget(file,'lat');
lon = nc_varget(file,'lon');
albedo = nc_varget(file,'albedo');


latMin = round( max(lat(1,:))   * 10) /10
latMax = round( min(lat(end,:)) * 10) /10
lonMin = round( max(lon(:,1))   * 10) /10
lonMax = round( min(lon(:,end)) * 10) /10

fig(1);clf;
pcolor(lon,lat,sq(albedo(1,:,:)));shading flat
caxis([.06 .18])
hold on
plot([lonMin lonMin],[latMin latMax],'g')
plot([lonMax lonMax],[latMin latMax],'g')
plot([lonMin lonMax],[latMin latMin],'g')
plot([lonMin lonMax],[latMax latMax],'g')

mean(diff(lon(1,:)))
mean(diff(lat(:,1)))

[newLon,newLat] = meshgrid(lonMin:.01:lonMax,latMin:.01:latMax);

testOrig = sq(albedo(1,:,:));
testNew = griddata(lon,lat,testOrig,newLon,newLat,'nearest');

fig(2);clf;
pcolor(newLon,newLat,testNew);shading flat;colorbar
caxis([.06 .18])


