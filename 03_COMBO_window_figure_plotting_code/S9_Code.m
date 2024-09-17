clear all

% this script contains code to reproduce Figure S8b-c, f-g

%% load data

% drag and drop corresponding file (S9 Data)

%% data content description

% behavior contains video energy data form the wheel (behavior.wheel) of the size 1801 frames (fs=20Hz) x 14 trials x 22
% sessions

% fUS contains functional ultrasound data from optogenetic activation experiments
% fUS.I_awake contains trial-averaged and segmented fUS data (83 regions x 180 frames (fs=2Hz) x 16 sessions)
% fUS.p_awake contains FDR corrected p values for testing whether regions
% are visually active ( correlation to stimulus)
% fUS.D contains the region acronyms
% fUS.I_midbrain_highLoc i.e. contains fUS data from ROI in the midbrain (15
% sessions, 180 frames (fs=2Hz), varying no. of trials), specifically only
% from trials in which the mouse was substantially moving in response to
% the optogenetic stimulation (lowLoc trials with little movement)

% ephys contains indices for different response cell types

%% add paths to functions

addpath("functions and helpers");

%% behavior
%% Figure S8b
close all

% select a session
nsession=1;
Whisk_plot = behavior.whisking(:,:,nsession);

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
for i_trial = 1:size(Whisk_plot,2)
    plot(t1,rescale(Whisk_plot(1:size(t1,2),i_trial)) + i_trial,'k')
end
xlabel('time (sec)'); ylabel('trial #');
set(gca,'TickDir','out');
set(gcf,'renderer','Painters')

%% fUS
%% Figure S8c, plot all regions
smooth=8;
thres=0.01;
p=fUS.p_awake < thres;

I_selec2=movmean(fUS.I_awake,smooth,2);
figure; imagesc(mean(I_selec2(p,:,:),3,'omitnan'));
xlabel('Time (frames)');
ylabel('Regions')
caxis([-0.03 0.03]);
cmap = colorbarpwn(-0.03, 0.03, 'off');
yticks(1:size(I_selec2,1));
yticklabels(fUS.D(p));
set(gca,'TickDir','out');
box off;
f=gcf;
f.Position=[0 0 400 800];

%% Figure S8f thalamus
close all

colors={[135 135 168],[155 155 188]};
colors_line={[43 43 119],[63 63 139]};
smooth=10;

f=figure(91); set(f,'renderer','Painters');
patch([80 100 100 80],[-0.01 -0.01 0.04 0.04],[0.5 0.75 1],'edgecolor','none','FaceAlpha',0.5); hold on;
for i=1:2
    if i==1
        I_selec=[];
        for k=1:length(fUS.I_thalamus_highLoc)
            I_selec(:,k)=mean(fUS.I_thalamus_highLoc{k},2);
        end    
    elseif i==2
        I_selec=[];
        for k=1:length(fUS.I_thalamus_lowLoc)
            I_selec(:,k)=mean(fUS.I_thalamus_lowLoc{k},2);
        end    
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

%% Figure S8f striatum
close all

colors={[211,110,146],[231 175 208]};
colors_line={[206,33,86],[236,53,96]};
smooth=10;

f=figure(91); set(f,'renderer','Painters');
patch([80 100 100 80],[-0.01 -0.01 0.04 0.04],[0.5 0.75 1],'edgecolor','none','FaceAlpha',0.5); hold on;
for i=1:2
    if i==1
        I_selec=[];
        for k=1:length(fUS.I_striatum_highLoc)
            I_selec(:,k)=mean(fUS.I_thalamus_highLoc{k},2);
        end    
    elseif i==2
        I_selec=[];
        for k=1:length(fUS.I_striatum_lowLoc)
            I_selec(:,k)=mean(fUS.I_thalamus_lowLoc{k},2);
        end    
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

%% ephys
%% Figure S8g

labels={'ON','OFF','deAct','inactive'};
figure; pie(cat(2,sum(ephys.idx_ON),sum(ephys.idx_OFF),sum(ephys.idx_deAct),sum(ephys.idx_nonAct)));
lgd = legend(labels,'location','bestoutside');
