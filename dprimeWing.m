function [dprime_right, dprime_left] = dprimeWing(Lick_Events, stage_sessionCount,animalName)
% creating new cell array
% Exclude stage 1-8
Lick_EventsS9 = Lick_Events (stage_sessionCount == 9);

answer = questdlg(sprintf("For mouse %s: which pair of wings was removed first?",animalName),...
    "Removed Wings", "Front", "Back", "Front");
switch answer
    case "Front"
        wing = ["f","f","b","b","f","f","b","b"];
    case "Back"
        wing = ["b","b","f","f","b","b","f","f"];
end

% right wing remaining
Lick_Eventsright = cell(1,numel(Lick_EventsS9));
for i = 1:numel(Lick_EventsS9)
    if wing(i) == "f"
        Lick_Eventsright{i} = Lick_EventsS9{i}(contains(Lick_EventsS9{i},"LP1"));
    else
        Lick_Eventsright{i} = Lick_EventsS9{i}(contains(Lick_EventsS9{i},"LP2"));
    end
end
% left wing remaining
Lick_Eventsleft = cell(1,numel(Lick_EventsS9));
for i = 1:numel(Lick_EventsS9)
    if wing(i) == "f"
        Lick_Eventsleft{i} = Lick_EventsS9{i}(contains(Lick_EventsS9{i},"LP2"));
    else
        Lick_Eventsleft{i} = Lick_EventsS9{i}(contains(Lick_EventsS9{i},"LP1"));
    end
end



% calculating go and no-go succes rate (right wing)
go_sucr = zeros(1,length(Lick_Eventsright));
go_failr = zeros(1,length(Lick_Eventsright));
nogo_sucr = zeros(1,length(Lick_Eventsright));
nogo_failr = zeros(1,length(Lick_Eventsright));
go_suc_rater = zeros(1,length(Lick_Eventsright));
nogo_suc_rater = zeros(1,length(Lick_Eventsright));
for i = 1:length(Lick_Eventsright)
    go_sucr(i) = sum(strncmpi(Lick_Eventsright{i},"Go Success",8));
    go_failr(i) = sum(strncmpi(Lick_Eventsright{i},"Go Failure",8));
    nogo_sucr(i) = sum(strncmpi(Lick_Eventsright{i},"No-Go Success",8));
    nogo_failr(i) = sum(strncmpi(Lick_Eventsright{i},"No-Go Failure",8));
    
    go_suc_rater(i) = go_sucr(i)/(go_sucr(i)+go_failr(i));
    nogo_suc_rater(i) = nogo_sucr(i)/(nogo_sucr(i)+nogo_failr(i));
end

% calculating dprime (right wing)
dprime_right = zeros(1,numel(Lick_Eventsright));
cvalr = zeros(1,numel(Lick_Eventsright));
for i = 1:numel(Lick_Eventsright)
    [dprime_right(i), cvalr(i)] = dprime(go_suc_rater(i), 1-nogo_suc_rater(i),...
        go_sucr(i)+go_failr(i), nogo_sucr(i)+nogo_failr(i));
end



% calculating go and no-go succes rate (left wing)
go_sucl = zeros(1,length(Lick_Eventsleft));
go_faill = zeros(1,length(Lick_Eventsleft));
nogo_sucl = zeros(1,length(Lick_Eventsleft));
nogo_faill = zeros(1,length(Lick_Eventsleft));
go_suc_ratel = zeros(1,length(Lick_Eventsleft));
nogo_suc_ratel = zeros(1,length(Lick_Eventsleft));
for i = 1:length(Lick_Eventsleft)
    go_sucl(i) = sum(strncmpi(Lick_Eventsleft{i},"Go Success",8));
    go_faill(i) = sum(strncmpi(Lick_Eventsleft{i},"Go Failure",8));
    nogo_sucl(i) = sum(strncmpi(Lick_Eventsleft{i},"No-Go Success",8));
    nogo_faill(i) = sum(strncmpi(Lick_Eventsleft{i},"No-Go Failure",8));
    
    go_suc_ratel(i) = go_sucl(i)/(go_sucl(i)+go_faill(i));
    nogo_suc_ratel(i) = nogo_sucl(i)/(nogo_sucl(i)+nogo_faill(i));
end

% calculating dprime (left wing)
dprime_left = zeros(1,numel(Lick_Eventsleft));
cvall = zeros(1,numel(Lick_Eventsleft));
for i = 1:numel(Lick_Eventsright)
    [dprime_left(i), cvall(i)] = dprime(go_suc_ratel(i), 1-nogo_suc_ratel(i),...
        go_sucl(i)+go_faill(i), nogo_sucl(i)+nogo_faill(i));
end



% t-Test
[h, p] = ttest2(dprime_right, dprime_left);

if ~isnan(h)
    if logical(h)
        fprintf('\nPerformance of mouse %s is significantly different, between wing sides.\n',animalName)
        fprintf('\np-value of: %.4f.\n',p)
    else
        fprintf('\nPerformance of mouse %s is not significantly different, between wing sides.\n',animalName)
        fprintf('\np-value of: %.4f.\n',p)
    end
end



% plotting d' values
f = figure;
f.Name = "dprimeWing";

plot(dprime_right, "ko:")
hold on
plot(dprime_left, "bo:")
zero_line = zeros(1,sum(stage_sessionCount == 9));
plot(zero_line,'Color','#666666')
dprime_line = 1.65*ones(1,sum(stage_sessionCount == 9));
plot(dprime_line,'--','Color','#666666')

axis tight
xlabel("Sessions in Stage 9")
ylabel("d' value")
title({animalName;'d'' Values for each Wing'})
legend("right Wing","left Wing")
hold off
end
