gridOrig  = 'NGnest_100m_parent.nc_19Sept';
gridToUse = 'NGnest_100m_parent.nc';

unix(['cp ',gridOrig,' ',gridToUse]);

mask = nc_varget(gridToUse,'mask_rho');
pcolor(mask(:,1:5));shading flat

mask = nc_varget(gridToUse,'mask_psi');
pcolor(mask(:,1:5));shading flat

mask = nc_varget(gridToUse,'mask_u');
pcolor(mask(:,1:5));shading flat

mask = nc_varget(gridToUse,'mask_v');
pcolor(mask(:,1:5));shading flat

