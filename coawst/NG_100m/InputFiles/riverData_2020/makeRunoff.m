templateFile = 'NG_runoff_2020.nc_template';
newFile      = 'NG_runoff_2020.nc';
gridFile     = '../Gridpak/NG_100m.nc';

pm = nc_varget(gridFile,'pm');
pn = nc_varget(gridFile,'pn');

sourceFile = './Providence_dailyAve.txt';
importdata(sourceFile); time = ans(:,1);

nTimes = length(time);

unix(['\rm ',newFile]);
unix(['ncks -d time,1,',num2str(nTimes),' ',templateFile,' ',newFile]);

nc_varput(newFile,'time',time);

% make sure to start with friver all zeros.
dum = nc_varget(newFile,'friver');
dum = 0*dum;
nc_varput(newFile,'friver',dum);

friver = nc_varget(newFile,'friver');
lon    = nc_varget(newFile,'lon');
lat    = nc_varget(newFile,'lat');

fig(99);clf
pcolor(sq(friver(1,:,:)));shading flat

% NOTE: these source files have the total freshwater flow in 
%       m^3/s
%  I need to divide these numbers by the area of tile where I dump this
%  water.




%% Hunt river

myI = 239;
myJ = 730;
delta=20;
iRange = [myI-delta : myI+delta];
jRange = [myJ-delta : myJ+delta];

fig(12);clf
pcolor(iRange,jRange,sq(friver(1,jRange,iRange)));shading flat;colorbar

sourceFile = './Taunton_dailyAve.txt';
dum = importdata(sourceFile);
flow = dum(:,2);

area = 1/ ( pn(myJ,myI) * pm(myJ,myI) );

flow = flow/area;

% Spread the freshwater around 
npoints=2;
friver(:,myJ  ,myI) = flow/npoints;
friver(:,myJ+1,myI) = flow/npoints;


fig(13);clf
pcolor(iRange,jRange,sq(friver(1,jRange,iRange)));shading flat;colorbar
title('Hunt River')

done('Hunt')


%% Taunton river


myI = 454;
myJ = 800;
delta=10;
iRange = [myI-delta : myI+delta];
jRange = [myJ-delta : myJ+delta];

fig(12);clf
pcolor(iRange,jRange,sq(friver(1,jRange,iRange)));shading flat;colorbar

sourceFile = './Taunton_dailyAve.txt';
dum = importdata(sourceFile);
flow = dum(:,2);

area = 1/ ( pn(myJ,myI) * pm(myJ,myI) );

flow = flow/area;

npoints=5;
friver(:,myJ-2,myI) = flow/npoints;
friver(:,myJ-1,myI) = flow/npoints;
friver(:,myJ+0,myI) = flow/npoints;
friver(:,myJ+1,myI) = flow/npoints;
friver(:,myJ+2,myI) = flow/npoints;


fig(13);clf
pcolor(iRange,jRange,sq(friver(1,jRange,iRange)));shading flat;colorbar
title('Taunton River')

done('Taunton')


%% Pawtuxet river

myI = 266;
myJ = 823;

delta=10;
iRange = [myI-delta : myI+delta];
jRange = [myJ-delta : myJ+delta];

fig(12);clf
pcolor(iRange,jRange,sq(friver(1,jRange,iRange)));shading flat;colorbar

sourceFile = './Pawtuxet_dailyAve.txt';
dum = importdata(sourceFile);
flow = dum(:,2);

area = 1/ ( pn(myJ,myI) * pm(myJ,myI) );

flow = flow/area;

npoints=2;
friver(:,myJ,myI) = flow/npoints;
friver(:,myJ,myI+1) = flow/npoints;


fig(13);clf
pcolor(iRange,jRange,sq(friver(1,jRange,iRange)));shading flat;colorbar
title('Pawtuxet River')

done('Pawtuxet')


%% Providence river

myI = 254;
myJ = 913;

delta=6;
iRange = [myI-delta : myI+delta];
jRange = [myJ-delta : myJ+delta];

fig(12);clf
pcolor(iRange,jRange,sq(friver(1,jRange,iRange)));shading flat;colorbar

sourceFile = './Pawtuxet_dailyAve.txt';
dum = importdata(sourceFile);
flow = dum(:,2);

area = 1/ ( pn(myJ,myI) * pm(myJ,myI) );

flow = flow/area;

% Spread the freshwater around 
npoints=8;
friver(:,myJ,myI-3) = flow/npoints;
friver(:,myJ,myI-2) = flow/npoints;
friver(:,myJ,myI-1) = flow/npoints;
friver(:,myJ,myI  ) = flow/npoints;
friver(:,myJ,myI+1) = flow/npoints;
friver(:,myJ,myI+2) = flow/npoints;
friver(:,myJ,myI+3) = flow/npoints;
friver(:,myJ,myI+4) = flow/npoints;


fig(13);clf
pcolor(iRange,jRange,sq(friver(1,jRange,iRange)));shading flat;colorbar
title('Providence River')

done('Providence')


%% Write to file

nc_varput(newFile,'friver',friver);
fig(1);clf
pcolor(lon-360,lat,sq(friver(1,:,:)));shading flat
