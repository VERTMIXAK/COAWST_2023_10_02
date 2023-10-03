oldFile = 'Flat_2020_183_ic_NGb_1km.nc';
newFile = 'Sconst_2020_183_ic_NGb_1km.nc';

unix(['cp ',oldFile,' ',newFile]);

S = nc_varget(newFile,'salt');

S = 30 + 0*S;
[nz,ny,nx] = size(S);
newS = zeros(1,nz,ny,nx);
newS(1,:,:,:) = S;
nc_varput(newFile,'salt',newS);