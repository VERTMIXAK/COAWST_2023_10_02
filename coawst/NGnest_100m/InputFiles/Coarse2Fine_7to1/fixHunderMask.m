fileOrig = 'NGnest_100m_child.nc_ORIG';
fileNew  = 'NGnest_100m_child.nc';
unix(['cp ',fileOrig,' ',fileNew]);

h    = nc_varget(fileNew,'h');
mask = nc_varget(fileNew,'mask_rho');
fig(1);pcolorjw(h);shading flat
fig(2);pcolorjw(mask);shading flat;colorbar

min(h(:))
aaa=5;

Hmin  = 1;
dcrit = .1;

% First set the minimum everywhere to Hmin
h(h<1) = 1;

% Now set h under the land mask equal to dcrit

h(mask<1) = dcrit;

fig(3);pcolorjw(h);shading flat

nc_varput(fileNew,'h',h);