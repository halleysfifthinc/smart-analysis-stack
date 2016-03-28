% SMART Analysis Stack  Copyright (C) 2015-2016  Allen Hill
%  This program comes with ABSOLUTELY NO WARRANTY; for details, see 'LICENSE.txt'.
%  This is free software, and you are welcome to redistribute it
%  under certain conditions; for details, see 'LICENSE.txt'.

function [ fig ] = plotCcnorm( angles_r_old, angles_l_old, angles_r_new, angles_l_new, angleStr )
%VisCompSymmetry A visual and mathematical (w/ Ccnorm) comparison of the
%right and left joint angles.

% Calculate the binWidth being used.
angleLength = length(angles_l_old);
binWidth = 360/angleLength;
x = binWidth:binWidth:360;

% Shift the left joint angle by 180 to account for the 180 deg lag induced
% by the opposite hand/foot placement of the bike.
angles_l_old = circshift(angles_l_old',floor(angleLength/2))';
[ccnorm_old, ~] = Ccnorm(angles_r_old,angles_l_old);

angles_l_new = circshift(angles_l_new',floor(angleLength/2))';
[ccnorm_new, ~] = Ccnorm(angles_r_new,angles_l_new);

% Calculate the extrema of the combined data and round to nearest multiple
% of 5 to make the axes of each graph the same.
yMax = ceil(max([angles_l_old, angles_r_old, angles_r_new, angles_l_new])/5)*5;
yMin = floor(min([angles_l_old, angles_r_old, angles_r_new, angles_l_new])/5)*5;

fig = figure;
% First/old dataset
subplot(1,2,1)
hold on
h = gca;
% Plot left and right angles using different colors, formatting
plot(x,angles_l_old,'b')
plot(x,angles_r_old,'r')
plot(1,1,'w')
xlim([0 360])
ylim([yMin yMax])
set(h,'XTick',0:30:360);
title(angleStr)
xlabel('Handlebar Angle (deg)')
ylabel(strcat(angleStr,' (deg)'))
legend('Left','Right',char(strcat({'Cc_n_o_r_m = '},num2str(ccnorm_old,6))),'Location','best')
hold off

% Second/new dataset
subplot(1,2,2)
hold on
h = gca;
% Plot left and right angles using different colors, formatting
plot(x,angles_l_new,'b')
plot(x,angles_r_new,'r')
plot(1,1,'w')
xlim([0 360])
ylim([yMin yMax])
set(h,'XTick',0:30:360);
title(angleStr)
xlabel('Handlebar Angle (deg)')
ylabel(strcat(angleStr,' (deg)'))
legend('Left','Right',char(strcat({'Cc_n_o_r_m = '},num2str(ccnorm_new,6))),'Location','best')
hold off

end
