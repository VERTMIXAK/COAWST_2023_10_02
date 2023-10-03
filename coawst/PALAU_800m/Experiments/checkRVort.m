clear;close all;
tabwindow();

dir = 'PALAU_800m_2023_05_24_nesting_3to1/netcdfOutput/';
dirGrid = '../InputFiles/Grid_3to1_HB/';

gridParent = 'PALAU_800mHB_parent.nc';
gridChild  = 'PALAU_800mHB_child.nc';

fileParent = 'palau_his2_00034.nc';
fileChild  = 'palau_his2_nest_00034.nc';


%% Look at rvort

rvortParent = nc_varget([dir,fileParent],'rvort_sur');
rvortChild  = nc_varget([dir,fileChild ],'rvort_sur');

fig(1);clf;
pcolor(sq(rvortParent(end,1:100,1:100)));shading flat
caxis(1e-5*[-1 1])
title('rvort - parent LL corner')

fig(2);clf;
pcolor(sq(rvortChild(end,1:100,1:100)));shading flat
caxis(1e-5*[-1 1])
title('rvort - child LL corner')

fig(3);clf;
plot(sq(rvortParent(end,1:20,90)))
title('rvort - parent (1:20,90)')

fig(4);clf;
plot(sq(rvortChild(end,1:20,90)))
title('rvort - child (1:20,90)')

%% Comment

% OK. It's pretty clear that both the parent grid and the child grid get
% that edge effect with rvort. This tells me
% 1)    It's not exclusive to "nesting" LBC
% 2)    It's "normal" and why worry about it

% That said, it would be interesting-ish to be more specific about the
% culprit.

% The standard expression for the relative vorticity looks like this:
%
%       RV = du/dy - dv/dx
%
% which discretizes to
%
%       RV = deltaU/deltaEta - deltaV/deltaXi
%
% Written this way it's obvious that deltaU means "change in U as you move
% in the eta direction."
    

% ROMS calculates relative vorticity like this:
%
%       (deltaU*deltaX - deltaV*deltaY)*pm*pn
%
% This expression is actually kind of ambiguous, so it's a good thing we
% looked at the original first. This
%
%       deltaU*deltaX
%
% means "take the product of U and xi_u and find the difference as you move
% in the eta direction." Similarly, 
%
%       deltaV*deltaY
%
% means "take the product of V and eta_v and find the difference as you move
% in the xi direction."
%
% In fact, looking at the ROMS source code you could really write this:
%
%       ( delta(U*xi_u) - delta(V*eta_v) ) * (pm*pn)
%
% which is also weird because pm and pn are on the rho grid.


%% pm*pn

% First check to see if the structure of pm*pn can account for the
% oscillations in 
%
%        rvortChild(end,1:20,90)

pmParent = nc_varget([dirGrid,gridParent],'pm');
pnParent = nc_varget([dirGrid,gridParent],'pn');

pmChild = nc_varget([dirGrid,gridChild],'pm');
pnChild = nc_varget([dirGrid,gridChild],'pn');

pmpnParent = pmParent.*pnParent;
pmpnChild = pmChild.*pnChild;

fig(13);clf;
plot(sq(pmpnParent(1:20,90)))
title('pm*pn - parent (1:20,90)')

fig(14);clf;
plot(sq(pmpnChild(1:20,90)))
title('pm*pn - child (1:20,90)')

% Looks OK

%% delta(U*xi_u)

% The "delta" for this expression means "in the eta direction" so I will
% look at this first. Maybe you only get the oscillations when U and xi_u
% are multiplied together, and maybe the oscillations are entirely due to U
% or xi_u as individual fields.

uParent = nc_varget([dir,fileParent],'u_sur');uParent = sq(uParent(end,:,:));
uChild  = nc_varget([dir,fileChild ],'u_sur');uChild  = sq(uChild(end,:,:));

[ny,nx] = size(uParent)
diffUParent = zeros(ny-1,nx);
for ii=1:nx
    diffUParent(:,ii) = diff(sq(uParent(:,ii)));
end;

fig(21);clf;
pcolor(uParent(1:100,1:100));shading flat;colorbar;title('u - parent')
fig(22);clf;
pcolor(diffUParent(1:100,1:100));shading flat;colorbar;title('diff u in eta direction - parent')

[ny,nx] = size(uChild)
diffUChild = zeros(ny-1,nx);
for ii=1:nx
    diffUChild(:,ii) = diff(sq(uChild(:,ii)));
end;

fig(23);clf;
pcolor(uChild(1:100,1:100));shading flat;colorbar;title('u - child')
fig(24);clf;
pcolor(diffUChild(1:100,1:100));shading flat;colorbar;title('diff u in eta direction - child')



