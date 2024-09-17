clear all

% this script contains code to reproduce Figure S6a-c

%% load data

% drag and drop corresponding file (S7 Data)

%% data content description

% various behavioral measures from the open field foraging task and the 
% corresponding animal id and sex. This data is the same as from S2 Data
% but plotted as a statification of sex.

%% Figure S6a: total distance

distance_total = Figure_S6.distance_total;
animal_id = Figure_S6.animal_id;

f = figure(1);
fSize = [400 100 500 500]; fontSzY = 12; fontSzAx = 9;

h = boxplot(distance_total,animal_id,...
    'PlotStyle','traditional','Colors',[0 0 0;0 0 0;0 0 1;0 0 1],'Widths',0.5,'Symbol','','Whisker',3);
set(h,'linewidth',2,'markersize',10,'linestyle','-')
set(gca,'FontSize',fontSzAx,'tickdir','out','box','off','ylim',[0 60]);
ylabel('distance (m)','FontSize',fontSzY);
set(gcf,'color','white')
f.Position = fSize;
title('Figure S6a: Total Distance (sex)')

%% Figure S6b: median speed

speed_median = Figure_S6.speed_median;
animal_id = Figure_S6.animal_id;

f = figure(3);
fSize = [400 100 500 500]; fontSzY = 12; fontSzAx = 9;

h = boxplot(speed_median, animal_id,...
    'PlotStyle','traditional','Colors',[0 0 0; 0 0 0; 0 0 1; 0 0 1],'Widths',0.5,'Symbol','','Whisker',3);
set(h,'linewidth',2,'markersize',10,'linestyle','-')
set(gca,'FontSize',fontSzAx,'tickdir','out','box','off','ylim',[0 50]);
ylabel('speed (mm/s)','FontSize',fontSzY);
set(gcf,'color','white')
f.Position = fSize;
title('Figure S6b: Median Speed (sex)')

%% Figure S6c: tortuosity

speed_median = Figure_S6.speed_median;
speed_all = Figure_S6.speed_all;
tortuosity = Figure_S6.tortuosity;
animal_id = Figure_S6.animal_id;

thresh = mean(prctile(speed_all(:,8:13),75)); % average of 75th percentile of control speed
ind = speed_all > thresh;

tortuosity_tmp = nan(size(speed_all));
tortuosity_tmp(9:end-8,:) = tortuosity;
tortuosity_tmp(~ind) = NaN; % only take the ones where the speed was above threshold
totuosity_median = median(tortuosity_tmp,'omitnan');

f=figure(3);
fSize = [400 100 500 500]; fontSzY = 12; fontSzAx = 9;

h=boxplot(totuosity_median,animal_id,...
    'PlotStyle','traditional','Colors',[0 0 0; 0 0 0; 0 0 1; 0 0 1],'Widths',0.5,'Symbol','','Whisker',3); ylim([1 1.5]);
set(h,'linewidth',2,'markersize',10,'linestyle','-')
set(gca,'FontSize',fontSzAx,'tickdir','out','box','off');
ylabel('tortuosity','FontSize',fontSzY);
set(gcf,'color','white')
f.Position = fSize;
title('Figure S6c: Tortuosity (sex)')