

gridFile = 'PALAU_800mHB_child.nc';

visc = nc_varget(gridFile,'mask_rho');

[ny,nx] = size(visc)

%% x direction

dumX = [1:30];
2*(1 - 1 ./ ( 1 + exp(-(dumX-1-14)/1.8) ))
fig(1);clf;plot(dumX,ans);hold on
plot(dumX,ans,'*')

dumX = [nx-29:nx];
2*(1 ./ ( 1 + exp(-(dumX-nx+14)/1.8) ) )
fig(2);clf;plot(dumX,ans)


%

dumX = [1:nx];
dum = 2*( 1 - 1 ./ ( 1 + exp(-(dumX-1-14)/1.8) ) ) + 2*(1 ./ ( 1 + exp(-(dumX-nx+14)/1.8) ) ) +1 ;
fig(3);clf;plot(dum)

viscX = visc;
for jj=1:nx
    viscX(jj,:) = dum;
end;

fig(10);clf
pcolor(viscX);shading flat;colorbar


aaa=5;


%% y direction

dumY = [1:30];
2*(1 - 1 ./ ( 1 + exp(-(dumY-1-14)/1.8) ))
fig(1);clf;plot(dumY,ans)

dumY = [ny-29:ny];
2*(1 ./ ( 1 + exp(-(dumY-ny+14)/1.8) ) )
fig(2);clf;plot(dumY,ans)


dumY = [1:ny];
dum = 2*( 1 - 1 ./ ( 1 + exp(-(dumY-1-14)/1.8) ) ) + 2*(1 ./ ( 1 + exp(-(dumY-ny+14)/1.8) ) ) +1 ;
fig(3);clf;plot(dum)

viscY = visc;
for ii=1:nx
    viscY(:,ii) = dum;
end;

fig(11);clf
pcolor(viscY);shading flat;colorbar


%% Combine


for ii=1:nx; for jj=1:ny
     visc(jj,ii) = max(viscX(jj,ii),viscY(jj,ii));   

end;end;

fig(12);clf
pcolor(visc);shading flat;colorbar


myVisc.Name = 'visc_factor';
myVisc.Nctype = 'float';
myVisc.Dimension = {'eta_rho','xi_rho'};
myVisc.Attribute = struct('Name',{'long_name','units','coordinates','field'},'Value',{'horizontal viscosity sponge factor','m/s','eta_rho xi_rho','visc_factor, scalar, series'});
nc_addvar(gridFile,myVisc);
nc_varput(gridFile,'visc_factor',visc);



