% SMART Analysis Stack  Copyright (C) 2015-2016  Allen Hill
%  This program comes with ABSOLUTELY NO WARRANTY; for details, see 'LICENSE.txt'.
%  This is free software, and you are welcome to redistribute it
%  under certain conditions; for details, see 'LICENSE.txt'.

function [ fig ] = plotStd( anglesMeanOld, anglesStdOld, anglesMeanNew, anglesStdNew, angleStr )
%plotStd Plots both trials in separate subplots.
%   This function graphs the average angle line with the Std as a dashed
%   line in separate subplots using identical axes to make visual
%   comparisons of the different trials easier. Note that this figure has
%   little value from a publishing/results perspective.

% Calculate the binWidth being used.
angleLength = length(anglesMeanOld);
binWidth = 360/angleLength;
x = binWidth:binWidth:360;

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
% First/old dataset
subplot(1,2,1)
hold on
h = gca;
% Plot average angle using a solid line with differently colored, dashed
% standard deviation lines; add proper formatting.
plot(x,anglesMeanOld)
plot(x,anglesUpOld,'-.r')
plot(x,anglesDownOld,'-.r')
xlim([0 360])
ylim([yMin yMax])
set(h,'XTick',0:30:360);
title(strcat({'Old '},angleStr,' vs. Handlebar Angle (deg)'))
%            ^ Curly braces prevent trailing whitespace from being stripped
xlabel('Handlebar Angle (deg)')
ylabel(angleStr)
legend(strcat({'Average Std = '},num2str(mean(anglesStdOld))),'Location','best')
hold off

% Second/new dataset
subplot(1,2,2)
hold on
h = gca;
% Plot average angle using a solid line with differently colored, dashed
% standard deviation lines; add proper formatting.
plot(x,anglesMeanNew)
plot(x,anglesUpNew,'-.r')
plot(x,anglesDownNew,'-.r')
xlim([0 360])
ylim([yMin yMax])
set(h,'XTick',0:30:360);
title(strcat({'New '},angleStr,' vs. Handlebar Angle (deg)'))
xlabel('Handlebar Angle (deg)')
ylabel(angleStr)
legend(strcat({'Average Std = '},num2str(mean(anglesStdNew))),'Location','best')
hold off

end
