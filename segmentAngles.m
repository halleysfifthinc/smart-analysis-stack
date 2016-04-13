%% SMART Analysis Stack  Copyright (C) 2015-2016  Allen Hill
%  This program comes with ABSOLUTELY NO WARRANTY; for details, see 'LICENSE.txt'.
%  This is free software, and you are welcome to redistribute it
%  under certain conditions; for details, see 'LICENSE.txt'.

function [ anglesMean, anglesStd, anglesVar ] = segmentAngles( angles, binAngleIndices )
%                                          ^, angles_raw for output if
%                                          necessary/desired for debugging

% Preallocate for speed in the for loop
num = length(binAngleIndices);
angles_raw{1,num} = [];
anglesStd = zeros(1,num);
anglesVar =  zeros(1,num);
anglesMean = zeros(1,num);

% Grab all the joint angles within a specified range (determined by the
% binWidth variable) as found in binAngleIndices, then find the Std, Var,
% and Mean of the angles.
for n=1:num
    angles_raw{n} = angles(binAngleIndices{n});
    anglesStd(n) = std(angles_raw{n});
    anglesVar(n) = var(angles_raw{n});
    anglesMean(n) = mean(angles_raw{n});
end

end
