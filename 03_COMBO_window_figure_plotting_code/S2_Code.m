clear all

% this script contains code to reproduce Figure 2c-f, i-j

%% load data

% drag and drop corresponding file (S2 Data)

%% data content description

% open field contains the various behavioral measures from the open field
% foraging task and the corresponding animal id

% fe contains the normalized emotion prototype similarity scores for disgust and
% pleasure during a neutral state and the administration of quinine and
% sucrose. This field contains both the timeseries around stimulus onset as
% well as a trial values

%% Figure 2c: cumulative distance

distance_cumulative = Figure_2.open_field.distance_cumulative;

f = figure(1); clf; set(gcf,'color','w')
fSize=[100 100 300 500]; fontSzY=12; fontSzAx=9;

options.handle=f;
options.color_area = [0 0 .5];
options.color_line = [0 0 1];
options.alpha = 0.5;
options.line_width = 2;
options.error = 'std';
smooth = 50;
plot_areaerrorbar(movmean(distance_cumulative(:,8:13),smooth,1)',options);hold on;

options.handle = f;
options.color_area = [.75 .75 .75]; 
options.color_line = [0 0 0];
options.alpha = 0.5;
options.line_width = 2;
options.error = 'std';
plot_areaerrorbar(movmean(distance_cumulative(:,1:7),smooth,1)',options); 

set(gca,'FontSize',fontSzAx,'box','off','tickdir','out');
ylabel('distance (m)','FontSize',fontSzY)
xlabel('time (min)');
xticks([0:400:size(distance_cumulative,1)]);
xticklabels([0:1:10]);

fSize2=fSize;
fSize2(3)=fSize(3)*2;
f.Position=fSize2;
title('Figure 2c: Cumulative Distance')

%% Figure 2d: total distance

distance_total = Figure_2.open_field.distance_total;
animal_id = Figure_2.open_field.animal_id;

f = figure(2); clf; set(gcf,'color','white')
fSize=[100 100 300 500]; fontSzY=12; fontSzAx=9;

h = boxplot(distance_total,animal_id,...
    'PlotStyle','traditional','Colors',[0 0 0; 0 0 1],'Widths',0.5,'Symbol','','Whisker',3);
set(h,'linewidth',2,'markersize',10,'linestyle','-')
set(gca,'FontSize',fontSzAx,'tickdir','out','box','off','ylim',[0 60]);
ylabel('total distance (m)','FontSize',fontSzY);
f.Position = fSize;
title('Figure 2d: Total Distance')

%% Figure 2e: median speed

speed_median = Figure_2.open_field.speed_median;
animal_id = Figure_2.open_field.animal_id;

f = figure(3); clf; set(gcf,'color','white')
fSize=[100 100 300 500]; fontSzY=12; fontSzAx=9;

h = boxplot(speed_median,animal_id,...
    'PlotStyle','traditional','Colors',[0 0 0; 0 0 1],'Widths',0.5,'Symbol','','Whisker',3 );
set(h,'linewidth',2,'markersize',10,'linestyle','-')
set(gca,'FontSize',fontSzAx,'box','off','tickdir','out','ylim',[0 50]);
ylabel('speed (mm/s)','FontSize',fontSzY);
f.Position = fSize;
title('Figure 2e: Median Speed')

%% Figure 2f: tortuosity

speed_all = Figure_2.open_field.speed_all;
tortuosity = Figure_2.open_field.tortuosity;
animal_id = Figure_2.open_field.animal_id;

thresh = mean(prctile(speed_all(:,8:13),75)); % average of 75th percentile of control speed
ind = speed_all > thresh;

tortuosity_tmp = nan(size(speed_all));
tortuosity_tmp(9:end-8,:) = tortuosity;
tortuosity_tmp(~ind) = NaN; % only take the ones where the speed was above threshold
tortuosity_median = median(tortuosity_tmp,'omitnan');

f = figure(4); clf; set(gcf,'color','white')
h = boxplot(tortuosity_median,animal_id, 'PlotStyle','traditional','Colors',[0 0 0; 0 0 1],'Widths',0.5,'Symbol','','Whisker',3 );
set(h,'linewidth',2,'markersize',10,'linestyle','-')
set(gca,'FontSize',fontSzAx,'box','off','tickdir','out','ylim',[1 1.5]);
ylabel('tortuosity','FontSize',fontSzY); box off;
f.Position = fSize;
title('Figure 2f: Tortuosity')

%% Figure 2i: Emotion prototype similarity timeseries

emotion_norm_timeseries = Figure_2.fe.emotion_norm_timeseries;

% label stimuli and emotion states
emotion_name = {'disgust', 'pleasure'};
stim_name = {'neutral', 'quinine', 'sucrose'};
emotion_color = [158 159 162; 144 36 94; 60 152 78];

% display settings
YLIM = [-0.025 0.5];
lbase = 80; % 4 sec
lstim = 40; % 2 sec
fs = 20; % frame rate

figure(5); clf; set(gcf,'color','w','position',[150 200 875 425])

for i_proto = 1:size(emotion_norm_timeseries,1)
    for i_stim = 1:size(emotion_norm_timeseries,2)
        
        subplot(size(emotion_norm_timeseries,1), size(emotion_norm_timeseries,2), i_stim + (i_proto-1)*size(emotion_norm_timeseries,2))
        hold on
        
        % extract all trials from all mice
        current_trials = squeeze(emotion_norm_timeseries(i_proto,i_stim,:));
        current_trials = cat(2, current_trials{:});

        % plot stimulus timing
        plot([lbase lbase+lstim; lbase lbase+lstim],YLIM,'--','color',emotion_color(i_stim,:)/255,'linewidth',1.5)
        
        % plot average emotion response
        M = movmean(nanmean(current_trials,2),10)';
        S = movmean(nanstd(current_trials,[],2)./sqrt(size(current_trials,2)),10)';
        t1 = 1:size(M,2); t2 = [t1, fliplr(t1)];
        between = [M + S, fliplr(M - S)];
        fill(t2,between,emotion_color(i_proto + 1,:)/255,'edgecolor','none','facealpha',0.5); hold on
        plot(t1, M, 'color', emotion_color(i_proto + 1,:)/255,'linewidth',2);
        set(gca,'ylim',YLIM,'xlim',[40 200],'xticklabel','','tickdir','out')

        % labeling
        if i_stim ~= 1; set(gca,'xtick','','ytick','');else; ylabel([emotion_name{i_proto} ' similarity']); end
        if i_proto == size(emotion_norm_timeseries,1); set(gca,'xtick',[lbase lbase+lstim],...
            'xticklabel',round(([lbase lbase+lstim]-lbase)/fs)); xlabel('time (sec)'); end
        if i_proto == 1; title(stim_name{i_stim}); end
        
    end
end

%% Figure 2j: Emotion prototype similarity trial

emotion_norm_trial = Figure_2.fe.emotion_norm_trial;

figure(6); clf; set(gcf,'color','w','position',[400 175 400 425])

for i_proto = 1:size(emotion_norm_trial,1)
    subplot(size(emotion_norm_trial,1),1,i_proto); hold on
    
    % create box plot data for each emotion, across stimuli
    val_box = []; label_box = [];
    for i_stim = 1:size(emotion_norm_trial,2)
        
        val_box = [val_box cat(2,emotion_norm_trial{i_proto,i_stim,:})];
        label_box = [label_box i_stim*ones(1,size(cat(2,emotion_norm_trial{i_proto,i_stim,:}),2))];
    end

    % plot data
    h = boxplot(val_box,label_box,'symbol','.','colors',repmat(emotion_color(i_proto+1,:)/255,i_stim,1));
    set(h,'linewidth',2,'markersize',10,'linestyle','-')

    % labeling
    set(gca,'ylim',[-.1 1.1],'xtick','','tickdir','out','box','off')
    ylabel([emotion_name{i_proto} ' similarity'])
end

set(gca,'xtick',1:size(emotion_norm_trial,2),'xticklabel',stim_name)
xtickangle(45)




    
