txtFile = 'NarragansettMap_scaled.txt';
gridFile = 'NGnest_100m_child.nc';


dum = 1- dlmread(txtFile)/255;
dum = flipud(dum);

fig(1);clf;pcolor(dum);shading flat

% mask = nc_varget(gridFile,'mask_rho');
mask = dum;
fig(2);clf;pcolor(mask);shading flat;colorbar

[ny,nx] = size(mask);

% the mask isn't doing the edges right for some reason
mask(end,:) = 0;

find(mask(:,2)==0);Jwest=ans(1)
find(mask(:,end-1)==0);Jeast=ans(1)

mask(Jwest:end,1)   = 0;
mask(Jeast:end,end) = 0;



nc_varput(gridFile,'mask_rho',mask);

