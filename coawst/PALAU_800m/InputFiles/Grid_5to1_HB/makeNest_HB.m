% This version of makeNest is operationally different. I already have
% parent and child grids plus a contacts file in
%       ../Grid_5to1
%
% The difference here is that Harper wants Hydrographers Bank restored to
% its former glory in the child grid. You can see this feature just fine in
% the source bathymetry file but it gets washed out when you run bathsuds
% and bathsoap. The idea here is to get that submerged ridge built back up
% close to the surface without changing the rest of the grids.
%
% To this this, I will
% 1) Make a duplicate of the Gridpak directory
%       ../Gridpak_HB_5to1
%    and rebuild the grid file after tripling Lm and Mn in
%       ./Include/gridparam.h
%    This will interpolate the source bathymetry onto a grid that closely
%    (but not perrrfectly) overlays my child grid.
% 2) Scarf the portion of the bathymetry from this overdense grid that has
%    Hydrographers Bank onto a copy of my original child grid.
% 3) Use this modified child grid bathymetry to update the bathymetry in a
%    copy of the original parent grid file.
% 4) THEN run the script that creates the contacts file.

% !!!!!!!!! NOTE: the above is only fully accurate for 3:1.  This is 5:1
%
% Specifically, I have a 5:1 Gridpak file (not the full area of the parent
% grid due to memory issues with Gridpak) that has the standard 4 planes in
% the hraw field. Using matlab indexing
%       hraw(2) has unsmoothed bathymetry, thresholded to 20 m
%       hraw(4) has smoothed bathymetry
%
% The idea is to use the smoothed bathymetry almost everywhere, but restore
% Hydrographers Bank as much as possible to it's original resolution.



%%

clear; close all;
unix('rm *.nc *.txt ');
tabwindow();

sourceBathy = '../Gridpak_HB_5to1/PALAU_800m_5to1.nc';
parentFile = 'PALAU_800mHB_parent.nc';
childFile = 'PALAU_800mHB_child.nc';
contactsFile = 'PALAU_800mHB_contacts.nc';

unix(['cp ../Grid_5to1/PALAU_800m_parent.nc ',parentFile]);
unix(['cp ../Grid_5to1/PALAU_800m_child.nc ',childFile]);

myLon = nc_varget(parentFile,'lon_psi');
myLat = nc_varget(parentFile,'lat_psi');


sourceLonRho = nc_varget(sourceBathy,'lon_rho');
sourceLatRho = nc_varget(sourceBathy,'lat_rho');
sourceHraw   = nc_varget(sourceBathy,'hraw');
sourceH = sq(sourceHraw(2,:,:));

childLonRho = nc_varget(childFile,'lon_rho');
childLatRho = nc_varget(childFile,'lat_rho');
childH      = nc_varget(childFile,'h');

parentLonRho = nc_varget(parentFile,'lon_rho');
parentLatRho = nc_varget(parentFile,'lat_rho');
parentH      = nc_varget(parentFile,'h');

mask = nc_varget(parentFile,'mask_psi');

sourceH(sourceH<20)=20;


%% Find overlapping regions of source and child grid.


sourceMinJ = 311;
sourceMaxJ = 391;
sourceMinI = 425;
sourceMaxI = 494;


% Plot the relevant part of the source bathy file

sourceJRange=[sourceMinJ:sourceMaxJ];
sourceIRange=[sourceMinI:sourceMaxI];

fig(81);
pcolor(sourceLonRho(sourceJRange,sourceIRange),sourceLatRho(sourceJRange,sourceIRange),sourceH(sourceJRange,sourceIRange));shading flat
caxis([0 2000])
title('source data')

fig(82);
pcolor(sourceH(sourceJRange,sourceIRange));shading flat
caxis([0 2000])
xLine=[20,20,21,21,22,22,23,23,24,24,25,25,...
    26,26,27,27,28,28,29,29,...
    30,30,31,31,32,32,33,33,34,34,35,35,36,36,37,37,38,38,39,39,...
    40,40,41,41,42,42,43,43,44,44,45,45,46,46,47,47,48,48,49,49,...
    50,50,51,51,52,52,53,53,54,54,55,55,56,56,57,57,58,58,59,59,...
    60,60,61,61,...
    62,62,63,63,64,64,65,65,66,66];
yLine=[30,31,30,31,30,31,30,31,30,31,30,31,...
    30,31,30,31,30,31,30,31,...
    29,30,30,31,31,32,32,33,33,34,34,35,35,36,36,37,37,38,38,39,...
    39,40,40,41,41,42,42,43,43,44,44,45,45,46,46,47,47,48,48,49,...
    49,50,50,51,51,52,52,53,53,54,54,55,55,56,56,57,57,58,58,59,...
    59,60,60,61,...
    61,62,62,63,63,64,64,65,65,66];

% xLine=[20,20,21,21,22,22,23,23,24,24,25,25,...
%     26,26,27,27,28,28,29,29,...
%     30,30,31,31,32,32,33,33,34,34,35,35,36,36,37,37,38,38,39,39,...
%     40,40,41,41,42,42,43,43,44,44,45,45,46,46,47,47,48,48,49,49,...
%     50,50,51,51,52,52,53,53,54,54,55,55,56,56,57,57,58,58,59,59,...
%     60,60,61,61,...
%     62,62,63,63,64,64,65,65,66,66];
% yLine=[19,20,20,21,21,22,22,23,23,24,24,25,...
%     25,26,26,27,27,28,28,29,...
%     29,30,30,31,31,32,32,33,33,34,34,35,35,36,36,37,37,38,38,39,...
%     39,40,40,41,41,42,42,43,43,44,44,45,45,46,46,47,47,48,48,49,...
%     49,50,50,51,51,52,52,53,53,54,54,55,55,56,56,57,57,58,58,59,...
%     59,60,60,61,...
%     61,62,62,63,63,64,64,65,65,66];

title('source data')
line(xLine,yLine);

%% Plot the relevant part of the child bathy file

childMinJ = 254; % 153;
childMaxJ = 334; %200;
childMinI = 333; %200;
childMaxI = 402; %240;


childJRange=[childMinJ:childMaxJ];
childIRange=[childMinI:childMaxI];

fig(91);
pcolor(childLonRho(childJRange,childIRange),childLatRho(childJRange,childIRange),childH(childJRange,childIRange));shading flat
caxis([0 2000])
title('original child grid bathy')

fig(92);
pcolor(childH(childJRange,childIRange));shading flat
caxis([0 2000])
title('original child grid bathy')

% double check lat/lon alignment
childLatRho(childJRange,childIRange) - sourceLatRho(sourceJRange,sourceIRange);abs(ans);max(ans(:))
childLonRho(childJRange,childIRange) - sourceLonRho(sourceJRange,sourceIRange);abs(ans);max(ans(:))

%% Modify the child bathymetry near Hydrographers Bank

childHNew = childH;
nReach = 51;   % make sure this is an odd number

% Make a double sigmoid weighting function

% dumX = [1:15];
% (1 - 1 ./ ( 1 + exp(-(dumX-8)/1) ))
% fig(1);clf;plot(dumX,ans);hold on
% plot(dumX,ans,'*')
% 
% dumX = [51-14:51];
% (1 ./ ( 1 + exp(-(dumX+8-51)/1) ) )
% fig(2);clf;plot(dumX,ans)

dumX = [1:51];
fig(3);clf;
weights = 1 - ( (1 - 1 ./ ( 1 + exp(-(dumX-8)/2) )) + (1 ./ ( 1 + exp(-(dumX+8-51)/2) ) ) );
plot(dumX,weights)



%%

% The strategy here is to extract
%   h on diagonal for source (unsmoothed) bathymetry 
%   h on diagonal for smoothed child grid bathymetry
% The nn index specifies the particular diagonal

% for nn=50:length(xLine)
for nn=5:length(xLine)-4
    
    % Get the rough H profile first
    
    myI = sourceMinI + [xLine(nn)-(nReach+1)/2:xLine(nn)+(nReach+1)/2];
    myJ = sourceMinJ + [yLine(nn)+(nReach+1)/2:-1:yLine(nn)-(nReach+1)/2];  
    
    roughH = zeros(1,nReach);
    for kk=1:nReach
        roughH(kk) = sourceH( myJ(kk+1),  myI(kk+1));
    end;
    
    % Now get the smooth H profile
 
    myI = childMinI + [xLine(nn)-(nReach+1)/2:xLine(nn)+(nReach+1)/2];
    myJ = childMinJ + [yLine(nn)+(nReach+1)/2:-1:yLine(nn)-(nReach+1)/2];  
    
    smoothH = zeros(1,nReach);
    for kk=1:nReach
        smoothH(kk) = childH( myJ(kk+1),  myI(kk+1));
    end;
    
    % Now morph the rough profile into the smooth profile
    
    morphedH = zeros(1,nReach);
    for kk=1:nReach
        morphedH(kk) = smoothH(kk) + weights(kk)*( roughH(kk) - smoothH(kk) );
    end;
    
    fig(99);clf;
    plot(smoothH);hold on;
    ylim([0 1500]);xlim([0 50])
    plot(roughH,'r');
    plot(morphedH,'g');
    nn
    aaa=5;
    
%     pause(1)
    
    % overwrite the child bathy
    
    for kk=1:nReach
        childHNew( myJ(kk),  myI(kk)) = morphedH(kk);
    end;
    
    
end;

childH = childHNew;

[ny,nx] = size(childH);
fig(93);clf
pcolor([1:nx],[1:ny],childH);shading flat
caxis([0 2000])
xlim([childMinI childMaxI]);ylim([childMinJ childMaxJ]);
title('new child grid bathy')




% get rid of those edges

for nn=1:8
    for kk=-25:25
        childH(                                                         ...
                childMinJ + yLine(nn)+kk-1:childMinJ + yLine(nn)+kk+1,  ...
                childMinI + xLine(nn)-kk-1:childMinI + xLine(nn)-kk+1   ...
                );
        childHNew(childMinJ + yLine(nn)+kk,childMinI + xLine(nn)-kk) = mean(ans(:));     
    end;   
end;

for nn=1:8
    for kk=-25:25
        childH(                                                         ...
                childMinJ + yLine(nn)+kk-1:childMinJ + yLine(nn)+kk+1,  ...
                childMinI + xLine(nn)-kk-1:childMinI + xLine(nn)-kk+1   ...
                );
        childHNew(childMinJ + yLine(nn)+kk,childMinI + xLine(nn)-kk) = mean(ans(:));     
    end;   
end;

for nn=length(xLine)-7:length(xLine)
    for kk=-25:25
        childH(                                                         ...
                childMinJ + yLine(nn)+kk-1:childMinJ + yLine(nn)+kk+1,  ...
                childMinI + xLine(nn)-kk-1:childMinI + xLine(nn)-kk+1   ...
                );
        childHNew(childMinJ + yLine(nn)+kk,childMinI + xLine(nn)-kk) = mean(ans(:));     
    end;   
end;

for nn=length(xLine)-7:length(xLine)
    for kk=-25:25
        childH(                                                         ...
                childMinJ + yLine(nn)+kk-1:childMinJ + yLine(nn)+kk+1,  ...
                childMinI + xLine(nn)-kk-1:childMinI + xLine(nn)-kk+1   ...
                );
        childHNew(childMinJ + yLine(nn)+kk,childMinI + xLine(nn)-kk) = mean(ans(:));     
    end;   
end;

for nn=1:length(xLine)
    for kk=-25:25
        childH(                                                         ...
                childMinJ + yLine(nn)+kk-1:childMinJ + yLine(nn)+kk+1,  ...
                childMinI + xLine(nn)-kk-1:childMinI + xLine(nn)-kk+1   ...
                );
        childHNew(childMinJ + yLine(nn)+kk,childMinI + xLine(nn)-kk) = mean(ans(:));     
    end;   
end;

for nn=1:length(xLine)
    for kk=-25:25
        childH(                                                         ...
                childMinJ + yLine(nn)+kk-1:childMinJ + yLine(nn)+kk+1,  ...
                childMinI + xLine(nn)-kk-1:childMinI + xLine(nn)-kk+1   ...
                );
        childHNew(childMinJ + yLine(nn)+kk,childMinI + xLine(nn)-kk) = mean(ans(:));     
    end;   
end;

childH = childHNew;

[ny,nx] = size(childH);
fig(94);clf
% pcolor(childH(childJRange,childIRange));shading flat
pcolor([1:nx],[1:ny],childH);shading flat
caxis([0 2000])
xlim([childMinI childMaxI]);ylim([childMinJ childMaxJ]);
title('new child grid bathy')


nc_varput(childFile,'h',childH);


aaa=5;

%%
fig(100);clf;plot(sq(childHNew(178,220:240)))
hold on;
plot(sq(childHNew(179,220:240)))
plot(sq(childHNew(180,220:240)))
plot(sq(childHNew(181,220:240)))
plot(sq(childHNew(182,220:240)))
plot(sq(childHNew(183,220:240)))
plot(sq(childHNew(184,220:240)))
plot(sq(childHNew(185,220:240)))
plot(sq(childHNew(186,220:240)))
plot(sq(childHNew(187,220:240)))

%%

fig(101);clf;plot(sq(childHNew(181,220:240)))



%% Define the core area of my grid
% I still need this for overwriting the bathymetry in the parent grid.

latLL = 6.5;
lonLL = 133.66;
dumY = myLat - latLL;
dumX = myLon - lonLL;
myDist = sqrt( dumY.^2 + dumX.^2);
[jCoreLL,iCoreLL] = find( min(myDist(:)) == myDist)
[myLat(jCoreLL,iCoreLL) - latLL,myLon(jCoreLL,iCoreLL) - lonLL]


latUR = 7.5;
lonUR = 134.75;
dumY = myLat - latUR;
dumX = myLon - lonUR;
myDist = sqrt( dumY.^2 + dumX.^2);
[jCoreUR,iCoreUR] = find( min(myDist(:)) == myDist)

jCoreUR = jCoreUR - 2;   % This is to avoid a bobble near the northern boundary.

[myLat(jCoreUR,iCoreUR) - latUR,myLon(jCoreUR,iCoreUR) - lonUR]*111

fig(1);clf;pcolor(myLon(jCoreLL:jCoreUR,iCoreLL:iCoreUR),myLat(jCoreLL:jCoreUR,iCoreLL:iCoreUR),mask(jCoreLL:jCoreUR,iCoreLL:iCoreUR));shading flat



% fig(20);clf;
% pcolor(childLonRho(1:3:end,1:3:end) - parentLonRho(jCoreLL:jCoreUR,iCoreLL:iCoreUR));shading flat;colorbar
% fig(21);clf;
% pcolor(childLatRho(1:3:end,1:3:end) - parentLatRho(jCoreLL:jCoreUR,iCoreLL:iCoreUR));shading flat;colorbar
% fig(22);clf;
% pcolor(childH(1:3:end,1:3:end) - parentH(jCoreLL:jCoreUR,iCoreLL:iCoreUR));shading flat;colorbar
% fig(23);clf;
% pcolor(childHNew(1:3:end,1:3:end) - parentH(jCoreLL:jCoreUR,iCoreLL:iCoreUR));shading flat;colorbar




% Looks OK, I guess

% Optional: update the parent grid
% parentH(jCoreLL:jCoreUR,iCoreLL:iCoreUR) - childHNew(1:3:end,1:3:end);
% nc_varput(parentFile,'h',parentH);


aaa=5;


%% Make the subgrid

% coarse2fine(parentFile,childFile,3,iCoreLL,iCoreUR,jCoreLL,jCoreUR)
%
% hParent = nc_varget(parentFile,'h');
% hChild  = nc_varget(childFile,'h');
%
% myThreshold = min(hParent(:));
% hChild(hChild < myThreshold) = myThreshold;
%
% min(hChild(:))
% nc_varput(childFile,'h',hChild);
%
%
% aaa=5;




aaa=5;


%% Make the contacts file

Gnames = {parentFile, childFile}

[S,G] = contact(Gnames,contactsFile)


%% Replot bathymetry

hParent   = nc_varget(parentFile,'h');
lonParent = nc_varget(parentFile,'lon_rho');
latParent = nc_varget(parentFile,'lat_rho');

hChild   = nc_varget(childFile,'h');
lonChild = nc_varget(childFile,'lon_rho');
latChild = nc_varget(childFile,'lat_rho');


maxH =  max(hChild(:));
maxH = 3000;

% fig(10);clf;
% pcolor(lonChild,latChild,hChild);shading flat;colorbar;
% caxis([0 maxH]);



fig(11); clf
deltaLon = .25;
deltaLat = .25;
pcolor(lonParent,latParent,hParent);shading flat;
ylim([latLL-deltaLat latUR+deltaLat]);
xlim([lonLL-deltaLon lonUR+deltaLon]);
caxis([0 maxH]);
hold on;
pcolor(lonChild,latChild,hChild);shading flat;
line([lonLL lonUR],[latLL latLL]);
line([lonLL lonUR],[latUR latUR]);
line([lonLL lonLL],[latLL latUR]);
line([lonUR lonUR],[latLL latUR]);
title('parent plus child')



% fig(12);clf;
% pcolor(lonParent,latParent,hParent);shading flat;
% ylim([latLL-deltaLat latUR+deltaLat]);
% xlim([lonLL-deltaLon lonUR+deltaLon]);
% caxis([0 maxH]);;
% title('parent only')







