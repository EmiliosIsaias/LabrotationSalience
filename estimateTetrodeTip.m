clc, clearvars
addpath 'Z:\Josephine\MATLAB\LoadData_Amira'

%choose animal and load Data from Amira Recontruction
animal_list = {'#33','#34','#35','#36','#37','#38'};
answer = listdlg('ListString',animal_list,'PromptString','Choose your animal.');
animal_name = animal_list{answer};

[HeaderTetrodes,DataTetrodes] = LoadData_Amira(sprintf("Z:\\Josephine\\Histo\\Cohort_12_33-38\\%s\\%s_reconstruction\\Tetrodes.am",animal_list{answer},animal_list{answer}));
% BF1=1, BF2=2, BF3=3, BF4=4, BF5=5, VPM1=6, VPM2=7, VPM3=8, VPM4=9,
% POm1=10, POm2=11, POm3=12, POm4=13, ZIv1=14, ZIv2=15, ZIv3=16
[~,DataVPM] = LoadData_Amira(sprintf("Z:\\Josephine\\Histo\\Cohort_12_33-38\\%s\\%s_reconstruction\\VPM.am",animal_list{answer},animal_list{answer}));
[~,DataPO] = LoadData_Amira(sprintf("Z:\\Josephine\\Histo\\Cohort_12_33-38\\%s\\%s_reconstruction\\PO.am",animal_list{answer},animal_list{answer}));
[~,DataZI] = LoadData_Amira(sprintf("Z:\\Josephine\\Histo\\Cohort_12_33-38\\%s\\%s_reconstruction\\Zona_Incerta.am",animal_list{answer},animal_list{answer}));
sizeBrain = size(DataTetrodes);

% Data of #34 is rotated 180° compared to the other animals in this cohort,
% it has to be rotated to work with this code
if answer == 2
    DataTetrodes = imrotate(DataTetrodes,180);
    DataVPM = imrotate(DataVPM,180);
    DataPO = imrotate(DataPO,180);
    DataZI = imrotate(DataZI,180);
end

%% VPM
for i=6:9
    % get coordinates of TetrodeTip
    [row,~] = find(DataTetrodes==i);
    y = max(row);
    z = ceil((find(DataTetrodes(y,:,:)==i))/sizeBrain(2));
    x = find(DataTetrodes(y,:,z(1))==i);

    % check if tip is in volume of interest
    for ii=1:length(x)
        if DataVPM(y,x(ii),z(1))==1
            fprintf('Your TetrodeTip of VPM%d lies in your volume of interest.\n',i-5)
            break
        elseif ii==length(x) && DataVPM(y,x(ii),z(1))==0
            %get minimal distance from tip to VPM
            [yVPM,colVPM] = find(DataVPM==1);
            zVPM = ceil(colVPM/sizeBrain(2));
            xVPM = colVPM-((sizeBrain(2)*(zVPM-1)));
            
            coordinatesVPM = [yVPM,xVPM,zVPM];
            
            allDist = pdist2([y*HeaderTetrodes.PixelSpacing(1),x(ceil(end/2))*HeaderTetrodes.PixelSpacing(2),z(ceil(end/2))*HeaderTetrodes.SliceThickness],...
                [coordinatesVPM(:,1)*HeaderTetrodes.PixelSpacing(1),coordinatesVPM(:,2)*HeaderTetrodes.PixelSpacing(2),coordinatesVPM(:,3)*HeaderTetrodes.SliceThickness]);
            minDist = min(allDist);
            
            fprintf('Your TetrodeTip of VPM%d lies out of your volume of interest with a distance of %.2fµm.\n',i-5,minDist)
        end
    end
end
fprintf('\n')

%% POm
for i=10:13
    % get coordinates of TetrodeTip
    [row,~] = find(DataTetrodes==i);
    y = max(row);
    z = ceil((find(DataTetrodes(y,:,:)==i))/sizeBrain(2));
    x = find(DataTetrodes(y,:,z(1))==i);

    % check if tip is in volume of interest
    for ii=1:length(x)
        if DataPO(y,x(ii),z(1))==1
            fprintf('Your TetrodeTip of POm%d lies in your volume of interest.\n',i-9)
            break
        elseif ii==length(x) && DataPO(y,x(ii),z(1))==0
            %get minimal distance from tip to PO
            [yPO,colPO] = find(DataPO==1);
            zPO = ceil(colPO/sizeBrain(2));
            xPO = colPO-((sizeBrain(2)*(zPO-1)));
            
            coordinatesPO = [yPO,xPO,zPO];
            
            allDist = pdist2([y*HeaderTetrodes.PixelSpacing(1),x(ceil(end/2))*HeaderTetrodes.PixelSpacing(2),z(ceil(end/2))*HeaderTetrodes.SliceThickness],...
                [coordinatesPO(:,1)*HeaderTetrodes.PixelSpacing(1),coordinatesPO(:,2)*HeaderTetrodes.PixelSpacing(2),coordinatesPO(:,3)*HeaderTetrodes.SliceThickness]);
            minDist = min(allDist);

            fprintf('Your TetrodeTip of POm%d lies out of your volume of interest with a distance of %.2fµm.\n',i-9,minDist)
        end
    end
end
fprintf('\n')

%% ZIv
for i=14:16
    % get coordinates of TetrodeTip
    [row,~] = find(DataTetrodes==i);
    y = max(row);
    z = ceil((find(DataTetrodes(y,:,:)==i))/sizeBrain(2));
    x = find(DataTetrodes(y,:,z(1))==i);

    % check if tip is in volume of interest
    for ii=1:length(x)
        if DataZI(y,x(ii),z(1))==1
            fprintf('Your TetrodeTip of ZIv%d lies in your volume of interest.\n',i-13)
            break
        elseif ii==length(x) && DataZI(y,x(ii),z(1))==0
            %get minimal distance from tip to ZI
            [yZI,colZI] = find(DataZI==1);
            zZI = ceil(colZI/sizeBrain(2));
            xZI = colZI-((sizeBrain(2)*(zZI-1)));

            coordinatesZI = [yZI,xZI,zZI];
            
            allDist = pdist2([y*HeaderTetrodes.PixelSpacing(1),x(ceil(end/2))*HeaderTetrodes.PixelSpacing(2),z(ceil(end/2))*HeaderTetrodes.SliceThickness],...
                    [coordinatesZI(:,1)*HeaderTetrodes.PixelSpacing(1),coordinatesZI(:,2)*HeaderTetrodes.PixelSpacing(2),coordinatesZI(:,3)*HeaderTetrodes.SliceThickness]);
            minDist = min(allDist);

            fprintf('Your TetrodeTip of ZIv%d lies out of your volume of interest with a distance of %.2fµm.\n',i-13,minDist)
        end
    end
end
fprintf('\n')