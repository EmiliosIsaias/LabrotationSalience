function [dprime_LP1, dprime_LP2] = dprimeLickport(Lick_Events, Sessions, animalName)
% creating a new cell array with only Lick events at LP1
Lick_EventsLP1 = cell(1,numel(Lick_Events));
for i = 1:numel(Lick_Events)
    Lick_EventsLP1{i} = Lick_Events{1,(i)}(contains(Lick_Events{1,(i)},"LP1"));
end

% calculating go and no-go succes rate (LP1)
go_suc1 = zeros(1,length(Lick_EventsLP1));
go_fail1 = zeros(1,length(Lick_EventsLP1));
nogo_suc1 = zeros(1,length(Lick_EventsLP1));
nogo_fail1 = zeros(1,length(Lick_EventsLP1));
go_suc_rate1 = zeros(1,length(Lick_EventsLP1));
nogo_suc_rate1 = zeros(1,length(Lick_EventsLP1));
for i = 1:length(Lick_EventsLP1)
    go_suc1(i) = sum(strncmpi(Lick_EventsLP1{i},"Go Success",8));
    go_fail1(i) = sum(strncmpi(Lick_EventsLP1{i},"Go Failure",8));
    nogo_suc1(i) = sum(strncmpi(Lick_EventsLP1{i},"No-Go Success",8));
    nogo_fail1(i) = sum(strncmpi(Lick_EventsLP1{i},"No-Go Failure",8));
    
    go_suc_rate1(i) = go_suc1(i)/(go_suc1(i)+go_fail1(i));
    nogo_suc_rate1(i) = nogo_suc1(i)/(nogo_suc1(i)+nogo_fail1(i));
end
   
% calculating dprime (LP1)
dprime_LP1 = zeros(1,numel(Lick_Events));
cval1 = zeros(1,numel(Lick_Events));
for i = 1:numel(Lick_Events)
    [dprime_LP1(i), cval1(i)] = dprime(go_suc_rate1(i), 1-nogo_suc_rate1(i),...
        go_suc1(i)+go_fail1(i), nogo_suc1(i)+nogo_fail1(i));
end



% creating a new cell array with only Lick events at LP2
Lick_EventsLP2 = cell(1,numel(Lick_Events));
for i = 1:numel(Lick_Events)
    Lick_EventsLP2{i} = Lick_Events{1,(i)}(contains(Lick_Events{1,(i)},"LP2"));
end

% calculating go and no-go succes rate (LP2)
go_suc2 = zeros(1,length(Lick_EventsLP2));
go_fail2 = zeros(1,length(Lick_EventsLP2));
nogo_suc2 = zeros(1,length(Lick_EventsLP2));
nogo_fail2 = zeros(1,length(Lick_EventsLP2));
go_suc_rate2 = zeros(1,length(Lick_EventsLP2));
nogo_suc_rate2 = zeros(1,length(Lick_EventsLP2));
for i = 1:length(Lick_EventsLP2)
    go_suc2(i) = sum(strncmpi(Lick_EventsLP2{i},"Go Success",8));
    go_fail2(i) = sum(strncmpi(Lick_EventsLP2{i},"Go Failure",8));
    nogo_suc2(i) = sum(strncmpi(Lick_EventsLP2{i},"No-Go Success",8));
    nogo_fail2(i) = sum(strncmpi(Lick_EventsLP2{i},"No-Go Failure",8));
    
    go_suc_rate2(i) = go_suc2(i)/(go_suc2(i)+go_fail2(i));
    nogo_suc_rate2(i) = nogo_suc2(i)/(nogo_suc2(i)+nogo_fail2(i));
end

% calculating dprime (LP2)
dprime_LP2 = zeros(1,numel(Lick_Events));
cval2 = zeros(1,numel(Lick_Events));
for i = 1:numel(Lick_Events)
    [dprime_LP2(i), cval2(i)] = dprime(go_suc_rate2(i), 1-nogo_suc_rate2(i),...
        go_suc2(i)+go_fail2(i), nogo_suc2(i)+nogo_fail2(i));
end



% plotting d' values
f = figure;
f.Name = "dprimeLP";

plot(dprime_LP1(stageCount(Sessions) ~= 1), "ko:")
hold on
plot(dprime_LP2(stageCount(Sessions) ~= 1), "bo:")
zero_line = zeros(1,sum(stageCount(Sessions) ~= 1));
plot(zero_line,'Color','#666666')
dprime_line = 1.65*ones(1,sum(stageCount(Sessions) ~= 1));
plot(dprime_line,'--','Color','#666666')

colorplots(min(ylim),max(ylim),Sessions(stageCount(Sessions) ~= 1))

plot(dprime_LP1(stageCount(Sessions) ~= 1), "ko:")
plot(dprime_LP2(stageCount(Sessions) ~= 1), "bo:")
plot(zero_line,'Color','#666666')
plot(dprime_line,'--','Color','#666666')

axis tight
xlabel("Sessions")
ylabel("d' value")
title({animalName;'d'' Values of each Lickport'})
legend("LP1","LP2")
hold off
end


