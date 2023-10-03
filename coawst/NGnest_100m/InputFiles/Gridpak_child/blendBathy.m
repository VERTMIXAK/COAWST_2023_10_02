close all;
tabwindow();

fileC2fine  = '../Coarse2Fine_7to1/NGnest_100m_child.nc_coarse2fine';
fileGridpak = './NGnest_100m_child.nc_bathsuds';
fileNew     = 'NGnest_100m_child.nc';

unix(['cp ',fileGridpak,' ',fileNew]);

hEdge = nc_varget(fileC2fine,'h');
hFine = nc_varget(fileGridpak,'h');

maskEdge = nc_varget(fileC2fine,'mask_rho');
maskFine = nc_varget(fileGridpak,'mask_rho');

fig(1);clf
hEdge-hFine;
pcolor(ans);shading flat;colorbar

myI = [1:10];
myJ = [450:550];
fig(10);clf
pcolor(hEdge(myJ,myI));shading flat;colorbar

fig(11);clf
pcolor(hFine);shading flat;colorbar

fig(12);clf;
maskEdge-maskFine;
pcolor(myI,myJ,ans(myJ,myI));shading flat

fig(13);clf;
pcolor(myI,myJ,maskFine(myJ,myI));shading flat


aaa=5;

%% make a couple masks

% I want to keep most of hFine, but I want to feather the edges out to the
% values on hEdge. Try doing this with a mask
% i.e.
%   maskNew = mask*hEdge + (1-mask)*hFine

mask = 0*hFine;

mask(:,5)     = 1/4;
mask(5,:)     = 1/4;
mask(:,end-4) = 1/4;

mask(:,4)     = 2/4;
mask(4,:)     = 2/4;
mask(:,end-3) = 2/4;

mask(:,3)     = 3/4;
mask(3,:)     = 3/4;
mask(:,end-2) = 3/4;

mask(:,2)     = 1;
mask(2,:)     = 1;
mask(:,end-1) = 1;

mask(:,1)     = 1;
mask(1,:)     = 1;
mask(:,end)   = 1;

hNew = mask.*hEdge + (1-mask).*hFine;

mask(1:6,1:6)
hEdge(1:6,1:6)
hNew(1:6,1:6)
hFine(1:6,1:6)

fig(3);clf;pcolor(hNew - hFine);colorbar;shading flat

fig(4);clf;pcolor(hNew - hFine);colorbar;shading flat;
ans = hNew-hFine;
plot(ans(1,:),'k');hold on;
plot(ans(2,:),'g');
plot(ans(3,:),'b');
plot(ans(4,:),'r');
plot(ans(5,:),'k');

myI = [350:420];
myJ = [550:800];

fig(5);clf;
pcolor(myI,myJ,hNew(myJ,myI));shading flat;hold on;colorbar
caxis([0 40])

myI = [1:10];
myJ = [450:550];
fig(20);clf
hEdge-hNew;
pcolor(myI,myJ,ans(myJ,myI));shading flat;colorbar

fig(21);clf
hFine-hNew;
pcolor(myI,myJ,ans(myJ,myI));shading flat;colorbar

nc_varput(fileNew,'h',hNew);
