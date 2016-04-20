%% SMART Analysis Stack  Copyright (C) 2015-2016  Allen Hill
%  This program comes with ABSOLUTELY NO WARRANTY; for details, see 'LICENSE.txt'.
%  This is free software, and you are welcome to redistribute it
%  under certain conditions; for details, see 'LICENSE.txt'.

%% Environment setup
clc
% clear all
close all

% Load last processed file/path or initialize them
try
    load('angle_state')
catch
    filename = '';
    lastpath = strcat('\\letnet.net\fs\academics\Projects\AcademicAffairs\SchoolofEngineering\Projects',...
        '\BME-JR-Research\2015_16 SeniorDesign\BIOMECHANICS\DATA_MoCap');
    DEBUG = true;
    DEBUG_RAW = false;
    DEBUG_NORMALIZED = false;
    DEBUG_ANGLES = false;
    DEBUG_ALL = true;
end

%% File select
% Get file name and path from user
[filename,lastpath] = uigetfile({'*.trc','TRC motion files (*.trc)';...
    '*.*','All files (*.*)'},'Pick a file',strcat(lastpath,filename));
file = strcat(lastpath,filename);

% If uigetfile is "Canceled", filename and lastpath are returned empty.
% Don't save 'state' if uigetfile was canceled.
if size(file) ~= 0
    save('angle_state','lastpath','filename','DEBUG','DEBUG_RAW',...
        'DEBUG_NORMALIZED','DEBUG_ANGLES','DEBUG_ALL')
end

%% Data retrieval/setup
% Load data from .trc file
capture_data = importdata(file,'\t',5);

% Retrieve marker names for index searching
file_handle = fopen(file);
fgetl(file_handle);
fgetl(file_handle);
h3 = textscan(file_handle,'%d',4);
NumMarkers = h3{1}(4);
fgetl(file_handle);
S = textscan(file_handle,'%s',NumMarkers+2);
Markers = S{1}(:,1)';
fclose(file_handle);
Markers = Markers(3:length(Markers));

% Assign indexes for data segmentation
for n=1:length(Markers)
    switch Markers{n}
      case {'Handlebars_L','Handlebar_L'}
        l_handlebars_ind=n*3;
      case {'Handlebars_R','Handlebar_R'}
        r_handlebars_ind=n*3;
%       case 'R_MetaC2'
%         r_metac2_ind=n*3;
%       case 'R_MetaC5'
%         r_metac5_ind=n*3;
%       case 'R_WristLat'
%         r_wristlat_ind=n*3;
%       case 'R_WristMed'
%         r_wristmed_ind=n*3;
%       case 'L_MetaC2'
%         l_metac2_ind=n*3;
%       case 'L_MetaC5'
%         l_metac5_ind=n*3;
%       case 'L_WristLat'
%         l_wristlat_ind=n*3;
%       case 'L_WristMed'
%         l_wristmed_ind=n*3;
    end

end

% Remove unneeded variables from workspace
clear file_handle h3 NumMarkers S Markers file n

%% Data segmentation
% Meta markers
l_handlebar = capture_data.data(:,l_handlebars_ind:l_handlebars_ind+2);
r_handlebar = capture_data.data(:,r_handlebars_ind:r_handlebars_ind+2);
r_handlebar_vmkr = mean(r_handlebar);
l_handlebar_vmkr = mean(l_handlebar);

% r_metac2 = capture_data.data(:,r_metac2_ind:r_metac2_ind+2);
% r_metac5 = capture_data.data(:,r_metac5_ind:r_metac5_ind+2);
% r_wristlat = capture_data.data(:,r_wristlat_ind:r_wristlat_ind+2);
% r_wristmed = capture_data.data(:,r_wristmed_ind:r_wristmed_ind+2);
% l_metac2 = capture_data.data(:,l_metac2_ind:l_metac2_ind+2);
% l_metac5 = capture_data.data(:,l_metac5_ind:l_metac5_ind+2);
% l_wristlat = capture_data.data(:,l_wristlat_ind:l_wristlat_ind+2);
% l_wristmed = capture_data.data(:,l_wristmed_ind:l_wristmed_ind+2);

clear capture_data
clear -regexp ind

%% Raw Graphs
if (DEBUG && DEBUG_RAW) || DEBUG_ALL
    figure

%     %subplot(2,1,1)
%     hold on
%     plot3(r_handlebar(:,1),r_handlebar(:,2),r_handlebar(:,3),'.','Color','blue')
%     plot3(r_handlebar_vmkr(1),r_handlebar_vmkr(2),r_handlebar_vmkr(3),'o','Color','blue')
%     plot3(l_handlebar(:,1),l_handlebar(:,2),l_handlebar(:,3),'.','Color','red')
%     plot3(l_handlebar_vmkr(1),l_handlebar_vmkr(2),l_handlebar_vmkr(3),'o','Color','red')
%     axis vis3d
%     rotate3d on
%     title('Raw Handlebar Data')
%     hold off

%     subplot(2,1,2)
%     hold on
%     plot3(l_metac2(:,1),l_metac2(:,2),l_metac2(:,3),'.','Color','blue')
%     plot3(l_metac2_vmkr(1),l_metac2_vmkr(2),l_metac2_vmkr(3),'o','Color','blue')
%     plot3(l_metac5(:,1),l_metac5(:,2),l_metac5(:,3),'.','Color','red')
%     plot3(l_metac5_vmkr(1),l_metac5_vmkr(2),l_metac5_vmkr(3),'o','Color','red')
%     axis vis3d
%     rotate3d on
%     title('Raw Left Meta Data')
%     hold off
    %fig2plotly();
end

clear -regexp vmkr

%% Normalizing Data
% Center all the data at 0,0,0
r_handlebar = detrend(r_handlebar,'constant');
l_handlebar = detrend(l_handlebar,'constant');

% r_metac2 = detrend(r_metac2,'constant');
% r_metac5 = detrend(r_metac5,'constant');
% r_wristlat = detrend(r_wristlat,'constant');
% r_wristmed = detrend(r_wristmed,'constant');
% l_metac2 = detrend(l_metac2,'constant');
% l_metac5 = detrend(l_metac5,'constant');
% l_wristlat = detrend(l_wristlat,'constant');
% l_wristmed = detrend(l_wristmed,'constant');
%
% combined = [r_metac2; ...
%             r_metac5; ...
%             r_wristlat; ...
%             r_wristmed; ...
%             l_metac2; ...
%             l_metac5; ...
%             r_wristlat; ...
%             r_wristmed ];

% Perform PCA
if DEBUG
    tic
    [ handlebar_o, handlebar_pc, handlebar_Q ] = robustPCA([r_handlebar; l_handlebar]);
    %[ handlebar_o, handlebar_pc, handlebar_Q ] = robustPCA(combined);
    toc
else
    [ handlebar_o, handlebar_pc, ~ ] = robustPCA([r_handlebar; l_handlebar]);
    %[ handlebar_o, handlebar_pc, handlebar_Q ] = robustPCA(combined);
end

% if DEBUG
%     r_handlebar_lims = lims(r_handlebar);
%     l_handlebar_lims = lims(l_handlebar);
% end

%% Normalized Graphs
if (DEBUG && DEBUG_NORMALIZED) || DEBUG_ALL
    figure

%     subplot(2,1,1)
  hold on
  plot3(r_handlebar(:,1),r_handlebar(:,2),r_handlebar(:,3),'.','Color','blue')
  plot3(handlebar_o(1),handlebar_o(2),handlebar_o(3),'o','Color','blue')
%   plot3(0,0,0,'o','Color','blue')
  plot3(l_handlebar(:,1),l_handlebar(:,2),l_handlebar(:,3),'.','Color','red')
  plot3(handlebar_o(1),handlebar_o(2),handlebar_o(3),'o','Color','red')
%   plot3(0,0,0,'o','Color','red')
  line([0 handlebar_pc(1,1)/5],[0 handlebar_pc(1,2)/5],[0 handlebar_pc(1,3)/5],'Color','blue')
  line([0 handlebar_pc(2,1)/5],[0 handlebar_pc(2,2)/5],[0 handlebar_pc(2,3)/5],'Color','red')
  line([0 handlebar_pc(3,1)/5],[0 handlebar_pc(3,2)/5],[0 handlebar_pc(3,3)/5],'Color','green')
  title('Normalized Right Meta Data')
  axis vis3d
  rotate3d on
  hold off

%     subplot(2,1,2)
%     hold on
%     plot3(l_metac2(:,1),l_metac2(:,2),l_metac2(:,3),'.','Color','blue')
%     plot3(0,0,0,'o','Color','blue')
%     plot3(l_metac5(:,1),l_metac5(:,2),l_metac5(:,3),'.','Color','red')
%     plot3(0,0,0,'o','Color','red')
%     line([0 handlebar_pc(1,1)/5],[0 handlebar_pc(1,2)/5],[0 handlebar_pc(1,3)/5],'Color','blue')
%     line([0 handlebar_pc(2,1)/5],[0 handlebar_pc(2,2)/5],[0 handlebar_pc(2,3)/5],'Color','red')
%     line([0 handlebar_pc(3,1)/5],[0 handlebar_pc(3,2)/5],[0 handlebar_pc(3,3)/5],'Color','green')
%     title('Normalized Left Meta Data')
%     axis vis3d
%     rotate3d on
%     hold off
    %fig2plotly();
end

%% Angle Calculations

% l_combined_x = mean([l_metac2(:,1),l_metac5(:,1)],2);
% l_combined_y = mean([l_metac2(:,2),l_metac5(:,2)],2);
% l_combined_z = mean([l_metac2(:,3),l_metac5(:,3)],2);
% l_combined = [l_combined_x, l_combined_y, l_combined_z];
%
% [l_combined_angles, l_combined_ideal_path, l_combined_radius] = CalculateAngles(l_combined, handlebar_pc);

[angles, ideal_path, handlebar_radius] = CalculateAngles(r_handlebar, l_handlebar, handlebar_pc);
%[l_handlebar_angles, l_handlebar_ideal_path, l_handlebar_radius] = CalculateAngles(l_handlebar, handlebar_pc);

if (DEBUG && DEBUG_ANGLES) || DEBUG_ALL

    figure
    hold on
    plot3(r_handlebar(:,1),r_handlebar(:,2),r_handlebar(:,3),'.','Color','blue')
    plot3(handlebar_o(1),handlebar_o(2),handlebar_o(3),'o','Color','red')
    plot3(ideal_path(:,1),ideal_path(:,2),ideal_path(:,3),'Color','red','LineWidth',2)
    line([0 handlebar_pc(1,1)/5],[0 handlebar_pc(1,2)/5],[0 handlebar_pc(1,3)/5],'Color','blue')
    line([0 handlebar_pc(2,1)/5],[0 handlebar_pc(2,2)/5],[0 handlebar_pc(2,3)/5],'Color','red')
    line([0 handlebar_pc(3,1)/5],[0 handlebar_pc(3,2)/5],[0 handlebar_pc(3,3)/5],'Color','green')
    line([0 handlebar_radius],[0 0],[0 0],'Color','cyan')
    axis vis3d
    rotate3d on
    hold off
    %fig2plotly();

%     figure
%     hold on
%     plot3(l_combined(:,1),l_combined(:,2),l_combined(:,3),'.','Color','blue')
%     plot3(0,0,0,'o','Color','red')
%     plot3(l_combined_ideal_path(:,1),l_combined_ideal_path(:,2),l_combined_ideal_path(:,3),'Color','red','LineWidth',2)
%     line([0 handlebar_pc(1,1)/5],[0 handlebar_pc(1,2)/5],[0 handlebar_pc(1,3)/5],'Color','blue')
%     line([0 handlebar_pc(2,1)/5],[0 handlebar_pc(2,2)/5],[0 handlebar_pc(2,3)/5],'Color','red')
%     line([0 handlebar_pc(3,1)/5],[0 handlebar_pc(3,2)/5],[0 handlebar_pc(3,3)/5],'Color','green')
%     line([0 l_combined_radius],[0 0],[0 0],'Color','cyan')
%     axis vis3d
%     rotate3d on
%     hold off

    figure
    hold on
    plot(angles(1000:2000),'blue')
    %plot(r_handlebar_new(1000:2000),'red')
    %fig2plotly();
end

% angles = l_combined_angles;

%% Saving and Workspace cleanup

if false
  [savefilename,savelastpath] = uiputfile({'*.xlsx','Excel files (*.xlsx)'},'Save file name',lastpath);
  file = strcat(savelastpath,savefilename);

  if length(file) ~= 0
      xlswrite(file,[[0.01:.01:length(angles)*.01]',angles])
  end

  if ~DEBUG
      clear all
  end
else
  xlswrite(strcat(lastpath,filename,' handlebars.xlsx'),[[0.01:.01:length(angles)*.01]',angles])
end
