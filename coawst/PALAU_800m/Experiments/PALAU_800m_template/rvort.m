dir  = './';
file = 'surfaceTSUVZ_reduce.nc';

u    = nc_varget([dir,file],'u_sur');
v    = nc_varget([dir,file],'v_sur');
pm   = nc_varget([dir,file],'pm');
pn   = nc_varget([dir,file],'pn');
mask = nc_varget([dir,file],'mask_psi');

% Here's a problem. The rvorticity script assumes the velocity data looks
% like this:
%
%       u(x,y,t)
%
% when ROMS always does
%       u(t,y,x)
%
% So create a new version of the velocity arrays, which is bullshit

[nt,ny,nx] = size(u)
uFlipped = zeros(nx,ny,nt);
for ii=1:nx; for jj=1:ny; for tt=1:nt
    uFlipped(ii,jj,tt) = u(tt,jj,ii);       
end;end;end

[nt,ny,nx] = size(v)
vFlipped = zeros(nx,ny,nt);
for ii=1:nx; for jj=1:ny; for tt=1:nt
    vFlipped(ii,jj,tt) = v(tt,jj,ii);       
end;end;end












rvorFlipped=rvorticity(uFlipped, vFlipped, transpose(pm), transpose(pn),transpose(mask));

% unflip the vorticity

[nx,ny,nt] = size(rvorFlipped)
rvor = zeros(nt,ny,nx);
for ii=1:nx; for jj=1:ny; for tt=1:nt
    rvor(tt,jj,ii) = rvorFlipped(ii,jj,tt);       
end;end;end


fig(1);clf;
pcolor(sq(rvor(end,:,:)).*mask);shading flat;colorbar

rvor(abs(rvor)>100) = 0;

fig(2);clf;
pcolor(sq(rvor(end,:,:)).*mask);shading flat;colorbar

aaa=5;


% Add the vorticity to the netcdf file
 
dum.Name = 'rvort_sur';
dum.Nctype = 'double';
dum.Dimension = {'ocean_time','eta_psi','xi_psi'};
dum.Attribute = struct('Name',{'long_name','units','field'},'Value',{'surface relative vorticity','s^-1','relative vorticity'});
nc_addvar([dir,file],dum);


nc_varput([dir,file],'rvort_sur',rvor)
