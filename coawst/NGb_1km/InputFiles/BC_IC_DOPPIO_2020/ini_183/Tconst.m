oldFile = 'Flat_2020_183_ic_NGb_1km.nc';
newFile = 'Tconst_2020_183_ic_NGb_1km.nc';

unix(['cp ',oldFile,' ',newFile]);

T = nc_varget(newFile,'temp');

T = 20 + 0*T;
[nz,ny,nx] = size(T);
newT = zeros(1,nz,ny,nx);
newT(1,:,:,:) = T;
nc_varput(newFile,'temp',newT);