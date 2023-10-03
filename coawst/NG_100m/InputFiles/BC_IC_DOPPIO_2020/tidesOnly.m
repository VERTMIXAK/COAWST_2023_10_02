% There are two versions of the detided BC file. The DOPPIO data have to be
% downloaded for every hour because they contain the tides, so the large
% "detided" file is on hourly intervals. This is overkill, because once you
% lowpass filter the tides out the time evolution is really slow. In short,
% the smaller version of the "detided" file is subsetted from the original
% at the rate of 1 snapshot per day. 

% What's more, a tidesOnly experiment consists of a deadStill experiment
% with tidal forcing, so what I will do here is add motion to the Flat BC
% file

deadStillBCfile = 'Flat_2020_bdry_NG_100m.nc_hourly'            % I am going to add tidal motion to this file
    tidedBCfile = 'DOPPIO_2020_bdry_NG_100m.nc_hourly'                 % This is constructed straight from the DOPPIO downloads
  detidedBCfile = 'DOPPIO_2020_bdry_NG_100m_detided.nc_hourly'  % This is on hourly intervals

tidesOnlyBCfile = 'DOPPIO_2020_bdry_NG_100m_tidesOnly.nc_hourly'

unix(['cp ',deadStillBCfile,' ',tidesOnlyBCfile]);


%% make variable list

varNames={'zeta_north' ...
'zeta_south' ...
'zeta_east' ...
'zeta_west' ...
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

%%

for vv=1:length(varNames)
    varNames{vv}
    old1 = nc_varget(tidedBCfile  ,varNames{vv} );
    old2 = nc_varget(detidedBCfile,varNames{vv} );
    new = old1 - old2;
    
    nc_varput(tidesOnlyBCfile,varNames{vv},new);
end;



%%

% times=nc_varget(tidedBCfile,'ocean_time');
% nt = length(times)
% 
% % dt = (times(2)-times(1))*24    % time step in hours
% 
% diff(times);dt = mean(ans)*24
% 
% nb = 9;
% 
% win = 4* 24/dt
% 
% proto = ubarTided(:,10)-ubarDeTided(:,10);
% fig(10);clf;plot(proto)
% 
% new= hls_lowpassbutter(proto,8/win,1,nb);
% 
% [f,G_ORIG]=hls_spectra(proto);
% [f,G_smoo]=hls_spectra(new);
% 
% figure(20);clf
% subplot(2,1,1)
% semilogy(f/3,G_ORIG,'b');hold on;
% semilogy(f/3,G_smoo,'r');hold on;
% legend('orig','new')
% plot([1 1]/12.42,[1e-3 1e0])
% plot([1 1]/24,[1e-3 1e0]);ylim([1e-12,1e2])
% subplot(2,1,2)
% plot(proto,'b');hold on
% plot(new,'k');
% 
% fig(11);clf;
% plot(proto,'b');hold on
% plot(new,'k');
% 
% fig(12);clf;
% plot(new,'k');
% 
% 
