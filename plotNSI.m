% SMART Analysis Stack  Copyright (C) 2015-2016  Allen Hill
%  This program comes with ABSOLUTELY NO WARRANTY; for details, see 'LICENSE.txt'.
%  This is free software, and you are welcome to redistribute it
%  under certain conditions; for details, see 'LICENSE.txt'.

function [ fig ] = plotNSI( angles_r_old, angles_l_old, handlebar_angles_old, ...
                            angles_r_new, angles_l_new, handlebar_angles_new, ...
                            angleStr)
%plotNSI Plots both trial's NSI report in separate subplots.
%   This function graphs the average NSI line with the Std as a dashed
%   line in separate subplots using identical axes to make visual
%   comparisons of the different trials easier.

% Compute the NSI of both old and new sets of data
[ nsiMeanOld, nsiStdOld ] = nsi( angles_r_old, angles_l_old, handlebar_angles_old );
[ nsiMeanNew, nsiStdNew ] = nsi( angles_r_new, angles_l_new, handlebar_angles_new );

% Calculate the effective* binWidth being used. *Effective because the NSI
% length is determined by the single fasted revolution in the data we have.
angleLength = length(nsiMeanOld);
width = 360/angleLength;
x1 = width:width:360;

angleLength = length(nsiMeanNew);
width = 360/angleLength;
x2 = width:width:360;

% Create lines of the +/- standard deviation
nsiUpOld = nsiMeanOld + nsiStdOld;
nsiDownOld = nsiMeanOld - nsiStdOld;
nsiUpNew = nsiMeanNew + nsiStdNew;
nsiDownNew = nsiMeanNew - nsiStdNew;

% Calculate the extrema of the combined data and round to nearest multiple
% of 5 to make the axes of each graph the same.
yMax = ceil(max([nsiUpOld, nsiUpNew])/5)*5;
yMin = floor(min([nsiDownOld, nsiDownNew])/5)*5;

fig = figure;
% First/old dataset
subplot(1,2,1)
hold on
h = gca;
% Plot average angle using a solid line with differently colored, dashed
% standard deviation lines; add proper formatting.
plot(x1,nsiMeanOld)
plot(x1,nsiUpOld,'-.r')
plot(x1,nsiDownOld,'-.r')
xlim([0 360])
ylim([yMin yMax])
set(h,'XTick',0:30:360);
title(strcat({'Old '},angleStr,' vs. Handlebar Angle (deg)'))
%            ^ Curly braces prevent trailing whitespace from being stripped
xlabel('Handlebar Angle (deg)')
ylabel(strcat(angleStr,' (percent)'))
legend(strcat({'Average Std = '},num2str(mean(nsiStdOld))),'Location','best')
hold off

% Second/new dataset
subplot(1,2,2)
hold on
h = gca;
% Plot average NSI using a solid line with differently colored, dashed
% standard deviation lines; add proper formatting.
plot(x2,nsiMeanNew)
plot(x2,nsiUpNew,'-.r')
plot(x2,nsiDownNew,'-.r')
xlim([0 360])
ylim([yMin yMax])
set(h,'XTick',0:30:360);
title(strcat({'New '},angleStr,' vs. Handlebar Angle (deg)'))
xlabel('Handlebar Angle (deg)')
ylabel(strcat(angleStr,' (percent)'))
legend(strcat({'Average Std = '},num2str(mean(nsiStdNew))),'Location','best')
hold off

end
