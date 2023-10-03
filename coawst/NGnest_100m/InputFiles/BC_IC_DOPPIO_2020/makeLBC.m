clear;

%% Assemble BC file from snapshots

grid = '../Gridpak_parent/NGnest_100m_parent.nc';
file = 'DOPPIO_2020_bdry_NGnest_100m_parent.nc';
% unix(['\rm ',file]);
% unix(['ncrcat scheduleForDeletion/DOPP* ',file])

aaa=5;


%% make variable list

varNames={'zeta_north' ...
'zeta_south' ...
'zeta_east' ...
'zeta_west' ...
'temp_north' ...
'temp_south' ...
'temp_east' ...
'temp_west' ...
'salt_north' ...
'salt_south' ...
'salt_east' ...
'salt_west' ...
'u_north' ...
'u_south' ...
'u_east' ...
'u_west' ...
'ubar_north' ...
'ubar_south' ...
'ubar_east' ...
'ubar_west' ...
'v_north' ...
'v_south' ...
'v_east' ...
'v_west' ...
'vbar_north' ...
'vbar_south' ...
'vbar_east' ...
'vbar_west'};


%% Fix edges

% rho

mask = nc_varget(grid,'mask_rho');
[ny,nx] = size(mask)

fig(1);clf;pcolor(mask);shading flat;colorbar

var = 'zeta_south';
dum = nc_varget(file,var);
for ii=1:nx
    if mask(1,ii) == 0
        dum(:,ii) = 0;
    end;
end;
nc_varput(file,var,dum);

var = 'zeta_north';
dum = nc_varget(file,var);
for ii=1:nx
    if mask(end,ii) == 0
        dum(:,ii) = 0;
    end;
end;
nc_varput(file,var,dum);

var = 'zeta_west';
dum = nc_varget(file,var);
for jj=1:ny
    if mask(jj,1) == 0
        dum(:,jj) = 0;
    end;
end;
nc_varput(file,var,dum);





var = 'zeta_east';
dum = nc_varget(file,var);
for jj=1:ny
    if mask(jj,end) == 0
        dum(:,jj) = 0;
    end;
end;
nc_varput(file,var,dum);





aaa=5;







%% May not need this, but whatever

for vv=1:length(varNames)
    nc_attadd(file,'scale_factor',1,varNames{vv});
    nc_attadd(file,'add_offset',0,varNames{vv});
end;





