file = 'NG_100m.nc';

unix(['cp ',file,'_ORIG2 ',file]);


h = nc_varget(file,'h');
mask = nc_varget(file,'mask_rho');

%%


fig(1);clf;pcolor(h);shading flat;colorbar

fig(2);clf;pcolor(mask);shading flat;colorbar

h = h .* mask;
h(h == 0) = 1;

nc_varput(file,'h',h);


%% WET_DRY version

wetDryFile = 'NG_100m_wetDry.nc';
unix(['cp ',file,' ',wetDryFile]);

h = h .* mask;
h(h == 0) = .1;

fig(4);clf;pcolor(h);shading flat
h(1,1)


nc_varput(wetDryFile,'h',h);