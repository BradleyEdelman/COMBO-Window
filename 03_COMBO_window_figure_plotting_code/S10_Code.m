clear all

% this script contains code to reproduce Figure S9a-c

%% load data

% drag and drop corresponding file (S10 Data)

%% data content description

% variables contain average T scores from GLMs (.Tmoy) and uncorrected p values
% (.mask)
% I_awake_ChR2 is from awake animals expressing ChR2 in M2
% I_awake_YFP is from awake animals expressing YFP in M2
% I_anes_YFP is from anesthetized animals expressin YFP in M2

%% Figure S9a
% only take voxels of presented coronal sections
slices=[38:1:47];
Tmoy2=I_awake_ChR2.Tmoy(:,:,slices);

% correct p values
thres=0.05;
I_Nan=isnan(Tmoy2);
mask2=I_awake_ChR2.mask(:,:,slices);
[n1,n2,n3]=size(mask2);
mask_lin=reshape(mask2, [n1*n2*n3 1]);
[h, crit_p, adj_ci_cvrg, FDR]=fdr_bh(mask_lin(~I_Nan(:)),0.05,'pdep','no');
mask3=nan(size(mask_lin));
mask3(~I_Nan(:))=FDR;
mask4=reshape(mask3, [n1,n2,n3]);
mask5=mask4<thres;

% plot histogram of voxels
edges=linspace(min(Tmoy2,[],'all'),max(Tmoy2,[],'all'),40);
f=figure; histogram(Tmoy2(mask5),edges,'FaceColor','r'); hold on;
histogram(Tmoy2(~mask5),edges,'FaceColor','k')
box off;
xlim([-12 12]);
ylim([0 1200])
xlabel('T score');
ylabel('number of voxels');
f.Position=[100 100 500 400]

%% Figure S9b
% only take voxels of presented coronal sections
slices=[38:1:47];
Tmoy2=I_awake_YFP.Tmoy(:,:,slices);

% correct p values
thres=0.05;
I_Nan=isnan(Tmoy2);
mask2=I_awake_YFP.mask(:,:,slices);
[n1,n2,n3]=size(mask2);
mask_lin=reshape(mask2, [n1*n2*n3 1]);
[h, crit_p, adj_ci_cvrg, FDR]=fdr_bh(mask_lin(~I_Nan(:)),0.05,'pdep','no');
mask3=nan(size(mask_lin));
mask3(~I_Nan(:))=FDR;
mask4=reshape(mask3, [n1,n2,n3]);
mask5=mask4<thres;

% plot histogram of voxels
edges=linspace(min(Tmoy2,[],'all'),max(Tmoy2,[],'all'),40);
f=figure; histogram(Tmoy2(mask5),edges,'FaceColor','r'); hold on;
histogram(Tmoy2(~mask5),edges,'FaceColor','k')
box off;
xlim([-12 12]);
ylim([0 1200])
xlabel('T score');
ylabel('number of voxels');
f.Position=[100 100 500 400]

%% Figure S9c
% only take voxels of presented coronal sections
slices=[38:1:47];
Tmoy2=I_anes_YFP.Tmoy(:,:,slices);

% correct p values
thres=0.05;
I_Nan=isnan(Tmoy2);
mask2=I_anes_YFP.mask(:,:,slices);
[n1,n2,n3]=size(mask2);
mask_lin=reshape(mask2, [n1*n2*n3 1]);
[h, crit_p, adj_ci_cvrg, FDR]=fdr_bh(mask_lin(~I_Nan(:)),0.05,'pdep','no');
mask3=nan(size(mask_lin));
mask3(~I_Nan(:))=FDR;
mask4=reshape(mask3, [n1,n2,n3]);
mask5=mask4<thres;

% plot histogram of voxels
edges=linspace(min(Tmoy2,[],'all'),max(Tmoy2,[],'all'),40);
f=figure; histogram(Tmoy2(mask5),edges,'FaceColor','r'); hold on;
histogram(Tmoy2(~mask5),edges,'FaceColor','k')
box off;
xlim([-12 12]);
ylim([0 1200])
xlabel('T score');
ylabel('number of voxels');
f.Position=[100 100 500 400]