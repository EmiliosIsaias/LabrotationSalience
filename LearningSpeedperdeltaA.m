clearvars

startPath = 'Z:\Filippo\Animals';
try
    load(fullfile(startPath,'animalData.mat'))
catch
    fprintf(2,'\nThe variable "animalData.mat" doesn''t exist.')
    fprintf(2,'\nYou have to create it first.\n\n')
    return
end

% load Cohort Data
cohort_Data11 = animalData.cohort(11).animal;
cohort_Data15 = animalData.cohort(15).animal;
cohort_Data16 = animalData.cohort(16).animal;


%% Cohort11
% get dprime values for only Stage2
first_stage2 = nan(numel(cohort_Data11),1);
last_stage2 = nan(numel(cohort_Data11),1);
start_trial = zeros(numel(cohort_Data11),1);
end_trial = nan(numel(cohort_Data11),1);
for i = 1:numel(cohort_Data11)
    first_stage2(i) = find(contains(cohort_Data11(i).session_names,'P3.2'),1);
    last_stage2(i) = find(contains(cohort_Data11(i).session_names,'P3.2'),1,'last');
    cohort_Data11(i).Lick_Events_stage2 = cohort_Data11(i).Lick_Events(first_stage2(i):last_stage2(i));
    end_trial(i) = numel(vertcat(cohort_Data11(i).Lick_Events_stage2{1:last_stage2(i)-first_stage2(i)+1}));
    cohort_Data11(i).dvalues_sta2 = cohort_Data11(i).dvalues_trials(start_trial(i)+1:end_trial(i));
end

% adjust array size
longest = max(cellfun('size',{cohort_Data11.dvalues_sta2},1));
for i = 1:numel(cohort_Data11)
    cohort_Data11(i).dvalues_sta2 = [cohort_Data11(i).dvalues_sta2;...
        nan(longest-numel(cohort_Data11(i).dvalues_sta2),1)];
end

% mean dprime over trial
dprimetrials_mean11 = mean((horzcat(cohort_Data11.dvalues_sta2)),2,'omitnan');

% get Learning Speed
y2 = dprimetrials_mean11(~isnan(dprimetrials_mean11));
yval = y2(200:end);
offset = min(yval);
xval = 1:1:numel(yval);
xval = xval+200;
[params]=sigm_fit(xval', yval',[],[],0);
Qpre_fit = params(1) + (params(2) - params(1))./ (1 + 10.^((params(3) - xval) * params(4)));
Qpre_fit = Qpre_fit + offset;
Speed11_20 = find(Qpre_fit>1.65,1)+200;


%% Cohort 15
% get dprime values for only Stage2
first_stage2 = nan(numel(cohort_Data15),1);
last_stage2 = nan(numel(cohort_Data15),1);
start_trial = zeros(numel(cohort_Data15),1);
end_trial = nan(numel(cohort_Data15),1);
for i = 1:numel(cohort_Data15)
    first_stage2(i) = find(contains(cohort_Data15(i).session_names,'P3.2'),1);
    last_stage2(i) = find(contains(cohort_Data15(i).session_names,'P3.2'),1,'last');
    cohort_Data15(i).Lick_Events_stage2 = cohort_Data15(i).Lick_Events(first_stage2(i):last_stage2(i));
    end_trial(i) = numel(vertcat(cohort_Data15(i).Lick_Events_stage2{1:last_stage2(i)-first_stage2(i)+1}));
    cohort_Data15(i).dvalues_sta2 = cohort_Data15(i).dvalues_trials(start_trial(i)+1:end_trial(i));
end

% adjust array size
longest = max(cellfun('size',{cohort_Data15.dvalues_sta2},1));
for i = 1:numel(cohort_Data15)
    cohort_Data15(i).dvalues_sta2 = [cohort_Data15(i).dvalues_sta2;...
        nan(longest-numel(cohort_Data15(i).dvalues_sta2),1)];
end

% mean dprime over trial
dprimetrials_mean15 = mean((horzcat(cohort_Data15.dvalues_sta2)),2,'omitnan');

% get Learning Speed
y2 = dprimetrials_mean15(~isnan(dprimetrials_mean15));
yval = y2(200:end);
offset = min(yval);
xval = 1:1:numel(yval);
xval = xval+200;
[params]=sigm_fit(xval', yval',[],[],0);
Qpre_fit = params(1) + (params(2) - params(1))./ (1 + 10.^((params(3) - xval) * params(4)));
Qpre_fit = Qpre_fit + offset;
Speed15_12 = find(Qpre_fit>1.65,1)+200;


%% Cohort 16
% get dprime values for only Stage2
first_stage2 = nan(numel(cohort_Data16),1);
last_stage2 = nan(numel(cohort_Data16),1);
start_trial = zeros(numel(cohort_Data16),1);
end_trial = nan(numel(cohort_Data16),1);
for i = 1:numel(cohort_Data16)
    first_stage2(i) = find(contains(cohort_Data16(i).session_names,'P3.2'),1);
    last_stage2(i) = find(contains(cohort_Data16(i).session_names,'P3.2'),1,'last');
    cohort_Data16(i).Lick_Events_stage2 = cohort_Data16(i).Lick_Events(first_stage2(i):last_stage2(i));
    end_trial(i) = numel(vertcat(cohort_Data16(i).Lick_Events_stage2{1:last_stage2(i)-first_stage2(i)+1}));
    cohort_Data16(i).dvalues_sta2 = cohort_Data16(i).dvalues_trials(start_trial(i)+1:end_trial(i));
end

% adjust array size
longest = max(cellfun('size',{cohort_Data16.dvalues_sta2},1));
for i = 1:numel(cohort_Data16)
    cohort_Data16(i).dvalues_sta2 = [cohort_Data16(i).dvalues_sta2;...
        nan(longest-numel(cohort_Data16(i).dvalues_sta2),1)];
end

% mean dprime over trial (deltaA = 14)
C = nan(numel(cohort_Data16(1).dvalues_sta2),3);
for i = 1:3
    C_temp = mean((horzcat(cohort_Data16(i).dvalues_sta2)),2,'omitnan');
    C(:,i) = C_temp;
end
dprimetrials_mean16_14 = mean(C,2,'omitnan');

% get Learning Speed (deltaA = 14)
y2 = dprimetrials_mean16_14(~isnan(dprimetrials_mean16_14));
yval = y2(200:end);
offset = min(yval);
xval = 1:1:numel(yval);
xval = xval+200;
[params]=sigm_fit(xval', yval',[],[],0);
Qpre_fit = params(1) + (params(2) - params(1))./ (1 + 10.^((params(3) - xval) * params(4)));
Qpre_fit = Qpre_fit + offset;
Speed16_14 = find(Qpre_fit>1.65,1)+200;

% mean dprime over trial (deltaA = 16)
C = nan(numel(cohort_Data16(1).dvalues_sta2),3);
for i = 4:6
    C_temp = mean((horzcat(cohort_Data16(i).dvalues_sta2)),2,'omitnan');
    C(:,i) = C_temp;
end
dprimetrials_mean16_16 = mean(C,2,'omitnan');

% get Learning Speed (deltaA = 16)
y2 = dprimetrials_mean16_16(~isnan(dprimetrials_mean16_16));
yval = y2(200:end);
offset = min(yval);
xval = 1:1:numel(yval);
xval = xval+200;
[params]=sigm_fit(xval', yval',[],[],0);
Qpre_fit = params(1) + (params(2) - params(1))./ (1 + 10.^((params(3) - xval) * params(4)));
Qpre_fit = Qpre_fit + offset;
Speed16_16 = find(Qpre_fit>1.65,1)+200;


%% Plot Data
deltaA = [12,14,16,20];
Speed = [Speed15_12, Speed16_14, Speed16_16, Speed11_20];

figure; plot(deltaA,Speed,'o')
xlabel('deltaA [mm]')
ylabel('Learning Speed [Trials]')
title('Learning Speed per deltaA')