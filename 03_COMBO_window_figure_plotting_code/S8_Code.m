clear all

% this script contains code to reproduce Figure S7a-c, note that data for
% reproduction of Figure S7c is saved in S3 Data

%% load data

% drag and drop corresponding file (S8 Data)

%% data content description

% D contains the region acronyms
% I_anes contains segemented data from anesthetized recordings (32 sessions, 100 regions x 576 frames)
% I_awake contains segemented data from awake recordings (46 sessions, 100 regions x 576 frames)

%% add paths to functions
addpath("functions and helpers");

%% Figure S7a
close all

% select region
reg=find(matches(D,["SC"]),1);

% rearrange data
I_heatmap=[];
for isess=1:length(I_awake) 
    I_sess=I_awake{isess};
    I_reg=I_sess(reg,:);
    I_heatmap(isess,:)=I_reg;
end

% plot data
f=figure; imagesc(movmean(I_heatmap,5,2));
xlabel('Time (frames)');
ylabel('Sessions')
caxis([-0.05 0.05]);
cmap = colorbarpwn(-0.05, 0.05, 'off');
set(gca,'TickDir','out');
box off;
f.Position= [100 100 800 200];

%% Figure S7b
close all

% select region
reg=find(matches(D,["SC"]),1);

% rearrange data
I_heatmap2=[];
for isess=1:length(I_anes) 
    I_sess=I_anes{isess};
    I_reg=I_sess(reg,:);
    I_heatmap2(isess,:)=I_reg;
end

% plot data
f=figure; imagesc(movmean(I_heatmap2,5,2));
xlabel('Time (frames)');
ylabel('Sessions')
caxis([-0.03 0.03]);
cmap = colorbarpwn(-0.03, 0.03, 'off');
set(gca,'TickDir','out');
box off;
f.Position= [100 100 800 200];

% stimulus timing
tblock=48; % length of a stimulus block in frames
nstimuli=4; % number of stimuli directions
ntrials=3; % number of repitions of each stimulus
T1=13; % start of stimulus in frames
T2=36; % stop of stimulus in frames

sig=zeros(48, 4, 3);
sig(13:36,:)=1;
f=figure;
plot(sig(:),'k');
box off; 
set(gca,'TickDir','out');
f.Position= [100 100 800 200];

%% Figure S7c

%% load other file

% drag and drop corresponding file (S3 Data)

%% plot Figure
close all

% get region index
reg=find(matches(D,["VISp"]),1); % or "SC"

% smooth data a bit and plot
smooth=5;
I_smooth=squeeze(movmean(I_anes(reg,:,:),smooth,2));
f=figure(91);
plot_areaerrorbar(I_smooth');
hold on; 

% plot stiumulus timing
sig=zeros(tblock,nstimuli);
sig(T1:T2,:)=max(mean(I_smooth,2),[],'omitnan');
plot(sig(:),'k--');

% graph settings
set(gca,'xtick',[]);
set(gca,'XColor','none');
set(gca,'FontSize',20);
set(gca,'FontName','Helvetica-Narrow');
ylabel('\DeltaI/I (%)','FontSize',20,...
    'FontName','Helvetica-Narrow')
box off;
f.Position=[200 200 1200 200];
yt=yticks;
yticklabels([yt*100]);