% SMART Analysis Stack  Copyright (C) 2015-2016  Allen Hill
%  This program comes with ABSOLUTELY NO WARRANTY; for details, see 'LICENSE.txt'.
%  This is free software, and you are welcome to redistribute it
%  under certain conditions; for details, see 'LICENSE.txt'.

function [ angles, ideal_path, data_radius ] = CalculateAngles( r_data, l_data, PC )
%CalculateAngles Calculate the handlebar angle from top, rotating 
%clockwise based on the principal components
%   The data can be projected onto it's principal components, at which
%   point is is simple to calculate the angle of each point using inverse
%   tangent. The angles are then rotated to set vertical (GCS) as the
%   'zero' angle.

% Center data just in case
r_data = detrend(r_data,'constant');
l_data = detrend(l_data,'constant');

% Calculate radius using the average of the total distance from the center
% of rotation
r_radius = mean(sqrt(sum(abs(r_data).^2,2)));
l_radius = mean(sqrt(sum(abs(l_data).^2,2)));
data_radius = mean([r_radius,l_radius]);


% Project point at top-dead center of ideal path onto PC and use to
% calculate angle offset
radius_inPC = ([0,data_radius,0]*PC)';
offset = atan2d(radius_inPC(2),-radius_inPC(1));

% Create and project ideal path of marker
circle = [data_radius*cos((0:.01:360)-offset)',data_radius*sin((0:.01:360)-offset)',zeros(length(0:.01:360),1)];
ideal_path = (circle/PC');

%% Right
% Project data onto principal components
projected_r_data = (PC * r_data')';

% Calculate angles
% Use four-quadrant inverse tangent to calculate the angles, add 180 to
% shift range from 0 to 360, and shift the angles by the offset to correct
% for LCS => GCS.
r_angles = atan2d(projected_r_data(:,2),projected_r_data(:,1))+180+offset;

% Find any angles that have been moved out of range by offset angle.
[indices,~] = find(r_angles<0);
% Wrap the angles that are out of range.
r_angles(indices) = r_angles(indices)+360;
clear indices
[indices,~] = find(r_angles>360);
% Wrap the angles that are out of range.
r_angles(indices) = r_angles(indices)-360;

% Push the right angles up so that they can be averaged with the l_angles
r_angles = r_angles+180;
[indices,~] = find(r_angles>360);
r_angles(indices) = r_angles(indices)-360;

%% Left
% Project data onto principal components
projected_l_data = (PC * l_data')';

% Calculate angles
% Use four-quadrant inverse tangent to calculate the angles, add 180 to
% shift range from 0 to 360, and shift the angles by the offset to correct
% for LCS => GCS.
l_angles = atan2d(projected_l_data(:,2),projected_l_data(:,1))+180+offset;

% Find any angles that have been moved out of range by offset angle.
[indices,~] = find(l_angles<0);
% Wrap the angles that are out of range.
l_angles(indices) = l_angles(indices)+360;
clear indices
[indices,~] = find(l_angles>360);
% Wrap the angles that are out of range.
l_angles(indices) = l_angles(indices)-360;

% Average the two angles together and check for any points that averaged to
% ~180. Default to the left handlebar. The intent behind this is to
% increase the accuracy of the final calculated handlebar angle. If we use
% the data from both markers, the average will be slightly more accurate by
% averaging any possible jitter inherent in the data capture process.
% However, when the handlebars are near 0/360, the jitter may make the left
% angle near 360 and the right angle near 0 (or vice versa) which averaged
% makes approx. 180 inbetween ~0 and ~360. We default to the left angle
% because we use TDC of left handle as the reference datum.
tmp_angles = mean([r_angles,l_angles],2);
indices = find(abs(tmp_angles-r_angles)>90);
tmp_angles(indices) = l_angles(indices);
angles = tmp_angles;

end
