clear all

% this script contains code to reproduce Figure 5c-d, f, h-j

%% load data

% drag and drop corresponding file (S5 Data)

%% data content description

% behavior contains video energy data form the face (behavior.whisking) and
% the wheel (behavior.wheel) of the size 1801 frames (fs=20Hz) x 14 trials x 22
% sessions
% behavior also contains corresponding data from YFP injected control animals (behavior.wheel_YFP /
% behavior.whisking_YFP, 12 sessions)

% fUS contains trial-averaged functional ultrasound data from three ROIs in
% midbrain/thalamus and striatum (180 frames (fs=2Hz) x 16 sessions)
% fUS also contains corresponding data from YFP injected control animals ('_YFP'-ending variables, 12 sessions)

% ephys contains electrophysiological data from the midbrain. epyhs.spikes
% contains all the spikes (12 recording site, 30 trials x no of cells per
% recording). ephys.spikes_conv contains convoled and normalized firing
% rates (118 cells x 10000 frames (fs=1000Hz))

%% add paths to functions

addpath("functions and helpers");

%% behavior
%% Figure 5c
close all

% select a session
nsession=1;
Wheel_plot = behavior.wheel(:,:,nsession);

% parameters
fs=20; % in Hz
baseL = fs*40; % extract 40 sec before onset
baseA = fs*50; % 10 sec (stim) and 40 sec after stim
length_rec = 25; % in min
time_frames = 1:fs*60*length_rec;
time_sec = time_frames/fs;

% plot data
t1 = time_sec(1:1800)-baseL/20;
figure(92); 
patch([0 10 10 0],[0 0 16 16],[0.5 0.75 1],'edgecolor','none','FaceAlpha',0.5); hold on
for i_trial = 1:size(Wheel_plot,2)
    plot(t1,rescale(Wheel_plot(1:size(t1,2),i_trial)) + i_trial,'k')
end
xlabel('time (sec)'); ylabel('trial #');
set(gca,'TickDir','out');
set(gcf,'renderer','Painters')

%% Figure 5d (ChR2)
close all

% trial average
behavior_whisking_avg=squeeze(mean(behavior.whisking,2));
behavior_wheel_avg=squeeze(mean(behavior.wheel,2));

% plot data
smooth=60;
f=figure(91); set(f,'renderer','Painters');
patch([800 1000 1000 800],[0 0 12 12],[0.5 0.75 1],'edgecolor','none','FaceAlpha',0.5); hold on;
options.handle=figure(91);options.color_area=[203 154 194]./255; options.color_line=[153 43 141]./255;options.alpha=1;options.line_width = 2;options.error='sem';
plot_areaerrorbar(movmean(behavior_whisking_avg',smooth,2),options); set(gca,'TickDir','out'); box off; hold on;
options2.handle=figure(91);options2.color_area=[135 135 168]./255; options2.color_line=[43 43 119]./255;options2.alpha=1;options2.line_width = 2;options2.error='sem';
plot_areaerrorbar(movmean(behavior_wheel_avg',smooth,2),options2); set(gca,'TickDir','out'); box off; hold on;
set(gca,'TickDir','out');
f.Position=[100 100 600 800];
set(f,'renderer','Painters');
ylabel('Z-score'); xlabel('Time (frames)')

% values in text
[peak_whisk,idx]=max(mean(movmean(behavior_whisking_avg,smooth,1),2),[],1);
tmp=movmean(behavior_whisking_avg(:,:),smooth,1);
std_whisk=std(tmp(idx,:),[],2)/sqrt(size(tmp,2))

[peak_wheel,idx]=max(mean(movmean(behavior_wheel_avg,smooth,1),2),[],1);
tmp=movmean(behavior_wheel_avg(:,:),smooth,1);
std_wheel=std(tmp(idx,:),[],2)/sqrt(size(tmp,2))

%% Figure 5d (YFP)
close all

% trial average
behavior_whisking_avg=squeeze(mean(behavior.whisking_YFP,2));
behavior_wheel_avg=squeeze(mean(behavior.wheel_YFP,2));

% plot data
smooth=60;
f=figure(91); set(f,'renderer','Painters');
patch([800 1000 1000 800],[0 0 12 12],[0.5 0.75 1],'edgecolor','none','FaceAlpha',0.5); hold on;
options.handle=figure(91);options.color_area=[203 154 194]./255; options.color_line=[153 43 141]./255;options.alpha=1;options.line_width = 2;options.error='sem';
plot_areaerrorbar(movmean(behavior_whisking_avg',smooth,2),options); set(gca,'TickDir','out'); box off; hold on;
options2.handle=figure(91);options2.color_area=[135 135 168]./255; options2.color_line=[43 43 119]./255;options2.alpha=1;options2.line_width = 2;options2.error='sem';
plot_areaerrorbar(movmean(behavior_wheel_avg',smooth,2),options2); set(gca,'TickDir','out'); box off; hold on;
set(gca,'TickDir','out');
f.Position=[100 100 600 800];
set(f,'renderer','Painters');
ylabel('Z-score'); xlabel('Time (frames)')

% values in text
[peak_whisk,idx]=max(mean(movmean(behavior_whisking_avg,smooth,1),2),[],1);
tmp=movmean(behavior_whisking_avg(:,:),smooth,1);
std_whisk=std(tmp(idx,:),[],2)/sqrt(size(tmp,2))

[peak_wheel,idx]=max(mean(movmean(behavior_wheel_avg,smooth,1),2),[],1);
tmp=movmean(behavior_wheel_avg(:,:),smooth,1);
std_wheel=std(tmp(idx,:),[],2)/sqrt(size(tmp,2))

%% Figure S8b
close all

% select session
nsession=1;
Whisker_plot = behavior.whisking(:,:,nsession); 

% plot data
t1 = time_sec(1:1800)-baseL/20;
figure(92); 
patch([0 10 10 0],[0 0 16 16],[0.5 0.75 1],'edgecolor','none','FaceAlpha',0.5); hold on
for i_trial = 1:size(Whisker_plot,2)
    plot(t1,rescale(Whisker_plot(1:size(t1,2),i_trial)) + i_trial,'k')
end
xlabel('time (sec)'); ylabel('trial #');
set(gca,'TickDir','out');

%% fUS
%% Figure 5f
close all

colors={[125 163 153],[150 203 194],[110,110,110],[130,130,130]};
colors_line={[33 129 121],[43 153 141],[80,80,80],[100,100,100]};
smooth=10;

f=figure(91); set(f,'renderer','Painters');
patch([80 100 100 80],[-0.01 -0.01 0.04 0.04],[0.5 0.75 1],'edgecolor','none','FaceAlpha',0.5); hold on;
for i=1:4
    if i==1
        I_selec=fUS.I_striatum;
    elseif i==2
        I_selec=fUS.I_thalamus;
    elseif i==3
        I_selec=fUS.I_striatum_YFP;
    elseif i==4
        I_selec=fUS.I_thalamus_YFP;
    end

    I_smooth=movmean(I_selec,smooth,1);

    options.handle=figure(91);options.color_area=colors{i}./255; options.color_line=colors_line{i}./255;options.alpha=0.5;options.line_width = 2;options.error='sem';
    plot_areaerrorbar(I_smooth',options); set(gca,'TickDir','out'); box off; hold on;
    
end
set(gca,'TickDir','out');
f.Position=[100 100 800 600];
set(f,'renderer','Painters');
ylabel('\DeltaI/I (%)');
xlabel('Time (frames)')

%% Figure 5h
close all

I_smooth=movmean(fUS.I_midbrain,smooth,1);

options.handle=figure(91);options.color_area=[100,100,100]./255; options.color_line=[60,60,60]./255;options.alpha=0.5;options.line_width = 2;options.error='sem';
plot_areaerrorbar(I_smooth',options); set(gca,'TickDir','out'); box off; hold on;
set(gca,'TickDir','out');
options.handle.Position=[100 100 800 600];
set(options.handle,'renderer','Painters');
ylabel('\DeltaI/I (%)');
xlabel('Time (frames)');

%% ephys
%% Figure 5h
close all

smooth=40;
f=figure(91);
patch([4500 5500 5500 4500],[-1 -1 25 25],[0.5 0.75 1],'edgecolor','none','FaceAlpha',0.5); hold on;
options.handle=figure(91);options.color_area=[80 80 80]./255; options.color_line=[0 0 0]./255;options.alpha=1;options.line_width = 2;options.error='sem';
plot_areaerrorbar(movmean(ephys.spikes_conv,smooth,2),options); set(gca,'TickDir','out'); box off; hold on;
set(gca,'TickDir','out');
f.Position=[100 100 800 600];
ylabel('norm. FR');
xlabel('Time (frames)');

%% Figure 5i
close all

f=figure; imagesc(ephys.spikes_conv); caxis([-5 5]); cmap = colorbarpwn(-2, 2, 'off');
f.Position=[100 100 400 600];
box off; set(gca,'TickDir','out');
ylabel('Neurons');
xlabel('Time (frames)');

%% Figure 5j
close all

% pick a cells
no=19;  % 19 for ON cell (cell 1), 72 for OFF cell (cell 3), 66 for DEACT cell (cell 2)

% find the spikes of that cell
ncount=0;
for nsess=1:length(ephys.spikes)    
    for ncell=1:size(ephys.spikes{1,nsess},2)
        ncount=ncount+1;
        if ncount==no
           nsess2=nsess;
           ncell2=ncell;
        end
    end
end

% plot spikes using gramm toolbox
spike_train=ephys.spikes{1,nsess2}(:,ncell2);
clear g
g(1,1)=gramm('x',spike_train);
g(1,1).geom_raster();
g.set_names('x','Time','y','Trials');
g.axe_property('TickDir','out');
g.set_color_options('chroma',0,'lightness',0);
figure('Position',[100 100 800 150]);
g(1,1).geom_polygon('x',{[4.5 5.5 5.5 4.5]},'y',{[0 0 30 30]},'color',[0.5 0.75 1],'alpha',0.9);
g.draw();
set(gcf,'renderer','Painters');

