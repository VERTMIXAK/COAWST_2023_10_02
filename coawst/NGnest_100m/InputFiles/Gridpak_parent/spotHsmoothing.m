clear; close all
tabwindow;



oldFile = 'NGnest_100m_parent.nc_19Sept';
newFile = 'NGnest_100m_parent.nc';

% unix(['cp ',oldFile,' ',newFile]);

mask = nc_varget(newFile,'mask_rho');
hraw = nc_varget(newFile,'hraw');
[~,ny,nx] = size(hraw);

htemp1 = sq(hraw(2,:,:));
htemp2 = sq(hraw(2,:,:));

%% Simple plot
fig(1);clf;
pcolor(htemp1);shading flat;
caxis([0 85])
aaa=5;


%% Smooth in the bay

% Do this by masking the bay and then smoothing everything under the mask

x0 = 80;
x1 = 160;
y0 = 185;
y1 = 220;

fig(2);clf
pcolor(mask);shading flat
hold on
line([x0 x1],[y0 y1],'Color','green')

slope = (y1-y0)/(x1-x0);
% mask = 1 +  0*htemp1;

delta = 1;

for iterations=1:3
    for ii=x0:x1; for jj=y0:ny-delta
            if jj > y0 + slope * (ii - x0)
                htemp1(jj-delta:jj+delta,ii-delta:ii+delta);
                htemp2(jj,ii) = nanmean(ans(:));
            end
        end;end;
    htemp1 = htemp2;
end;

fig(3);clf;
pcolor(htemp1);shading flat;
caxis([0 85])

aaa=5;


%% Fix spot near western boundary

myI = [1:30];
myJ = [150:170];

fig(4);clf;
pcolor(myI,myJ,htemp1(myJ,myI));shading flat;hold on;colorbar
caxis([0 85])

for ii=1:30; for jj=150:170
        if htemp1(jj,ii) > 40
            htemp1(jj,ii) = 40;
        end;
    end;end;

fig(5);clf;
pcolor(myI,myJ,htemp1(myJ,myI));shading flat;hold on;colorbar
caxis([0 85])


aaa=5;

%% Fix another spot

myI = [100:120];
myJ = [100:150];

fig(6);clf;
pcolor(myI,myJ,htemp1(myJ,myI));shading flat;hold on;colorbar
caxis([0 70])

for ii=myI; for jj=myJ
        if htemp1(jj,ii) > 50
            htemp1(jj,ii) = 50;
        end;
end;end;

fig(7);clf;
pcolor(myI,myJ,htemp1(myJ,myI));shading flat;hold on;colorbar
caxis([0 70])


aaa=5;


%% Smooth the coast near the W edge of the child grid


myI = [45:70];
myJ = [174:200];

fig(8);clf;
pcolor(myI,myJ,htemp1(myJ,myI));shading flat;hold on;colorbar
caxis([0 60])

htemp2=htemp1;
delta = 1;
nIterations = 3;
for nn=1:nIterations
for jj=myJ; for ii=myI
        %     if mask(jj,ii) == 0
        htemp1(jj-delta:jj+delta,ii-delta:ii+delta);
        htemp2(jj,ii) = nanmean(ans(:));
        %     end;
    end;end;
htemp1=htemp2;
end;

fig(9);clf;
pcolor(myI,myJ,htemp1(myJ,myI));shading flat;hold on;colorbar
caxis([0 60])

aaa=5;





fig(20);clf;
pcolor(htemp1);shading flat
caxis([0 85])



%% Smooth the island

myI = [56:72];
myJ = [135:162];

fig(8);clf;
pcolor(myI,myJ,htemp1(myJ,myI));shading flat;hold on;colorbar
caxis([0 60])

htemp2=htemp1;
delta = 1;
for jj=myJ; for ii=myI
        %     if mask(jj,ii) == 0
        htemp1(jj-delta:jj+delta,ii-delta:ii+delta);
        htemp2(jj,ii) = nanmean(ans(:));
        %     end;
    end;end;
htemp1=htemp2;

fig(9);clf;
pcolor(myI,myJ,htemp1(myJ,myI));shading flat;hold on;colorbar
caxis([0 60])

aaa=5;





fig(20);clf;
pcolor(htemp1);shading flat
caxis([0 85])



%% Smooth the sandbar near the eastern boundary

myI = [140:187];
myJ = [150:250];

fig(8);clf;
pcolor(myI,myJ,htemp1(myJ,myI));shading flat;hold on;colorbar
caxis([0 60])

htemp2=htemp1;
delta = 1;
nIterations=3
for nn=1:nIterations
for jj=myJ; for ii=myI
        %     if mask(jj,ii) == 0
        htemp1(jj-delta:jj+delta,ii-delta:ii+delta);
        htemp2(jj,ii) = nanmean(ans(:));
        %     end;
    end;end;
htemp1=htemp2;
end;

fig(9);clf;
pcolor(myI,myJ,htemp1(myJ,myI));shading flat;hold on;colorbar
caxis([0 60])

aaa=5;





fig(20);clf;
pcolor(htemp1);shading flat
caxis([0 85])



%% Write what I've got to level 3

hraw(3,:,:) = htemp1;
nc_varput(newFile,'hraw',hraw);

aaa=5;

