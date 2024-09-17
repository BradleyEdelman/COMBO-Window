clear all

% this script contains code to reproduce Figure S5a-c

%% load data

% drag and drop corresponding file (S6 Data)

%% data content description

% weight contains the raw weight of animals (grams) over 10 days after
% surgery

% animal id contains the animal identifier of either COMBO or Ctrl

% day contains the day after surgery

%% Figure S5a: COMBO animial weight

weight = Figure_S5.weight;
animal_id = Figure_S5.animal_id;
day = Figure_S5.day;

figure(1); clf; set(gcf,'color','w','position',[400 350 500 250]);

% raw weight
COMBO_weight = weight(strcmp(animal_id,'COMBO'),:);
% percent baseline change
COMBO_weight = COMBO_weight./repmat(COMBO_weight(:,1),1,size(COMBO_weight,2))*100;
plot(day,COMBO_weight')
set(gca,'ylim',[80 120],'xlim',[-1 11],'tickdir','out'); box off
ylabel('Weight (% pre-implantation)');
xlabel('Days post-surgery');
title('Figure S6a: COMBO')

%% Figure S5b: Control animal weight

weight = Figure_S5.weight;
animal_id = Figure_S5.animal_id;
day = Figure_S5.day;

figure(2); clf; set(gcf,'color','w','position',[400 350 500 250]);

% raw weight
CTRL_weight = weight(strcmp(animal_id,'CTRL'),:);
% percent baseline change
CTRL_weight = CTRL_weight./repmat(CTRL_weight(:,1),1,size(CTRL_weight,2))*100;
plot(day, CTRL_weight')
set(gca,'ylim',[80 120],'xlim',[-1 11],'tickdir','out'); box off
ylabel('Weight (% pre-implantation)');
xlabel('Days post-surgery');
title('Figure S6b: Control')

%% Figure S5c: Group-average

weight = Figure_S5.weight;
animal_id = Figure_S5.animal_id;
day = Figure_S5.day;

figure(3); clf; hold on; set(gcf,'color','w','position',[400 350 500 250]);

COMBO_weight = weight(strcmp(animal_id,'COMBO'),:);
COMBO_weight = COMBO_weight./repmat(COMBO_weight(:,1),1,size(COMBO_weight,2))*100;
COMBO_ave = mean(COMBO_weight,1);
COMBO_sem = std(COMBO_weight,[],1)./sqrt(size(COMBO_weight,1));
errorbar(day, COMBO_ave, COMBO_sem,'color',[0 0 1],'linewidth',1.5)

CTRL_weight = weight(strcmp(animal_id,'CTRL'),:);
CTRL_weight = CTRL_weight./repmat(CTRL_weight(:,1),1,size(CTRL_weight,2))*100;
CTRL_ave = mean(CTRL_weight,1);
CTRL_sem = std(CTRL_weight,[],1)./sqrt(size(CTRL_weight,1));
errorbar(Figure_S5.day, CTRL_ave, CTRL_sem,'color',[0 0 0],'linewidth',1.5)

set(gca,'ylim',[80 120],'xlim',[-1 11],'tickdir','out'); box off
ylabel('Weight (% pre-implantation)');
xlabel('Days post-surgery');
title('Figure S6c: Control vs COMBO')