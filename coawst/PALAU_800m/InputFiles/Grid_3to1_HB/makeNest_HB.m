% This version of makeNest is operationally different. I already have
% parent and child grids plus a contacts file in
%       ../Grid_3to1
%
% The difference here is that Harper wants Hydrographers Bank restored to
% its former glory in the child grid. You can see this feature just fine in
% the source bathymetry file but it gets washed out when you run bathsuds
% and bathsoap. The idea here is to get that submerged ridge built back up
% close to the surface without changing the rest of the grids.
%
% To this this, I will
% 1) Make a duplicate of the Gridpak directory
%       ../GridpakHyBk
%    and rebuild the grid file after tripling Lm and Mn in
%       ./Include/gridparam.h
%    This will interpolate the source bathymetry onto a grid that closely
%    (but not perrrfectly) overlays my child grid.
% 2) Scarf the portion of the bathymetry from this overdense grid that has
%    Hydrographers Bank onto a copy of my original child grid.
% 3) Use this modified child grid bathymetry to update the bathymetry in a
%    copy of the original parent grid file.
% 4) THEN run the script that creates the contacts file.




%%

clear; close all;
unix('rm *.nc *.txt ');
tabwindow();

sourceBathy = '../Gridpak_HB/PALAU_800mHB.nc';
parentFile = 'PALAU_800mHB_parent.nc';
childFile = 'PALAU_800mHB_child.nc';
contactsFile = 'PALAU_800mHB_contacts.nc';

unix(['cp ../Grid_3to1/PALAU_800m_parent.nc ',parentFile]);
unix(['cp ../Grid_3to1/PALAU_800m_child.nc ',childFile]);

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


sourceMinJ = 600;
sourceMaxJ = 647;
sourceMinI = 1151;
sourceMaxI = 1191;


% Plot the relevant part of the source bathy file

sourceJRange=[sourceMinJ:sourceMaxJ];
sourceIRange=[sourceMinI:sourceMaxI];

fig(81);
pcolor(sourceLonRho(sourceJRange,sourceIRange),sourceLatRho(sourceJRange,sourceIRange),sourceH(sourceJRange,sourceIRange));shading flat
caxis([0 1000])
title('source data')

fig(82);
pcolor(sourceH(sourceJRange,sourceIRange));shading flat
caxis([0 1000])
xLine=[13,13,14,14,15,16,16,16,16,17,18,19,20,21,22,23,23,24,25,25,25,26,26,26,27,27,28,28,29,29,30,30,31,31,31,31,32,32,33,34,34,35,35,35,36,36,37];
yLine=[16,17,17,18,18,18,19,20,21,21,21,21,21,21,21,21,22,22,22,23,24,24,25,26,26,27,27,28,28,29,29,30,30,31,32,33,33,34,34,34,35,35,36,37,37,38,38];
% xLine=[13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37];
% yLine=[16,17,18,19,21,21,21,21,21,21,21,22,23,25,26,28,29,30,32,33,34,35,37,38,38];
title('source data')
line(xLine,yLine);

% for nn=1:length(xLine)
%     
%     sourceH(sourceMinJ+yLine(nn),sourceMinI+xLine(nn))
%     
%     myI = sourceMinI + [xLine(nn)-10:xLine(nn)+10];
%     myJ = sourceMinJ + [yLine(nn)+10:-1:yLine(nn)-10];
%     
%     sourceH(myJ,myI);
%     
%     myH = 0*myJ;
%     for kk=1:length(myI)
%         [myJ(kk),myI(kk)];
%         myH(kk) = sourceH( myJ(kk),  myI(kk));
%     end;
%     fig(20);clf;
%     plot(myH);ylim([0 1000])
%     pause(1)
% end;

%% Plot the relevant part of the child bathy file

childMinJ = 153;
childMaxJ = 200;
childMinI = 200;
childMaxI = 240;


childJRange=[childMinJ:childMaxJ];
childIRange=[childMinI:childMaxI];

fig(91);
pcolor(childLonRho(childJRange,childIRange),childLatRho(childJRange,childIRange),childH(childJRange,childIRange));shading flat
caxis([0 1000])
title('original child grid bathy')

fig(92);
pcolor(childH(childJRange,childIRange));shading flat
caxis([0 1000])
title('original child grid bathy')


% double check
childLatRho(childJRange,childIRange) - sourceLatRho(sourceJRange,sourceIRange);abs(ans);max(ans(:))
childLonRho(childJRange,childIRange) - sourceLonRho(sourceJRange,sourceIRange);abs(ans);max(ans(:))

childHNew = childH;
nReach = 29;   % make sure this is an odd number
for nn=1:length(xLine)
    
    sourceH(childMinJ+yLine(nn),childMinI+xLine(nn))   
    myI = childMinI + [xLine(nn)-(nReach+1)/2:xLine(nn)+(nReach+1)/2];
    myJ = childMinJ + [yLine(nn)+(nReach+1)/2:-1:yLine(nn)-(nReach+1)/2];  
    
    myH = zeros(1,nReach);
    for kk=1:nReach+1
        [myJ(kk),myI(kk)];
        myH(kk) = childH( myJ(kk),  myI(kk));
    end;
    
    hTarget = sourceH(sourceMinJ+yLine(nn),sourceMinI+xLine(nn));
    oldChildMin = min(myH);
    myHMinLoc = find(myH==min(myH));
    
    delta = oldChildMin - hTarget;
    
    weights=[.05, .1, .25, .4, .55, .7, .8, .9, .95, 1, .95, .9, .8, .7, .55, .4, .25, .1, .05];
    myHNew = myH;
    for ii=-9:9
        weight = 1-abs(ii)/10;
        weight = weights(ii+10);
        myHNew(myHMinLoc+ii) = myH(myHMinLoc+ii) - weight*delta;
    end;
    
    
    fig(20);clf;
    plot(myH);ylim([0 2000]);hold on
    [hTarget,myH((nReach+1)/2+1),min(myH)]
    plot(find(myH==min(myH)),ans(1),'*')
    plot(myHNew,'r');
%     pause(1)
    
    % overwrite the child bathy
    
    for kk=1:nReach+1
        [myJ(kk),myI(kk)];
        childHNew( myJ(kk),  myI(kk)) = myHNew(kk);
    end;
    
    
end;


fig(93);
pcolor(childHNew(childJRange,childIRange));shading flat
caxis([0 1000])
title('new child grid bathy')


childH = childHNew;

for nn=1:length(xLine)
    for kk=-10:10
        childH(                                                         ...
                childMinJ + yLine(nn)+kk-1:childMinJ + yLine(nn)+kk+1,  ...
                childMinI + xLine(nn)-kk-1:childMinI + xLine(nn)-kk+1   ...
                );
        childHNew(childMinJ + yLine(nn)+kk,childMinI + xLine(nn)-kk) = mean(ans(:));
            
    end;   
end;

for nn=1:length(xLine)
    for kk=-10:10
        childH(                                                         ...
                childMinJ + yLine(nn)+kk-1:childMinJ + yLine(nn)+kk+1,  ...
                childMinI + xLine(nn)-kk-1:childMinI + xLine(nn)-kk+1   ...
                );
        childHNew(childMinJ + yLine(nn)+kk,childMinI + xLine(nn)-kk) = mean(ans(:));
            
    end;   
end;

childH = childHNew;

fig(94);
pcolor(childH(childJRange,childIRange));shading flat
caxis([0 1000])
title('new child grid bathy')


nc_varput(childFile,'h',childH);


aaa=5;

%% Update the child grid bathymetry - stuff that didn't work

% childHNew = childH;
%
% for ii=1:length(xLine)
%     for jj=-6:6
% %         childHNew(childJRange(1)+yLine(ii)+jj,childIRange(1)+xLine(ii)) = w2*mean(dum1(:)) + w1*mean(dum2(:));
%         childHNew(childJRange(1)+yLine(ii)+jj,childIRange(1)+xLine(ii))=1*sourceH(sourceJRange(1)+yLine(ii)+jj,sourceIRange(1)+xLine(ii));
% end;end;
%
% for ii=1:length(xLine)
%     for jj=5:9
%         dum1 = sourceH(sourceJRange(1)+yLine(ii)+jj-1:sourceJRange(1)+yLine(ii)+jj+1,sourceIRange(1)+xLine(ii)-1:sourceIRange(1)+xLine(ii)+1);
%         dum2 =  childH( childJRange(1)+yLine(ii)+jj-1:childJRange(1) +yLine(ii)+jj+1, childIRange(1)+xLine(ii)-1:childIRange(1) +xLine(ii)+1);
%         w2 = (jj-5)/5;
%         w1 = (10-jj)/5;
%         [jj,w1,w2];
%         aaa=5;
%         childHNew(childJRange(1)+yLine(ii)+jj,childIRange(1)+xLine(ii))=w1*sourceH(sourceJRange(1)+yLine(ii)+jj,sourceIRange(1)+xLine(ii))+w2*childH(childJRange(1)+yLine(ii)+jj,childIRange(1)+xLine(ii));
% end;end;
%
% fig(195);
% pcolor(childHNew(childJRange,childIRange));shading flat
% caxis([0 1000])
% title('updated child grid bathy')
%
% % try to round off the corner
%
% for ii=1:length(xLine)
%     for jj=3:5
%         childHNew(childJRange(1)+yLine(ii)+jj-1:childJRange(1)+yLine(ii)+jj+1 ...
%             ,                                                                 ...
%             childIRange(1)+xLine(ii)-1:childIRange(1)+xLine(ii)+1             ...                                                                    ...
%             );
%         childHNew(childJRange(1)+yLine(ii)+jj,childIRange(1)+xLine(ii)) = mean(ans(:));
%     end;
%     for jj=-2:-1:-4
%         childHNew(childJRange(1)+yLine(ii)+jj-1:childJRange(1)+yLine(ii)+jj+1 ...
%             ,                                                                 ...
%             childIRange(1)+xLine(ii)-1:childIRange(1)+xLine(ii)+1             ...                                                                    ...
%             );
%         childHNew(childJRange(1)+yLine(ii)+jj,childIRange(1)+xLine(ii)) = mean(ans(:));
%     end;
% end;
%
%
% % for ii=1:length(xLine)
% %     for jj=-10:-5
% %         dum1 = sourceH(sourceJRange(1)+yLine(ii)+jj-1:sourceJRange(1)+yLine(ii)+jj+1,sourceIRange(1)+xLine(ii)-1:sourceIRange(1)+xLine(ii)+1);
% %         dum2 =  childH( childJRange(1)+yLine(ii)+jj-1:childJRange(1) +yLine(ii)+jj+1, childIRange(1)+xLine(ii)-1:childIRange(1) +xLine(ii)+1);
% %         w2 = -(jj+5)/5;
% %         w1 = (10+jj)/5;
% %         [jj,w1,w2];
% %         aaa=5;
% %         childHNew(childJRange(1)+yLine(ii)+jj,childIRange(1)+xLine(ii))=w1*sourceH(sourceJRange(1)+yLine(ii)+jj,sourceIRange(1)+xLine(ii))+w2*childH(childJRange(1)+yLine(ii)+jj,childIRange(1)+xLine(ii));
% % end;end;
%
% fig(95);
% pcolor(childHNew(childJRange,childIRange));shading flat
% caxis([0 1000])
% title('updated child grid bathy')
%
% nc_varput(childFile,'h',childHNew);
%
% aaa=5;

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







