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

n = 1;
revs = 0;
invalid_revs = [];
%Interpolate each revolution to be a standard length
while n < (length(pks)-2)
  %Get the index range and length of the revolution if the revolution is
  %more than 50 frames long (validity check: 50 frames at 100 fps is pretty
  %fast) and it begins and ends within 2.5% of 0 deg or 360 deg (to ensure 
  %that a full forward revolution was made, not a reverse revolution, or 
  %some partial reverse in direction
  if (locs(n+1)-(locs(n)+1))>50 && handlebar_angles(locs(n)+1)<9 ...
          && handlebar_angles(locs(n+1))>351
      revs = revs+1;
      x{revs} = (locs(n)+1):locs(n+1);
      xLength(revs) = length(x{revs});
      tmp_angles_l = circshift(angles_l(x{revs}),floor(xLength(revs)/2));
      tmp_angles_r = angles_r(x{revs});
      tmp_l{revs} = interp1(handlebar_angles(x{revs}),tmp_angles_l,linspace(0,360,standard_length),'linear','extrap');
      tmp_r{revs} = interp1(handlebar_angles(x{revs}),tmp_angles_r,linspace(0,360,standard_length),'linear','extrap');
  end
  n = n+1;
end

%%Perform NSI calculation for each revolution
%Start after the first peak and end at the second to last peak. This
%ensures that no partial revolutions due to the beginning/ending of the
%data are included.
for n=1:revs
  min_r = min(tmp_r{n});
  min_l = min(tmp_l{n});
  max_r = max(tmp_r{n});
  max_l = max(tmp_l{n});

  range_r = max_r - min_r;
  range_l = max_l - min_l;
  
  % Skip a revolution if the range is zero, will cause a divide by zero
  % error in the norm_r or norm_l calculations
  if range_r == 0 || range_l == 0
    invalid_revs = [invalid_revs, n];
    nsi_a(n,1:standard_length) = 0;
    continue
  else
    %Calculate the NSI for this revolution
    norm_r = (tmp_r{n} - min_r)./range_r+1;
    norm_l = (tmp_l{n} - min_l)./range_l+1;
    nsi_a(n,:) = ((norm_r - norm_l)./((norm_r + norm_l).*.5)).*100;
  end
end

% Don't use invalid revolutions
if length(invalid_revs) ~= 0
  nsi_a(invalid_revs,:) = [];
end
nsiStd_final = std(abs(nsi_a),1);
nsiMean_final = mean(nsi_a,1);

end
