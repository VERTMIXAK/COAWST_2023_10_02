fileOrig = 'NGnest_100m_parent.nc_19Sept';
fileNew  = 'NGnest_100m_parent.nc';

unix(['cp ',fileOrig,' ',fileNew]);


h = nc_varget(fileNew,'h');
mask = nc_varget(fileNew,'mask_rho');

%% set h under land mask equal to hmin

% hmin = 1;
% 
% fig(1);clf;pcolor(h);shading flat;colorbar
% 
% fig(2);clf;pcolor(mask);shading flat;colorbar
% 
% h = h .* mask;
% h(h == 0) = hmin;
% 
% nc_varput(file,'h',h);


%% WET_DRY version

dcrit = .1;


h = h .* mask;
h(h == 0) = dcrit;

fig(4);clf;pcolor(h);shading flat
h(1,1)


nc_varput(fileNew,'h',h);