clear all

% this script contains code to reproduce Figure 3b, 3e-d

%% load data

% drag and drop corresponding file (S3 Data)

%% data content description

% D contains the region acronyms
% I_anes contains segemented and trial-averged data from anesthetized recordings (100 regions x 192 frames x 32 sessions)
% p_anes_corrected contains the corrected p values for correlation of
% signal to stimulus timing to assess which regions are visually active
% I_awake contains segemented and trial-averged data from awake recordings (100 regions x 192 frames x 46 sessions)
% p_awake_corrected contains the corrected p values for correlation of
% signal to stimulus timing to assess which regions are visually active

%% add paths to functions

addpath("functions and helpers");

%% parameters
% each stimulus consist of 48 frames (12 frames baseline, 24 frames
% stimulus, 12 frames baseline), 4 stimuli x 48 frames = 192 frames

T1=13; % stim start in frames
T2=36; % stim stop in frames
tblock=48; % in frames
nstimuli=4;

%% Figure 3d
close all

thres=0.05;
smooth=7;

p_awake=p_awake_corrected<thres;
p_anes=p_anes_corrected<thres;

[~,idx]=sort(p_anes_corrected);
tmp1=I_awake(idx,:,:);
p_tmp=p_awake(idx);

figure; 
t=tiledlayout(1,2);
t.TileSpacing='compact';
nexttile;
imagesc(mean(movmean(tmp1(p_tmp,:,:),smooth,2),3,'omitnan'));
xlabel('Time (frames)');
ylabel('Regions')
caxis([-0.03 0.03]);
cmap = colorbarpwn(-0.03, 0.03, 'off');
yticks(1:size(I_awake,1));
D_tmp=D(idx);
yticklabels(D_tmp(p_tmp));
set(gca,'TickDir','out');
box off;
title('awake');

nexttile;
tmp2=I_anes(idx,:,:);
imagesc(mean(movmean(tmp2(p_tmp,:,:),smooth,2),3,'omitnan'));
xlabel('Time (frames)');
caxis([-0.03 0.03]);
cmap = colorbarpwn(-0.03, 0.03, 'off');
colormap (cmap);
yticks(1:size(I_awake,1));
yticklabels({});
set(gca,'TickDir','out');
box off;
title('anesthetized');

%% Figure 3e
close all

% define time window of interest
T1_conv=17; % this is to account for slow nature of fUS signal
T2_conv=42; % this is to account for slow nature of fUS signal
win=[T1_conv:T2_conv,1*tblock+T1_conv:1*tblock+T2_conv,2*tblock+T1_conv:2*tblock+T2_conv,3*tblock+T1_conv:3*tblock+T2_conv];

% average sessions
I_anes2=mean(I_anes,3);
I_awake2=mean(I_awake,3);

% get indices to only plot visually active regions
p_all=or(p_anes,p_awake);
p_active=mean(I_awake2(:,win),2)>0;

% plot data
f=figure; scatter(mean(I_anes2(and(p_active,p_all),win),2,'omitnan'),mean(I_awake2(and(p_active,p_all),win),2,'omitnan'),125,'MarkerEdgeColor','k','MarkerFaceColor',[0.7 0.1 0.1] ,'LineWidth',1);
hold on; scatter(mean(I_anes2(and(~p_active,p_all),win),2,'omitnan'),mean(I_awake2(and(~p_active,p_all),win),2,'omitnan'),125,'MarkerEdgeColor','k','MarkerFaceColor',[0.1 0.1 0.7] ,'LineWidth',1);

% add text
ax=gca;
leg=D(p_all);
dx=mean(diff(ax.XTick))/20; dy=mean(diff(ax.YTick))/10;
text(mean(I_anes2(p_all,win),2,'omitnan')+dx, mean(I_awake2(p_all,win),2,'omitnan')-dy, leg, 'Fontsize',16);

% graph settings
ylim([-0.01 0.03]); xlim([-0.01 0.03]);
xline(0, 'LineWidth', 1, 'Color', 'k', 'LineStyle','--');
yline(0, 'LineWidth', 1, 'Color', 'k', 'LineStyle','--');
line(ylim(), ylim(), 'LineWidth', 1, 'Color', 'k', 'LineStyle','--');
set(gca,'TickDir','out');
xlabel('\Delta I/I - anaesthetized','Fontsize',32);
ylabel('\Delta I/I - awake','Fontsize',32);
ax.FontSize=26;
f.Position=[100 100 900 700];

%% Figure 3b
close all

% get region index
reg=find(matches(D,["SC"]),1); % or "VISp"

% smooth data a bit and plot
smooth=5;
I_smooth=squeeze(movmean(I_awake(reg,:,:),smooth,2));
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

% get correlation coefficient for text
sig2=zeros(tblock,nstimuli);
sig2(T1_conv:T2_conv,:)=1;
t=movmean(I_awake2(reg,:),smooth,2);
corrcoef(sig2(:),t)
