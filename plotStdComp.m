%% SMART Analysis Stack  Copyright (C) 2015-2016  Allen Hill
%  This program comes with ABSOLUTELY NO WARRANTY; for details, see 'LICENSE.txt'.
%  This is free software, and you are welcome to redistribute it
%  under certain conditions; for details, see 'LICENSE.txt'.

function [ fig ] = plotStdComp( anglesMeanOld, anglesStdOld, anglesMeanNew, anglesStdNew, angleStr )
%plotStd Plots angle average line with the std shaded around it.
%   This function graphs the average angle line with the Std as a shaded
%   area for the first dataset and dashed lines for the second dataset.
%   All data is plotted on the same axes to make direct comparisons of the
%   different trials. This figure can be used to show how the standard
%   deviation of the trails for that joint has changed (improved).

% Calculate the binWidth being used.
angleLength = length(anglesMeanNew);
binWidth = 360/angleLength;
x = binWidth:binWidth:360;

% Center data
anglesMeanOld = detrend(anglesMeanOld,'constant');
anglesMeanNew = detrend(anglesMeanNew,'constant');

% Create lines of the +/- standard deviation
anglesUpOld = anglesMeanOld + anglesStdOld;
anglesDownOld = anglesMeanOld - anglesStdOld;
anglesUpNew = anglesMeanNew + anglesStdNew;
anglesDownNew = anglesMeanNew - anglesStdNew;

% Calculate the extrema of the combined data and round to nearest multiple
% of 5 to make the axes of each graph the same.
yMax = ceil(max([anglesUpOld, anglesUpNew])/5)*5;
yMin = floor(min([anglesDownOld, anglesDownNew])/5)*5;

fig = figure;
hold on
h = gca;
% Plot upper old standard deviation as light grey shaded area (area shades
% all the way to the bottom of the graph). Set BaseValue at -180 because no
% angle will be less than -180.
area(x,anglesUpOld,'FaceColor',[.85 .85 .85],'EdgeColor',[1 1 1],'BaseValue',-180)
% Plot lower old standard deviation as white area to create the intended
% band of grey representing all area one Std away from average. Set
% BaseValue at -190 to prevent the possiblility of a pixel wide line.
area(x,anglesDownOld,'FaceColor',[1 1 1],'EdgeColor',[1 1 1],'BaseValue',-190)
% Plot newer Std lines as red dashed lines
plot(x,anglesUpNew,'-.r')
plot(x,anglesDownNew,'-.r')
% Plot average angle lines
p5 = plot(x,anglesMeanOld,'g');
p6 = plot(x,anglesMeanNew,'b');
s5 = char(strcat({'Old Average Std = '},num2str(mean(anglesStdOld),7)));
s6 = char(strcat({'New Average Std = '},num2str(mean(anglesStdNew),7)));
% Only show the legend for the two average angle lines
legend([p5(1); p6(1)],s5,s6,'Location','best')
xlim([0 360])
ylim([yMin yMax])
set(h,'XTick',0:30:360);
title(strcat(angleStr,' vs. Handlebar Angle (deg)'))
xlabel('Handlebar Angle (deg)')
ylabel(angleStr)
hold off

end
