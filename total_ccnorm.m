%% Load files and angles
[motfilename,lastpath] = uigetfile({'*.mot','MOT motion files (*.mot)';...
    '*.*','All files (*.*)'},'Pick the first mot file');
motfile = strcat(lastpath,motfilename);

%Handlebar data file should have exactly the same name as the trial, except
%with ' handlebars.xlsx' at the end instead of '.mot'. The handlebar_angles
%script does this automatically so this shouldn't ever be an issue.
tmp = strsplit(motfilename,'.');
tmp = char(tmp{1});
handlebarfile = strcat(lastpath,tmp,' handlebars.xlsx');

% Load data from .trc file
handles.data = importdata(motfile,'\t',7);

% % Retrieve marker names for index searching
file_handle = fopen(motfile);
fgetl(file_handle); % CR
fgetl(file_handle); % CR
fgetl(file_handle); % CR
h4 = textscan(file_handle,'%s',1); % Get text from cell
nAngles = char(h4{1}(1)); % Convert to string
nAngles = strsplit(nAngles,'='); % Split string at '='
nAngles = str2double(nAngles{2}); % Take the second result, the number of markers
fgetl(file_handle); % CR
fgetl(file_handle); % CR
fgetl(file_handle); % CR
S = textscan(file_handle,'%s',nAngles+1); % Get all of the angle name containing cells from the row
fclose(file_handle);
Angles = S{1}(:,1)';

% Assign indexes for data segmentation
for n=1:nAngles
    switch Angles{n}
        case 'hip_flexion_r'
          handles.hip_flexion_r_ind=n;
        case 'hip_adduction_r'
          handles.hip_adduction_r_ind=n;
        case 'hip_rotation_r'
          handles.hip_rotation_r_ind=n;
        case 'knee_angle_r'
          handles.knee_angle_r_ind=n;
        case 'ankle_angle_r'
          handles.ankle_angle_r_ind=n;
        case 'subtalar_angle_r'
          handles.subtalar_angle_r_ind=n;
        case 'mtp_angle_r'
          handles.mtp_angle_r_ind=n;
        case 'hip_flexion_l'
          handles.hip_flexion_l_ind=n;
        case 'hip_adduction_l'
          handles.hip_adduction_l_ind=n;
        case 'hip_rotation_l'
          handles.hip_rotation_l_ind=n;
        case 'knee_angle_l'
          handles.knee_angle_l_ind=n;
        case 'ankle_angle_l'
          handles.ankle_angle_l_ind=n;
        case 'subtalar_angle_l'
          handles.subtalar_angle_l_ind=n;
        case 'mtp_angle_l'
          handles.mtp_angle_l_ind=n;
        case 'arm_flex_r'
          handles.arm_flex_r_ind=n;
        case 'arm_add_r'
          handles.arm_add_r_ind=n;
        case 'arm_rot_r'
          handles.arm_rot_r_ind=n;
        case 'elbow_flex_r'
          handles.elbow_flex_r_ind=n;
        case 'pro_sup_r'
          handles.pro_sup_r_ind=n;
        case 'wrist_flex_r'
          handles.wrist_flex_r_ind=n;
        case 'wrist_dev_r'
          handles.wrist_dev_r_ind=n;
        case 'arm_flex_l'
          handles.arm_flex_l_ind=n;
        case 'arm_add_l'
          handles.arm_add_l_ind=n;
        case 'arm_rot_l'
          handles.arm_rot_l_ind=n;
        case 'elbow_flex_l'
          handles.elbow_flex_l_ind=n;
        case 'pro_sup_l'
          handles.pro_sup_l_ind=n;
        case 'wrist_flex_l'
          handles.wrist_flex_l_ind=n;
        case 'wrist_dev_l'
          handles.wrist_dev_l_ind=n;
    end
end

% Load handlebar angles
handlebar_angles = xlsread(handlebarfile);
handles.firstHandlebarAngles = handlebar_angles(:,2);
handles.binWidth = 4;
% Calculate AngleIndices
% TODO: fix CalcAngleIndices for isolated
handles = CalcAngleIndices(handles);

angle_names = {
'hip_flexion_r', ...
'hip_adduction_r', ...
'hip_rotation_r', ...
'knee_angle_r', ...
'ankle_angle_r', ...
'subtalar_angle_r', ...
'mtp_angle_r', ...
'arm_flex_r', ...
'arm_add_r', ...
'arm_rot_r', ...
'elbow_flex_r', ...
'pro_sup_r', ...
'wrist_flex_r', ...
'wrist_dev_r', ...
'hip_flexion_l', ...
'hip_adduction_l', ...
'hip_rotation_l', ...
'knee_angle_l', ...
'ankle_angle_l', ...
'subtalar_angle_l', ...
'mtp_angle_l', ...
'arm_flex_l', ...
'arm_add_l', ...
'arm_rot_l', ...
'elbow_flex_l', ...
'pro_sup_l', ...
'wrist_flex_l', ...
'wrist_dev_l'};

for n=1:14
  % Grab first selected angle (probs the right) from the first dataset
  [angles_r, ~] = getAngles(handles,angle_names{n});
  % Grab second selected angle (probs the left) from the first dataset
  [angles_l, ~] = getAngles(handles,angle_names{n+14});
  angleLength = length(angles_l);

  angles_l = circshift(angles_l',floor(angleLength/2))';
  ccnorm(n,1) = Ccnorm(angles_r,angles_l);
end

symmetricStrings = { 'Hip Flexion'; ...
                     'Hip Adduction'; ...
                     'Hip Rotation'; ...
                     'Knee Angle'; ...
                     'Ankle Angle'; ...
                     'Subtalar Angle'; ...
                     'mtp Angle'; ...
                     'Arm Flexion'; ...
                     'Arm Adduction'; ...
                     'Arm Rotation'; ...
                     'Elbow Flexion'; ...
                     'Pro Sup'; ...
                     'Wrist Flexion'; ...
                     'Wrist Dev' };

xlswrite(strcat(lastpath,motfilename(1:length(motfilename)-4),' ccnorm.xlsx'),symmetricStrings,'A1:A14');
xlswrite(strcat(lastpath,motfilename(1:length(motfilename)-4),' ccnorm.xlsx'),ccnorm,'B1:B14');
