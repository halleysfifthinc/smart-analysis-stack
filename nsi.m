%% SMART Analysis Stack  Copyright (C) 2015-2016  Allen Hill
%  This program comes with ABSOLUTELY NO WARRANTY; for details, see 'LICENSE.txt'.
%  This is free software, and you are welcome to redistribute it
%  under certain conditions; for details, see 'LICENSE.txt'.

function [ nsiMean_final, nsiStd_final ] = nsi( angles_r, angles_l, handlebar_angles )
%nsi Calculates the normalized symmetry index between right and left angles
%   The normalized symmetry index is a measure of symmetry that gives a
%   symmetry score vs handlebar angles, and therefore gives a different and
%   more granular perspective of symmetry analysis when compared with
%   Ccnorm. The math for this function is based off the work done by
%   Gouwanda et al. "Identifying Gait Asymmetry..."
%   doi:10.1016/j.jbiomech.2010.12.013

%%Find the points at which the handlebars finish a revolution
%Find any peaks within the handlebar angle data
[pks,locs] = findpeaks(abs(diff(handlebar_angles)));
% Only use the peaks that are above 300, which are likely to be complete
% revolutions
x = find(pks>300);
pks = pks(x);
locs = locs(x);
clear x
standard_length = 360;
% TODO: Add check for full revolution (in cases where they are wobbling
% right around TDC, will introduce multiple peaks above 300)
revs = length(pks)-2;

%Pre-allocation for speed
index{1,revs} = [];
final_index{1,revs} = [];
x{1,revs} = [];
xLength = zeros(1,revs);

%Interpolate each revolution to be a standard length
for n=1:revs
  %Get the index range and length of the revolution
  x{n} = (locs(n)+1):locs(n+1);
  xLength(n) = length(x{n});
  tmp_angles_l = circshift(angles_l(x{n}),floor(xLength(n)/2));
  tmp_angles_r = angles_r(x{n});
  tmp_l{n} = interp1(handlebar_angles(x{n}),tmp_angles_l,linspace(0,360,standard_length),'linear','extrap');
  tmp_r{n} = interp1(handlebar_angles(x{n}),tmp_angles_r,linspace(0,360,standard_length),'linear','extrap');
end

%%Perform NSI calculation for each revolution
%Start after the first peak and end at the second to last peak. This
%ensures that no partial revolutions due to the beginning/ending of the
%data are included.
for n=1:revs
  %Get the index range and length of the revolution
%   x{n} = (locs(n)+1):locs(n+1);
%   xLength(n) = length(x{n});
  %Copy the data from the left and right input angles for this revolution
  %and shift the left
%   tmp_l = circshift(angles_l(x{n}),floor(xLength(n)/2));
%   tmp_r = angles_r(x{n});

  min_r = min(tmp_r{n});
  min_l = min(tmp_l{n});
  max_r = max(tmp_r{n});
  max_l = max(tmp_l{n});

  range_r = max_r - min_r;
  range_l = max_l - min_l;

  %Calculate the NSI for this revolution
  for m=1:standard_length
    norm_r = (tmp_r{n}(m) - min_r)/range_r+1;
    norm_l = (tmp_l{n}(m) - min_l)/range_l+1;
    index{n}(m,1) = ((norm_r - norm_l)/((norm_r + norm_l)*.5))*100;
  end
end

% %Interpolate the NSI of each revolution to be a standard length, the length
% %of the shortest revolution
% for n=1:length(x)
%   index{n} = interp1(handlebar_angles(x{n}),index{n},linspace(0,360,standard_length),'linear','extrap');
% end

%Pre-allocation for speed
%num = length(x);
nsiStd = zeros(revs,standard_length);
nsiMean = zeros(revs,standard_length);

%Get the mean and Std of the interpolated NSI's
for n=1:revs
  for m=1:standard_length
    nsiStd(n,m) = index{n}(m);
    nsiMean(n,m) = index{n}(m);
  end
end

nsiStd_final = std(abs(nsiStd),1);
nsiMean_final = mean(nsiMean,1);

end
