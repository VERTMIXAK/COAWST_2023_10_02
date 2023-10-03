load /import/c1/VERTMIX/jgpender/ROMS/BathyData/Palau_5_100_130.00_140.00_2.00_11_merge_100m_07-Feb-2019.mat
%%
grd1=roms_get_grid('/import/c1/VERTMIX/jgpender/coawst//PALAU_800m/InputFiles/Gridpak_HyBk/PALAU_800mHB.nc')
grd2=roms_get_grid('/import/c1/VERTMIX/jgpender/coawst//PALAU_800m/InputFiles/Grid_3to1/PALAU_800m_child.nc')

% look at hraw
hraw = nc_varget('../Gridpak_HyBk/PALAU_800mHB.nc','hraw');

hOrig   = sq(hraw(2,:,:));
hSmooth = sq(hraw(4,:,:));

aaa=5;



 bb=[134.18 134.22 6.91 6.95]
 idx=find(merge.lon>bb(1)&merge.lon<bb(2));
  jdx=find(merge.lat>bb(3)&merge.lat<bb(4));

  figure(1);clf;colormap(flipud(gray))
  lon0 = 134.2;lat0=6.93
  %subplot(2,2,1)
pcolor(merge.lon(idx),merge.lat(jdx),medfilt2(merge.D(jdx,idx)));shading flat;hold on
contour(merge.lon(idx),merge.lat(jdx),merge.D(jdx,idx),[0 0],'g','linew',2);
[c,h]=contour(merge.lon(idx),merge.lat(jdx),merge.D(jdx,idx),[30 100 1000 3000],'k');
[c,h]=contour(merge.lon(idx),merge.lat(jdx),merge.D(jdx,idx),[30 30],'r');
clabel(c,h,'labelspacing',1e3/2,'fontsi',16)
daspect([1 cosd(7) 1]); % make map plot with approx correct aspect ratio
caxis([0,8000]);
plot(lon0,lat0,'bv')
[jdx1,idx1]=hls_get_indices_of_2d_lon_lat(grd1.lon_rho,grd1.lat_rho,lon0,lat0,0)
[jdx2,idx2]=hls_get_indices_of_2d_lon_lat(grd2.lon_rho,grd2.lat_rho,lon0,lat0,0)
jdx3 = nearest(merge.lat,lat0);
plot(grd1.lon_rho(jdx1,:),grd1.lat_rho(jdx1,:),'k--')
plot(grd2.lon_rho(jdx2,:),grd2.lat_rho(jdx2,:),'r.')

figure(2);clf
% a=plot(grd1.lon_rho(jdx1,:),grd1.h(jdx1,:),'k-','linew',2);axis ij;hold on
% b=plot(grd2.lon_rho(jdx2,:),grd2.h(jdx2,:),'r-','linew',2);axis ij;hold on

a=plot(grd1.lon_rho(jdx1,:),hOrig(jdx1,:),'k-','linew',2);axis ij;hold on
b=plot(grd1.lon_rho(jdx1,:),hSmooth(jdx1,:),'r-','linew',2);axis ij;hold on

c=plot(merge.lon,merge.D(jdx3,:),'b-','linew',2)
legend([a,b,c],'grd1','grd2','merge source data')

vlines(lon0)
ylim([0,1500]);xlim([134.05 134.275])

