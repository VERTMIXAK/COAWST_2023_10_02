fileOld = 'NGnest_100m_child.nc_ORIG'
fileNew = 'NGnest_100m_child.nc'

unix(['cp ',fileOld,' ',fileNew]);

hOrig = nc_varget(fileOld,'h');
maskOrig = nc_varget(fileOld,'mask_rho');
[myJ,myI] = size(hOrig);

fig(98);clf;pcolor(hOrig);shading flat;colorbar
fig(99);clf;pcolor(maskOrig);shading flat;colorbar

aaa=6;

mask =  0*maskOrig;


fig(1);clf;
pcolor(mask);shading flat;colorbar

mask(hOrig>1.7) = 1;

% 
% for ii=1:myI; for jj=1:myJ
%         if hOrig(jj,ii) > 1.001
%             mask(jj,ii) = 1;
%         end;
%     end;end;


fig(1);clf;
pcolor(mask);shading flat;colorbar

nc_varput(fileNew,'mask_rho',mask);
