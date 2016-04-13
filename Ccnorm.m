%% SMART Analysis Stack  Copyright (C) 2015-2016  Allen Hill
%  This program comes with ABSOLUTELY NO WARRANTY; for details, see 'LICENSE.txt'.
%  This is free software, and you are welcome to redistribute it
%  under certain conditions; for details, see 'LICENSE.txt'.

function [ ccnorm, lag ] = Ccnorm( angles_r, angles_l )
%Ccnorm Calculates the normalized cross-correlation coefficient.
% The normalized cross-correlation coefficient is a measure of symmetry,
% scored from 0 to 1, with higher values representing higher symmetry. The
% math for this function is based off the work done by
% Gouwanda et al. "Identifying Gait Asymmetry..."
% doi:10.1016/j.jbiomech.2010.12.013

angleLength = length(angles_l);
width = 360/angleLength;
% Shift the left joint angle by 180 to account for the 180 deg lag induced
% by the opposite hand/foot placement of the bike.
angles_l = circshift(angles_l',floor(angleLength/2))';

% Calculate cross-correlation of the left and right joint angles.
[cc, lag] = xcorr(angles_r,angles_l);
% Find the max of the cross-correlation and find the lag at which point the
% max occurs.
[~,I] = max(cc);
lag = lag(I);
lag = lag*width;

% Calculate the auto-correlation of each angle.
acr = xcorr(angles_r);
acl = xcorr(angles_l);

% Calculate the Ccnorm of the two angles.
ccnorm = max(cc)/sqrt(acr(angleLength)*acl(angleLength));

end
