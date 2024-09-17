clear all

% this script contains code to reproduce Figure 1f

%% load data

% drag and drop corresponding file (S1 Data)

%% data content description

% IHC contains GFAP fluorescence values across various cortical ROIs
% column 1: animal id
% column 2: ROI location (slide)
% column 3: GFAP fluroescence

%% Figure 1f

IHC_data = Figure_1.IHC;

% find COMBO and Ctrl indices
COMBO_idx = cellfun(@(v) strfind(v,'EMA'), cat(1,IHC_data{:,1}), 'uniformoutput', false);
COMBO_idx = find(cellfun(@(v) isequal(v,1), COMBO_idx));

Ctrl_idx = cellfun(@(v) strfind(v,'NGO'), cat(1,IHC_data{:,1}), 'uniformoutput', false);
Ctrl_idx = find(cellfun(@(v) isequal(v,1), Ctrl_idx));

% Extract GFAP signal
IHC_data = cell2mat(IHC_data(:,3));
F_COMBO = IHC_data(COMBO_idx);
F_Ctrl = IHC_data(Ctrl_idx);
        
figure(1); clf; set(gcf,'color','w','position',[100 100 300 500]);
h = boxplot([F_Ctrl; F_COMBO], [ones(size(F_Ctrl,1),1); 2*ones(size(F_COMBO,1),1)],...
    'plotstyle','traditional','Colors',[0 0 0; 0 0 1],'widths',0.5,'symbol','','whisker',3);
set(h,'linewidth',2,'markersize',10,'linestyle','-')
set(gca,'fontsize',12,'box','off','tickdir','out','ylim',[0 50],'xticklabel',{'Ctrl', 'COMBO'})
ylabel('GFAP fluorescence (a.u.)','fontsize',9)

title('Figure 1f: GFAP')