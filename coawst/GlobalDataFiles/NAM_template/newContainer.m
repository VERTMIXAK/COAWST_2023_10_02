year = 2020;

% Most of the fields have three arguments - lat, lon, and t - but a few
% also include a 4th field - height

names3 = {'Pair', 'lwrad_down', 'swrad', 'cloud', 'albedo','Qair', 'Tair', 'Uwind', 'Vwind'};
times3 = {'pair_time', 'lrf_time', 'srf_time', 'cloud_time', 'albedo_time','qair_time', 'tair_time', 'wind_time', 'wind_time'};


long3  = {'Pressure at 2m','downward longwave radiation at surface','downward shortwave radiation at surface','total cloud cover','albedo at ground',...};
            'Specific Humidity at 2m','Temperature at 2m','u component of wind at 10m','v component of wind at 10m'};

units3 = {'Pa','W m-2','W m-2',' ',' ','kg/kg','C','m/s','m/s'};



%% height-independent fields

% for ii=1:1
for ii=1:9
    timeVar  = char(times3(ii));
    nameVar  = char(names3(ii));
    longName = char(long3(ii));
    units    = char(units3(ii));
    
    newFile = ['NAM_',nameVar,'_',num2str(year),'.nc']
    oldFile = [newFile,'_ORIG'];
    
    lon = nc_varget(oldFile,'lon');
    lon = lon+360;
    lat = nc_varget(oldFile,'lat');
    time = nc_varget(oldFile,timeVar);
    nt = length(time);
    
    var = nc_varget(oldFile,nameVar);
    
    myDims=ndims(var);
    if myDims == 4
        var = sq(var(:,1,:,:));
    end;
    
    latMin = round( max(lat(1,:))   * 10) /10
    latMax = round( min(lat(end,:)) * 10) /10
    lonMin = round( max(lon(:,1))   * 10) /10
    lonMax = round( min(lon(:,end)) * 10) /10
    
    mean(diff(lon(1,:)))
    mean(diff(lat(:,1)))

    [newLon,newLat] = meshgrid(lonMin:.05:lonMax,latMin:.05:latMax);
    [ny,nx] = size(newLon);

    testOrig = sq(var(1,:,:));
    testNew = griddata(lon,lat,testOrig,newLon,newLat,'natural');
    cMin=min(testOrig(:));cMax=max(testOrig(:));
    
    fig(1);clf;
    pcolor(lon,lat,testOrig);shading flat;title(nameVar);caxis([cMin cMax])
    hold on
    plot([lonMin lonMin],[latMin latMax],'k')
    plot([lonMax lonMax],[latMin latMax],'k')
    plot([lonMin lonMax],[latMin latMin],'k')
    plot([lonMin lonMax],[latMax latMax],'k')
    fig(2);clf;
    pcolor(newLon,newLat,testNew);shading flat;title(nameVar);caxis([cMin cMax])
    pause(1)
    
    varNew = zeros(nt,ny,nx);
    for tt=1:nt
        tt
        varNew(tt,:,:) = griddata(lon,lat,sq(var(tt,:,:)),newLon,newLat,'natural');
    end;
    
    % lat is flipped in the original downloads for some reason
%     lat = flipud(lat);
%     for tt=1:nt
%         var(tt,:,:) = flipud(sq(var(tt,:,:)));
%     end;
    
    nc_create_empty(newFile,nc_64bit_offset_mode);
    
    % Dimension section
    nc_add_dimension(newFile,'lon',nx);
    nc_add_dimension(newFile,'lat',ny);
    nc_add_dimension(newFile,timeVar,0);
    
    % Variables section
    
    dum.Name = 'lon';
    dum.Nctype = 'float';
    dum.Dimension = {'lon'};
    dum.Attribute = struct('Name',{'long_name','units','field'},'Value',{'longitude','degrees_east','time, scalar, series'});
    nc_addvar(newFile,dum);
    
    dum.Name = 'lat';
    dum.Nctype = 'float';
    dum.Dimension = {'lat'};
    dum.Attribute = struct('Name',{'long_name','units','field'},'Value',{'latitude','degrees_north','time, scalar, series'});
    nc_addvar(newFile,dum);
    
    dum.Name = timeVar;
    dum.Nctype = 'float';
    dum.Dimension = {timeVar};
    dum.Attribute = struct('Name',{'long_name','units','calendar','field'},'Value',{'time','days since 1900-01-01 00:00:00','gregorian','time, scalar, series'});
    nc_addvar(newFile,dum)
    
    dum.Name = nameVar;
    dum.Nctype = 'float';
    dum.Dimension = {timeVar,'lat','lon'};
    dum.Attribute = struct('Name',{'long_name','units','time','coordinates','field'},'Value',{longName,units,timeVar,['lon lat ',timeVar],'placeholder, scalar, series'});
    nc_addvar(newFile,dum);
    
    
    nc_varput(newFile,'lon',sq(newLon(1,:)));        
    nc_varput(newFile,'lat',sq(newLat(:,1)));
    nc_varput(newFile,nameVar,varNew);
    nc_varput(newFile,timeVar,time);
    
end;


