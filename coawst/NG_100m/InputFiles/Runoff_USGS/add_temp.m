fileID = fopen('../riverData_2020/tempDayN.txt','r');
dayN = fscanf(fileID,'%f');
fclose(fileID);

fileID = fopen('../riverData_2020/tempHour.txt','r');
hour = fscanf(fileID,'%f');
fclose(fileID);

fileID = fopen('../riverData_2020/temp.txt','r');
temp = fscanf(fileID,'%f');
fclose(fileID);

myDayN = dayN + hour/24;
fig(1);clf;plot(myDayN,temp)

riverFile = 'USGS_NG_rivers_2020.nc';


%% Turn temp and salt data into matrices

nRiver = 3194;
nZ     = 50;
nt     = length(temp);
saltMat = zeros(nt,nZ,nRiver);
subMat  = ones(nZ,nRiver);

tempMat = saltMat;
for tt=1:nt
    tempMat(tt,:,:) = temp(tt) * subMat;
end;


%% add the data to the ROMS river source file

unix(['cp ',riverFile,'_bak ',riverFile])

nc_add_dimension(riverFile,'river_tracer_time',length(myDayN));

dum.Name = 'river_tracer_time';
    dum.Nctype = 'float';
    dum.Dimension = {'river_tracer_time'};
    dum.Attribute = struct('Name',{'long_name','units'},'Value',{'river tracer time','day'});
    nc_addvar(riverFile,dum);

dum.Name = 'river_temp';
    dum.Nctype = 'float';
    dum.Dimension = {'river_tracer_time','s_rho', 'river'};
    dum.Attribute = struct('Name',{'long_name','units','time'},'Value',{'river runoff potential temperature','Celsius','river_tracer_time'});
    nc_addvar(riverFile,dum);
    
dum.Name = 'river_salt';
    dum.Nctype = 'float';
    dum.Dimension = {'river_tracer_time', 's_rho', 'river'};
    dum.Attribute = struct('Name',{'long_name','units','time','field'},'Value',{'river runoff salinity',' ','river_tracer_time','river_salt, scalar, series'});
    nc_addvar(riverFile,dum);
    
    

nc_varput(riverFile,'river_tracer_time',myDayN);
nc_varput(riverFile,'river_temp',tempMat); 
nc_varput(riverFile,'river_salt',saltMat); 




