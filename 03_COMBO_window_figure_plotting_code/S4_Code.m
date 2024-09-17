clear all

% this script contains code to reproduce Figure 4b-c, e-f

%% load data

% drag and drop corresponding file (S4 Data)

%% data content description

% Displace_ex contains the x and y displacement values for an example
% recording session alongside the corresponding running trace

% M2_drift and RSC_drift contain the residual drift values after rigid
% registration of the two-photon recordings sessions

% M2_ex and RSC_ex contain example variables corresponding to a recording
% session in each recording site. These fields contain a running trace as
% well as the fluorescence traces from all recorded cells.

% M2_corr/RSC_corr contain the correlation coefficients between the
% cellular fluorescence traces and running for each recording.
% M2_corr_p/RSC_corr_p contain the FDR-corrected p-values of these
% correlations


%% Figure 4b

Displace_ex = Figure_4.Displace_ex;

figure(1); clf; hold on; set(gcf,'color','w')
time = (1:5400)/60; time = time(1:2:end); time = time(1:size(Displace_ex.running,1));
plot(time, rescale(Displace_ex.running), 'linewidth', 1.5, 'color', 'k');
plot(time, rescale(Displace_ex.xdisp,'inputmin',-25,'inputmax',25) - 1.5, 'linewidth', 1.5, 'color', 'b');
plot(time, rescale(Displace_ex.ydisp,'inputmin',-25,'inputmax',25) - 2.5, 'linewidth', 1.5, 'color', 'r');
xlabel('time (sec)')
set(gca,'ytick',[-2 -1 0],'yticklabel',{'y-disp', 'x-disp', 'running'})
title('Figure 4b: Displacement')


%% Figure 4c

M2_drift = Figure_4.M2_drift;
RSC_drift = Figure_4.RSC_drift;

figure(2); clf; set(gcf,'color','w')

box_val = [M2_drift RSC_drift];
lab_val = [ones(1,size(M2_drift,1)) 2*ones(1,size(RSC_drift,1))];
bp = boxplot(box_val, lab_val);
set(bp,'LineWidth', 1.5);
h = findobj(gca,'Tag','Box');
CC = [.75 .75 .75; 0 0 0];
for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),CC(j,:),'FaceAlpha',.5);
end
set(gca,'xticklabel',{'M2', 'RSC'},'tickdir','out', 'ylim', [0 1]); box off
h=findobj('LineStyle','--'); set(h, 'LineStyle','-','color','k');
lines = findobj(gcf, 'type', 'line');
set(lines, 'Color', 'k');
lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
set(lines, 'Color', 'k');
title('Figure 4c: Residual Drift')
ylabel('Residual Drift (um)')


%% Figure 4e
close all
ROIs = {'M2_ex', 'RSC_ex'};
for i_roi = 1:size(ROIs,2)
    
    figure(i_roi); clf; set(gcf,'color','w'); hold on; 
    
    % smooth all behavioral/neuronal variables slightly
    smoothing_factor = 15;
    running = movmean(Figure_4.(ROIs{i_roi}).running, smoothing_factor, 1);
    cell_F = movmean(Figure_4.(ROIs{i_roi}).cell_F, smoothing_factor, 2);
    
    % plot running
    time = Figure_4.(ROIs{i_roi}).time;
    plot(time, rescale(running), 'linewidth', 1.5, 'color', 'k');
    
    % decompose cell popualtion activity
    [U,S,V] = svd(cell_F,'econ');

    % sign of eigenvector is arbitrary
    corrPC_tmp = corrcoef(V(:,1), running);
    if corrPC_tmp(1,2) < 0; V(:,1) = -V(:,1); end
    corrPC_tmp = corrcoef(V(:,1), running);
    
    % plot first PC
    plot(time, (rescale(V(:,1))) - 2, 'k', 'linewidth', 1.5)
    
    % correlate each cell trace with running
    clear skew corr_tmp run_corr run_corr_p
    for i_cell = 1:size(cell_F,1)
        [corr_tmp p_tmp] = corrcoef(running, cell_F(i_cell,:));
        run_corr(i_cell) = corr_tmp(1,2);
        run_corr_p(i_cell) = p_tmp(1,2);
        skew(i_cell) = skewness(cell_F(i_cell,:));
    end

    [B,I] = sort(run_corr,'descend');
    % remove low skew cells
    skew = skew(I);
    bad_skew = find(skew < 2);
    I(bad_skew) = []; B(bad_skew) = [];
    
    % top correlated
    for i_cell = 1:10
        F_tmp = rescale(cell_F(I(i_cell),:))*.5;
        F_tmp = F_tmp - 2.5;
        plot(time,F_tmp - .5*(i_cell),'color',[57 181 74]/255,'linewidth',1.5)
    end
    
    % bottom correlated
    I = fliplr(I); B = fliplr(B);
    for i_cell = 1:10
        F_tmp = rescale(cell_F(I(i_cell),:))*.5;
        F_tmp = F_tmp - 8.5;
        plot(time,F_tmp - .5*(i_cell),'color',[28 117 188]/255,'linewidth',1.5)
    end
    
    xlabel('time (sec)')
    set(gca,'tickdir','out','ytick','')
    title(['Figure 4e: ' ROIs{i_roi}])
end

%% Figure 4f

% extract FDR-corrected p values
M2_corr_p = Figure_4.M2_corr_p;
M2_corr = Figure_4.M2_corr;
RSC_corr_p = Figure_4.RSC_corr_p;
RSC_corr = Figure_4.RSC_corr;

% p value threshold
p_thresh = 1e-3;

% determine significance and direction
M2_pos = size(find(M2_corr > 0 & M2_corr_p < p_thresh),2);
M2_neg = size(find(M2_corr < 0 & M2_corr_p < p_thresh),2);
M2_none = size(M2_corr,2) - M2_pos - M2_neg;
RSC_pos = size(find(RSC_corr > 0 & RSC_corr_p < p_thresh),2);
RSC_neg = size(find(RSC_corr < 0 & RSC_corr_p < p_thresh),2);
RSC_none = size(RSC_corr,2) - RSC_pos - RSC_neg;


ff = figure(5); clf; set(gcf,'color','w')
subplot(1,2,1);
pie([M2_pos M2_neg M2_none])
legend('pos','neg','none','location','best')
title('M2')

subplot(1,2,2);
pie([RSC_pos RSC_neg RSC_none])
legend('pos','neg','none','location','best')
title('RSC')