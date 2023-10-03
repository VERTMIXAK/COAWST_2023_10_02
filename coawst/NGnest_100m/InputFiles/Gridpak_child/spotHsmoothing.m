clear; close all
tabwindow;



oldFile = 'NGnest_100m_child.nc_21Sept';
newFile = 'NGnest_100m_child.nc';

% unix(['cp ',oldFile,' ',newFile]);

mask = nc_varget(newFile,'mask_rho');
hraw = nc_varget(newFile,'hraw');
[~,ny,nx] = size(hraw);

htemp1 = sq(hraw(2,:,:));
htemp2 = sq(hraw(2,:,:));

%% Simple plot
fig(1);clf;
pcolor(htemp1);shading flat;
caxis([0 65])
aaa=5;



%% Fix spot around Block Island

myI = [1:250];
myJ = [150:500];



fig(4);clf;
pcolor(myI,myJ,htemp1(myJ,myI));shading flat;hold on;colorbar
caxis([0 55])

for ii=myI; for jj=myJ
        if htemp1(jj,ii) > 40
            htemp1(jj,ii) = 40;
        end;
    end;end;

fig(5);clf;
pcolor(myI,myJ,htemp1(myJ,myI));shading flat;hold on;colorbar
caxis([0 55])

% myI = [120:155];
% myJ = [300:395];

myI = [70:190];
myJ = [190:390];

fig(6);clf;
pcolor(myI,myJ,htemp1(myJ,myI));shading flat;hold on;colorbar
caxis([0 55])


delta = 1;
for iterations=1:5
    htemp2 = htemp1;
    for ii=myI; for jj=myJ
                htemp1(jj-delta:jj+delta,ii-delta:ii+delta);
                htemp2(jj,ii) = nanmean(ans(:));
        end;end;
    htemp1 = htemp2;
end;


myI = [70:190];
myJ = [190:390];

fig(7);clf;
pcolor(myI,myJ,htemp1(myJ,myI));shading flat;hold on;colorbar
caxis([0 55])



aaa=5;




%% Fix spot at the mouth of the Bay

myI = [350:420];
myJ = [640:800];

fig(4);clf;
pcolor(myI,myJ,htemp1(myJ,myI));shading flat;hold on;colorbar
caxis([0 55])

for ii=myI; for jj=myJ
        if htemp1(jj,ii) > 30
            htemp1(jj,ii) = 30;
        end;
    end;end;

fig(5);clf;
pcolor(myI,myJ,htemp1(myJ,myI));shading flat;hold on;colorbar
caxis([0 55])


aaa=5;



%% Fix yet another spot in the Bay

myI = [400:480];
myJ = [800:920];

fig(14);clf;
pcolor(myI,myJ,htemp1(myJ,myI));shading flat;hold on;colorbar
caxis([0 35])

for ii=myI; for jj=myJ
        if htemp1(jj,ii) > 22
            htemp1(jj,ii) = 22;
        end;
    end;end;

fig(15);clf;
pcolor(myI,myJ,htemp1(myJ,myI));shading flat;hold on;colorbar
caxis([0 35])

fig(16);clf;
pcolor(htemp1);shading flat;
caxis([0 65])


aaa=5;





%% Smooth in the bay

% Do this by masking the bay and then smoothing everything under the mask

x0 = 240;
% x1 = 622;
x1 = 777;
y0 = 537;
% y1 = 720;
y1 = 575;

fig(2);clf
% pcolor(mask);shading flat
pcolor(htemp1);shading flat
hold on
line([x0 x1],[y0 y1],'Color','red')

slope = (y1-y0)/(x1-x0);
% mask = 1 +  0*htemp1;

delta = 2;
for iterations=1:5
    htemp2 = htemp1;
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
caxis([0 65])

myI = [350:420];
myJ = [640:800];

fig(44);clf;
pcolor(myI,myJ,htemp1(myJ,myI));shading flat;hold on;colorbar
caxis([0 55])

aaa=5;


%% Write what I've got to level 3

hraw(3,:,:) = htemp1;
nc_varput(newFile,'hraw',hraw);

aaa=5;

