% SMART Analysis Stack  Copyright (C) 2015-2016  Allen Hill
%  This program comes with ABSOLUTELY NO WARRANTY; for details, see 'LICENSE.txt'.
%  This is free software, and you are welcome to redistribute it
%  under certain conditions; for details, see 'LICENSE.txt'.

%% Environment setup
clc
clear all
close all

% Load last processed file/path or initialize them
try
    load('analysis_state')
catch
    motfilename = '';
    lastpath = strcat('\\letnet.net\fs\academics\Projects\AcademicAffairs\SchoolofEngineering\Projects',...
        '\BME-JR-Research\2015_16 SeniorDesign\BIOMECHANICS\DATA_MoCap\Pilot_Capture');
    DEBUG = true;
end

%% File select
% Get file name and path from user
[motfilename,lastpath] = uigetfile({'*.mot','MOT motion files (*.mot)';...
    '*.*','All files (*.*)'},'Pick the overall model mot file',...
    strcat(lastpath,motfilename));
motfile = strcat(lastpath,motfilename);

tmp = strsplit(motfilename,'.');
tmp = char(tmp{1});
handlebarfile = strcat(lastpath,tmp,' handlebars.xlsx');

% If uigetfile is "Canceled", filename and lastpath are returned empty.
% Don't save 'state' if uigetfile was canceled.
if size(motfilename) ~= 0 | size(handlebarfile) ~= 0
    save('analysis_state','lastpath','motfilename','DEBUG')
end

%% Import data
% Load data from .trc file
capture_data = importdata(motfile,'\t',7);

% % Retrieve marker names for index searching
file_handle = fopen(motfile);
fgetl(file_handle);
fgetl(file_handle);
fgetl(file_handle);
h4 = textscan(file_handle,'%s',1);
nAngles = char(h4{1}(1));
nAngles = strsplit(nAngles,'=');
nAngles = str2double(nAngles{2});

fgetl(file_handle);
fgetl(file_handle);
fgetl(file_handle);
S = textscan(file_handle,'%s',nAngles+1);
fclose(file_handle);
Angles = S{1}(:,1)';


% Assign indexes for data segmentation
for n=1:nAngles
    switch Angles{n}
        case 'pelvis_tilt'
            pelvis_tilt_ind=n;
        case 'pelvis_list'
            pelvis_list_ind=n;
        case 'pelvis_rotation'
            pelvis_rotation_ind=n;
        case 'pelvis_tx'
            pelvis_tx_ind=n;
        case 'pelvis_ty'
            pelvis_ty_ind=n;
        case 'pelvis_tz'
            pelvis_tz_ind=n;
        case 'hip_flexion_r'
            hip_flexion_r_ind=n;
        case 'hip_adduction_r'
            hip_adduction_r_ind=n;
        case 'hip_rotation_r'
            hip_rotation_r_ind=n;
        case 'knee_angle_r'
          knee_angle_r_ind=n;
        case 'ankle_angle_r'
          ankle_angle_r_ind=n;
        case 'subtalar_angle_r'
          subtalar_angle_r_ind=n;
        case 'mtp_angle_r'
          mtp_angle_r_ind=n;
        case 'hip_flexion_l'
          hip_flexion_l_ind=n;
        case 'hip_adduction_l'
          hip_adduction_l_ind=n;
        case 'hip_rotation_l'
          hip_rotation_l_ind=n;
        case 'knee_angle_l'
          knee_angle_l_ind=n;
        case 'ankle_angle_l'
          ankle_angle_l_ind=n;
        case 'subtalar_angle_l'
          subtalar_angle_l_ind=n;
        case 'lumbar_extension'
          lumbar_extension_ind=n;
        case 'lumbar_bending'
          lumbar_bending_ind=n;
        case 'lumbar_rotation'
          lumbar_rotation_ind=n;
        case 'arm_flex_r'
          arm_flex_r_ind=n;
        case 'arm_add_r'
          arm_add_r_ind=n;
        case 'elbow_flex_r'
          elbow_flex_r_ind=n;
        case 'pro_sup_r'
          pro_sup_r_ind=n;
        case 'wrist_flex_r'
          wrist_flex_r_ind=n;
        case 'wrist_dev_r'
          wrist_dev_r_ind=n;
        case 'arm_flex_l'
          arm_flex_l_ind=n;
        case 'arm_add_l'
          arm_add_l_ind=n;
        case 'elbow_flex_l'
          elbow_flex_l_ind=n;
        case 'pro_sup_l'
          pro_sup_l_ind=n;
        case 'wrist_flex_l'
          wrist_flex_l_ind=n;
        case 'wrist_dev_l'
          wrist_dev_l_ind=n;
    end
end

% Load handlebar angles
handlebar_angles = xlsread(handlebarfile);
handlebar_angles = handlebar_angles(:,2);

%% Grab desired angles
elbow_flex_r_angles_raw = capture_data.data(:,elbow_flex_r_ind);
elbow_flex_l_angles_raw = capture_data.data(:,elbow_flex_l_ind);

knee_angles_r_raw = capture_data.data(:,knee_angle_r_ind);
knee_angles_l_raw = capture_data.data(:,knee_angle_l_ind);

%% Segment angles based on threshold (binWidth)
binWidth = 4;

for n=1:(360/binWidth)
  binAngleIndices{n} = find(handlebar_angles<n*binWidth&handlebar_angles>=(n-1)*binWidth);
end

[elbow_flex_r_angles, elbow_flex_r_anglesStd,~,~] = segmentAngles(elbow_flex_r_angles_raw,binAngleIndices);
[elbow_flex_l_angles, elbow_flex_l_anglesStd,~,~] = segmentAngles(elbow_flex_l_angles_raw,binAngleIndices);

% binWidth = 2;
% for n=1:(360/binWidth)
%   binAngleIndices{n} = find(handlebar_angles<n*binWidth&handlebar_angles>=(n-1)*binWidth);
% end
%
[knee_angles_r, knee_angles_r_Std,~,~] = segmentAngles(knee_angles_r_raw, binAngleIndices);
[knee_angles_l, knee_angles_l_Std,~,~] = segmentAngles(knee_angles_l_raw, binAngleIndices);

%% plots
plotShadedStd(knee_angles_r,knee_angles_r_Std,'Right Knee Angle (deg)');

plotShadedStd(elbow_flex_l_angles,elbow_flex_l_anglesStd,'Left Elbow Flexion (deg)');

VisCompSymmetry(elbow_flex_r_angles,elbow_flex_l_angles,'Elbow Flexion');
%%

nsi_raw = nsi(elbow_flex_r_angles_raw,elbow_flex_l_angles_raw);
[nsi_seg,nsi_Std,~,~] = segmentAngles(nsi_raw,binAngleIndices);
plotShadedStd(nsi_seg,nsi_Std,'Elbow Flexion NSI (%)');


%%

nsi_raw = nsi(knee_angles_r,knee_angles_l);
% nsi_Std = nsi(knee_angles_r_Std,knee_angles_l_Std);
% plotShadedStd(nsi_raw,nsi_Std,'Knee Angle NSI (%)');


% h = plotShadedStdComp(anglesMean,anglesStd,anglesMean,anglesStd*2/3,h);


%figure
