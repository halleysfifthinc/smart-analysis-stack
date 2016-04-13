%% SMART Analysis Stack  Copyright (C) 2015-2016  Allen Hill
%  This program comes with ABSOLUTELY NO WARRANTY; for details, see 'LICENSE.txt'.
%  This is free software, and you are welcome to redistribute it
%  under certain conditions; for details, see 'LICENSE.txt'.

function varargout = test_gui(varargin)
%TEST_GUI MATLAB code for test_gui.fig
%      TEST_GUI, by itself, creates a new TEST_GUI or raises the existing
%      singleton*.
%
%      H = TEST_GUI returns the handle to a new TEST_GUI or the handle to
%      the existing singleton*.
%
%      TEST_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEST_GUI.M with the given input arguments.
%
%      TEST_GUI('Property','Value',...) creates a new TEST_GUI or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before test_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to test_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help test_gui

% Last Modified by GUIDE v2.5 31-Jan-2016 18:56:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @test_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @test_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

%% --- Executes just before test_gui is made visible.
function test_gui_OpeningFcn(hObject, ~, handles, varargin)
% Choose default command line output for test_gui
handles.output = hObject;
disp('Opened')

% Update handles structure
guidata(hObject, handles);

% Setup default variables, etc.
initialize_gui(hObject, handles, false);

%% --- Exececuted by the OpeningFcn or on reset
function initialize_gui(fig_handle, handles, isreset)
% Set default values and placeholders, set the values of the respective GUI
% elements

handles.binWidth = 4;
set(handles.binwidthselector,'Value',3);
handles.graphType = 1;
set(handles.graphpick,'Value',handles.graphType);
handles.selectedAnglesNum = [1];
set(handles.anglelist,'Value',handles.selectedAnglesNum);
handles.selectedAnglesStrings = {'pelvis_tilt'};
handles.DEBUG = true;
if ~isfield(handles,'allFigs')
  handles.allFigs = [];
end

% Update handles structure
guidata(handles.figure1, handles);
% If this is not a reset (ie. we are initializing the GUI), don't continue
if ~isreset
    return;
end

% Attempt to close all graphs that have been created by the GUI and clear
% the list of open graphs
if (isfield(handles,'allFigs')) && (~isempty(handles.allFigs))
  for n=1:length(handles.allFigs)
    try
      close(handles.allFigs(n))
    end
  end
  handles.allFigs = [];
  try
  handles = rmfield(handles,'latestFig');
  end
end


% If this is a reset, we have possibly just changed the binWidth, and the
% binAngleIndices need to be updated to match the binWidth
if isfield(handles,'firstCapture_data') && isfield(handles,'secondCapture_data')
  handles = CalcAngleIndices(handles);
end
% Update handles structure
guidata(handles.figure1, handles);


%% --- Outputs from this function are returned to the command line.
function varargout = test_gui_OutputFcn(hObject, ~, handles)
% Get default command line output from handles structure
varargout{1} = handles.output;

%% --- Executes on button press in pickfile.
function pickfile_Callback(hObject, ~, handles)
% Get file name and path from user
[motfilename,lastpath] = uigetfile({'*.mot','MOT motion files (*.mot)';...
    '*.*','All files (*.*)'},'Pick the first mot file');
motfile = strcat(lastpath,motfilename);
if handles.DEBUG
    disp('First .mot file: ')
    disp(motfile)
end

%Handlebar data file should have exactly the same name as the trial, except
%with ' handlebars.xlsx' at the end instead of '.mot'. The handlebar_angles
%script does this automatically so this shouldn't ever be an issue.
tmp = strsplit(motfilename,'.');
tmp = char(tmp{1});
handlebarfile = strcat(lastpath,tmp,' handlebars.xlsx');
if handles.DEBUG
    disp('First handlebar file: ')
    disp(handlebarfile)
end


% Load data from .trc file
handles.firstCapture_data = importdata(motfile,'\t',7);

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
        case 'pelvis_tilt'
          handles.pelvis_tilt_ind=n;
        case 'pelvis_list'
          handles.pelvis_list_ind=n;
        case 'pelvis_rotation'
          handles.pelvis_rotation_ind=n;
        case 'pelvis_tx'
          handles.pelvis_tx_ind=n;
        case 'pelvis_ty'
          handles.pelvis_ty_ind=n;
        case 'pelvis_tz'
          handles.pelvis_tz_ind=n;
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
        case 'lumbar_extension'
          handles.lumbar_extension_ind=n;
        case 'lumbar_bending'
          handles.lumbar_bending_ind=n;
        case 'lumbar_rotation'
          handles.lumbar_rotation_ind=n;
        case 'arm_flex_r'
          handles.arm_flex_r_ind=n;
        case 'arm_add_r'
          handles.arm_add_r_ind=n;
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
% Calculate AngleIndices if possible
if isfield(handles,'firstCapture_data') && isfield(handles,'secondCapture_data')
  handles = CalcAngleIndices(handles);
end

guidata(hObject,handles)

%% --- Executes on button press in picksecondfile.
function picksecondfile_Callback(hObject, ~, handles)
% Get file name and path from user
[motfilename,lastpath] = uigetfile({'*.mot','MOT motion files (*.mot)';...
    '*.*','All files (*.*)'},'Pick the second mot file');
motfile2 = strcat(lastpath,motfilename);
if handles.DEBUG
    disp('Second .mot file: ')
    disp(motfile2)
end

%Figure handlebar data filename
tmp = strsplit(motfilename,'.');
tmp = char(tmp{1});
handlebarfile2 = strcat(lastpath,tmp,' handlebars.xlsx');
if handles.DEBUG
    disp('Second handlebar file: ')
    disp(handlebarfile2)
end

% No need to get the angle indices again, compatible trials will use the
% same model, therefore the same angles will be in the same order

% Load data from .trc file
handles.secondCapture_data = importdata(motfile2,'\t',7);

% Load handlebar angles
handlebar_angles2 = xlsread(handlebarfile2);
handles.secondHandlebarAngles = handlebar_angles2(:,2);
% Calculate AngleIndices if possible
if isfield(handles,'firstCapture_data') && isfield(handles,'secondCapture_data')
  handles = CalcAngleIndices(handles);
end

guidata(hObject,handles)

%% --- Executes on button press in reset.
function reset_Callback(hObject, ~, handles)
% Run the initialize function and notify that it is a reset.
initialize_gui(gcbf, handles, true);

%% --- Executes on button press in savebutton.
function savebutton_Callback(hObject, ~, handles)

n=true;
while n
    n=false;
    [filename, pathname] = uiputfile( ...
    {'*.jpg;*.png;*.bmp;*.tif', 'Bitmap Image (*.jpg, *.png, *.bmp, *.tif)';...
     '*.fig','MATLAB FIG-file (*.fig)';...
     '*.svg','Scalable Vector Graphics image (*.svg)';...
     '*.pdf','Portable Document Format (*.pdf)';...
     '*.emf','Enhanced Windows Metafile (*.emf)';...
     '*.*',  'All Files (*.*)'},...
     'Save as');

    % TODO: Use print for customizeable image resolution
    if ~(isequal(filename,0)|| isequal(pathname,0))
        filenameLength = length(filename);
        ext = filename(filenameLength-2:filenameLength);
        switch ext
            case 'jpg'
                saveas(handles.latestFig,filename,'jpeg');
            case 'png'
                saveas(handles.latestFig,filename,'png');
            case 'bmp'
                saveas(handles.latestFig,filename,'bmp');
            case 'tif'
                saveas(handles.latestFig,filename,'tiff');
            case 'fig'
                saveas(handles.latestFig,filename,'fig');
            case 'svg'
                saveas(handles.latestFig,filename,'svg');
            case 'pdf'
                saveas(handles.latestFig,filename,'pdf');
            case 'eps'
                saveas(handles.latestFig,filename,'epsc');
            case 'emf'
                saveas(handles.latestFig,filename,'meta');
            case 'html'
                % Plotly
            otherwise
                warndlg('Invalid file extension');
                n=true;
        end
    end
end


%% --- Executes on selection change in anglelist.
function anglelist_Callback(hObject, ~, handles)
% Get the angle numbers and associated angle names from the callback
contents = get(hObject,'Value');
strings = get(hObject,'String');
strings = strings(get(hObject,'Value'));
if handles.DEBUG
  disp('Angles: ')
  disp(strings)
end
handles.selectedAnglesNum = contents;
handles.selectedAnglesStrings = strings;
%Update handles structure
guidata(hObject,handles)


%% --- Executes during object creation, after setting all properties.
function anglelist_CreateFcn(hObject, ~, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% --- Executes on selection change in graphpick.
function graphpick_Callback(hObject, ~, handles)
% Get the graphType from the callback and update the handles structure
graphType = get(hObject,'Value');
handles.graphType = graphType;
guidata(hObject,handles)
if handles.DEBUG
    disp(['graphType = ',num2str(handles.graphType)])
end

%% --- Executes during object creation, after setting all properties.
function graphpick_CreateFcn(hObject, ~, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% --- Executes on button press in gobutton.
function gobutton_Callback(hObject, ~, handles)
% Create text objects containing the human readable angle names
prettyStrings = {   'Pelvis Tilt (deg)', ...
                    'Pelvis List (deg)', ...
                    'Pelvis Rotation (deg)', ...
                    'Pelvis Position, X-axis (m)', ...
                    'Pelvis Position, Y-axis (m)', ...
                    'Pelvis Position, Z-axis (m)', ...
                    'Right Hip Flexion (deg)', ...
                    'Right Hip Adduction (deg)', ...
                    'Right Hip Rotation (deg)', ...
                    'Right Knee Angle (deg)', ...
                    'Right Ankle Angle (deg)', ...
                    'Right Subtalar Angle (deg)', ...
                    'Right Metatarsal Phalangeal Angle (deg)', ...
                    'Left Hip Flexion (deg)', ...
                    'Left Hip Adduction (deg)', ...
                    'Left Hip Rotation (deg)', ...
                    'Left Knee Angle (deg)', ...
                    'Left Ankle Angle (deg)', ...
                    'Left Subtalar Angle (deg)', ...
                    'Lumbar Extension (deg)', ...
                    'Lumbar Bending (deg)', ...
                    'Lumbar Rotation (deg)', ...
                    'Right Arm Flexion (deg)', ...
                    'Right Arm Adduction (deg)', ...
                    'Right Elbow Flexion (deg)', ...
                    'Right Pro Sup (deg)', ...
                    'Right Wrist Flexion (deg)', ...
                    'Right Wrist Dev (deg)', ...
                    'Left Arm Flexion (deg)', ...
                    'Left Arm Adduction (deg)', ...
                    'Left Elbow Flexion (deg)', ...
                    'Left Pro Sup (deg)', ...
                    'Left Wrist Flexion (deg)', ...
                    'Left Wrist Dev (deg)' };

symmetricStrings = { 'Pelvis Tilt', ...
                     'Pelvis List', ...
                     'Pelvis Rotation', ...
                     'Pelvis Position, X-axis', ...
                     'Pelvis Position, Y-axis', ...
                     'Pelvis Position, Z-axis', ...
                     'Hip Flexion', ...
                     'Hip Adduction', ...
                     'Hip Rotation', ...
                     'Knee Angle', ...
                     'Ankle Angle', ...
                     'Subtalar Angle', ...
                     'mtp Angle', ...
                     'Hip Flexion', ...
                     'Hip Adduction', ...
                     'Hip Rotation', ...
                     'Knee Angle', ...
                     'Ankle Angle', ...
                     'Subtalar Angle', ...
                     'Lumbar Extension', ...
                     'Lumbar Bending', ...
                     'Lumbar Rotation', ...
                     'Arm Flexion', ...
                     'Arm Adduction', ...
                     'Elbow Flexion', ...
                     'Pro Sup', ...
                     'Wrist Flexion', ...
                     'Wrist Dev', ...
                     'Arm Flexion', ...
                     'Arm Adduction', ...
                     'Elbow Flexion', ...
                     'Pro Sup', ...
                     'Wrist Flexion', ...
                     'Wrist Dev' };

% Main logic of the GUI
switch handles.graphType
  case 1
    % Case 1 is the standard plotStd, which shows the selected angle with its
    % Std lines, both the old and new data. The for loop allows the user to
    % select multiple angles and all of those angles will be graphed in new
    % figures.
    for n=1:length(handles.selectedAnglesNum)
      [angles1, anglesStd1] = getAngles(handles,1,1,n);
      [angles2, anglesStd2] = getAngles(handles,2,1,n);
      % Run the plotting function and store the returned figure handle as
      % the most recent figure
      handles.latestFig = plotStd(angles1,anglesStd1,angles2,anglesStd2, ...
                                  prettyStrings{handles.selectedAnglesNum(n)});
    end
  case 2
    % Case 2 plots the selected angle in the same axes using a shaded Std
    % for the old data and red dashed lines for the new. Allows comparison
    % of the general improvement in angle deviation.
    for n=1:length(handles.selectedAnglesNum)
      [angles1, anglesStd1] = getAngles(handles,1,2,n);
      [angles2, anglesStd2] = getAngles(handles,2,2,n);
      % Run the plotting function and store the returned figure handle as
      % the most recent figure
      handles.latestFig = plotStdComp(angles1,anglesStd1,angles2,anglesStd2, ...
                                      prettyStrings{handles.selectedAnglesNum(1)});
    end
  case 3
    %Case 3 plots the Ccnorm
    %Don't allow this graph to be attempted if only one angle is selected
    if length(handles.selectedAnglesNum) > 1
      tmp_str1 = handles.selectedAnglesStrings{1};
      length1 = length(tmp_str1);
      tmp_str2 = handles.selectedAnglesStrings{2};
      length2 = length(tmp_str2);

      %Don't allow this graph if non-symmetric joints are chosen
      % Symmetric angles should be: a) the same length, and b) only differ by
      % the last letter.
      if (length1 == length2) && isequal(tmp_str1(1:(length1-1)),tmp_str2(1:(length2-1))) && ...
           (tmp_str1(length1) == 'r') && (tmp_str2(length2) == 'l')
        % Grab first selected angle (probs the right) from the first dataset
        [angles1_old, ~] = getAngles(handles,1,3,1);
        % Grab second selected angle (probs the left) from the first dataset
        [angles2_old, ~] = getAngles(handles,1,3,2);
        % Grab the first selected angle (hopefully still right) from the second dataset
        [angles1_new, ~] = getAngles(handles,2,3,1);
        % Grab the second selected angle (hopefully still left) from the second dataset
        [angles2_new, ~] = getAngles(handles,2,3,2);
        % Run the plotting function and store the returned figure handle as
        % the most recent figure
        handles.latestFig = plotCcnorm(angles1_old,angles2_old,angles1_new,angles2_new,...
                                            symmetricStrings{handles.selectedAnglesNum(1)});
      else
        % If non-symmetric joint angles are chosen, don't fail silently.
        % Notify user of their mistake and require correction before
        % allowing graphing.
        warndlg('Non symmetric joint angles chosen. Please choose symmetric angles.')
      end
    else
      % If only one angle is selected, don't fail silently. Notify user of
      % their mistake and require correction of the problem to work.
      warndlg('Only one angle selected. This graph requires 2 symmetric angles.')
    end
  case 4
    %Case 4 plots the NSI of the selected symmetric angles
    %Don't allow this graph to be attempted if only one angle is selected
    if length(handles.selectedAnglesNum) > 1
      tmp_str1 = handles.selectedAnglesStrings{1};
      length1 = length(tmp_str1);
      tmp_str2 = handles.selectedAnglesStrings{2};
      length2 = length(tmp_str2);

      %Don't allow this graph if non-symmetric joints are chosen
      % Symmetric angles should be: a) the same length, and b) only differ by
      % the last letter.
      if (length1 == length2) && isequal(tmp_str1(1:(length1-1)),tmp_str2(1:(length2-1))) && ...
           (tmp_str1(length1) == 'r') && (tmp_str2(length2) == 'l')
        % Grab first selected angle (probs the right) from the first dataset
        [angles1_old, ~] = getAngles(handles,1,4,1);
        % Grab second selected angle (probs the left) from the first dataset
        [angles2_old, ~] = getAngles(handles,1,4,2);
        % Grab the first selected angle (hopefully still right) from the second dataset
        [angles1_new, ~] = getAngles(handles,2,4,1);
        % Grab the second selected angle (hopefully still left) from the second dataset
        [angles2_new, ~] = getAngles(handles,2,4,2);
        % Run the plotting function and store the returned figure handle as
        % the most recent figure
        handles.latestFig = plotNSI(angles1_old,angles2_old,handles.firstHandlebarAngles, ...
                                    angles1_new,angles2_new,handles.secondHandlebarAngles, ...
                                    symmetricStrings{handles.selectedAnglesNum(1)});
      else
        % If non-symmetric joint angles are chosen, don't fail silently.
        % Notify user of their mistake and require correction before
        % allowing graphing.
        warndlg('Non symmetric joint angles chosen. Please choose symmetric angles.')
      end
    else
      % If only one angle is selected, don't fail silently. Notify user of
      % their mistake and require correction of the problem to work.
      warndlg('Only one angle selected. This graph requires 2 symmetric angles.')
    end
end

%Update the list of open figures
handles.allFigs(length(handles.allFigs)+1) = handles.latestFig;

% Clear any variable createdx during the process of this function. Although
% these variable are only within the scope of this function, they seem to
% persist through multiple runs of this function and gave some erroneous
% results if not cleared.
clear angles1 anglesStd1 angles2 anglesStd2 tmp_str1 tmp_str2 length1 length2
guidata(hObject,handles)

function [angles, anglesStd] = getAngles(handles, set, graphType, selectedAngle)
% Grab the data and angle indices from the first or second data set
% according to the set input variable.
if set == 1
  data = handles.firstCapture_data.data;
  binAngleIndices = handles.firstBinAngleIndices;
elseif set == 2
  data = handles.secondCapture_data.data;
  binAngleIndices = handles.secondBinAngleIndices;
end

angleStr = handles.selectedAnglesStrings{selectedAngle};

% Get the correct angle data according to the angle column indices
switch angleStr
  case 'pelvis_tilt'
    angles_raw = data(:,handles.pelvis_tilt_ind);
  case 'pelvis_list'
    angles_raw = data(:,handles.pelvis_list_ind);
  case 'pelvis_rotation'
    angles_raw = data(:,handles.pelvis_rotation_ind);
  case 'pelvis_tx'
    angles_raw = data(:,handles.pelvis_tx_ind);
  case 'pelvis_ty'
    angles_raw = data(:,handles.pelvis_ty_ind);
  case 'pelvis_tz'
    angles_raw = data(:,handles.pelvis_tz_ind);
  case 'hip_flexion_r'
    angles_raw = data(:,handles.hip_flexion_r_ind);
  case 'hip_adduction_r'
    angles_raw = data(:,handles.hip_adduction_r_ind);
  case 'hip_rotation_r'
    angles_raw = data(:,handles.hip_rotation_r_ind);
  case 'knee_angle_r'
    angles_raw = data(:,handles.knee_angle_r_ind);
  case 'ankle_angle_r'
    angles_raw = data(:,handles.ankle_angle_r_ind);
  case 'subtalar_angle_r'
    angles_raw = data(:,handles.subtalar_angle_r_ind);
  case 'mtp_angle_r'
    angles_raw = data(:,handles.mtp_angle_r_ind);
  case 'hip_flexion_l'
    angles_raw = data(:,handles.hip_flexion_l_ind);
  case 'hip_adduction_l'
    angles_raw = data(:,handles.hip_adduction_l_ind);
  case 'hip_rotation_l'
    angles_raw = data(:,handles.hip_rotation_l_ind);
  case 'knee_angle_l'
    angles_raw = data(:,handles.knee_angle_l_ind);
  case 'ankle_angle_l'
    angles_raw = data(:,handles.ankle_angle_l_ind);
  case 'subtalar_angle_l'
    angles_raw = data(:,handles.subtalar_angle_l_ind);
  case 'lumbar_extension'
    angles_raw = data(:,handles.lumbar_extension_ind);
  case 'lumbar_bending'
    angles_raw = data(:,handles.lumbar_bending_ind);
  case 'lumbar_rotation'
    angles_raw = data(:,handles.lumbar_rotation_ind);
  case 'arm_flex_r'
    angles_raw = data(:,handles.arm_flex_r_ind);
  case 'arm_add_r'
    angles_raw = data(:,handles.arm_add_r_ind);
  case 'elbow_flex_r'
    angles_raw = data(:,handles.elbow_flex_r_ind);
  case 'pro_sup_r'
    angles_raw = data(:,handles.pro_sup_r_ind);
  case 'wrist_flex_r'
    angles_raw = data(:,handles.wrist_flex_r_ind);
  case 'wrist_dev_r'
    angles_raw = data(:,handles.wrist_dev_r_ind);
  case 'arm_flex_l'
    angles_raw = data(:,handles.arm_flex_l_ind);
  case 'arm_add_l'
    angles_raw = data(:,handles.arm_add_l_ind);
  case 'elbow_flex_l'
    angles_raw = data(:,handles.elbow_flex_l_ind);
  case 'pro_sup_l'
    angles_raw = data(:,handles.pro_sup_l_ind);
  case 'wrist_flex_l'
    angles_raw = data(:,handles.wrist_flex_l_ind);
  case 'wrist_dev_l'
    angles_raw = data(:,handles.wrist_dev_l_ind);
end

% If the graph is type 4, don't segment the angles. We need the raw data
if graphType == 4
  angles = angles_raw;
  anglesStd = [];
else
  % Otherwise, segment the angles
  [angles,anglesStd,~] = segmentAngles(angles_raw,binAngleIndices);
end
clear angles_raw data binAngleIndices angleStr

%% --- Executes on selection change in binwidthselector.
function binwidthselector_Callback(hObject, ~, handles)
%Get the new binWidth, store it in handles, and update the angleIndices.
binWidth = get(hObject,'Value');
switch binWidth
  case 3
    binWidth = 4;
  case 4
    binWidth = 6;
  case 5
    binWidth = 8;
  case 6
    binWidth = 10;
  otherwise
end
handles.binWidth = binWidth;

handles = CalcAngleIndices(handles);

if handles.DEBUG
    disp(['binWidth = ',num2str(handles.binWidth)])
end
guidata(hObject,handles)

%% --- Called from binwidthselector
function var = CalcAngleIndices(handles)
% Clear the variables in case the new angleIndices are different (shorter)
% lengths and some data from the old binWidth value would hold over and
% cause erroneous results.
handles.firstBinAngleIndices = {};
handles.secondBinAngleIndices = {};

% Gather all the indices for data points that occur within a range of
% degrees determined by binWidth
for n=1:(360/handles.binWidth)
  handles.firstBinAngleIndices{n} = find( handles.firstHandlebarAngles < n*handles.binWidth ...
      & handles.firstHandlebarAngles >= (n-1)*handles.binWidth );
  handles.secondBinAngleIndices{n} = find( handles.secondHandlebarAngles < n*handles.binWidth ...
      & handles.secondHandlebarAngles >= (n-1)*handles.binWidth );
end

% Return the update handles structure
var = handles;


%% --- Executes during object creation, after setting all properties.
function binwidthselector_CreateFcn(hObject, ~, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, ~, handles)
% Attempts to close all graphs that have been made during the course of the
% GUI's lifetime
if (isfield(handles,'allFigs')) && (~isempty(handles.allFigs))
  for n=1:length(handles.allFigs)
    try
      close(handles.allFigs(n))
    end
  end
  handles.allFigs = [];
end
%Close the GUI
delete(handles.figure1)
