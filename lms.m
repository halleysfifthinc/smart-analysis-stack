%% SMART Analysis Stack  Copyright (C) 2015-2016  Allen Hill
%  This program comes with ABSOLUTELY NO WARRANTY; for details, see 'LICENSE.txt'.
%  This is free software, and you are welcome to redistribute it
%  under certain conditions; for details, see 'LICENSE.txt'.

function [ Q, Qind, PC ] = lms( cn, k, OT )
%lms Performs a least median of squares
%   Least median of squares improves upon the sum of least squares by
%   providing a higher breakdown point. The math for least median of
%   squares is based on the work of Liu et al. doi:10.1016/j.cad.2008.10.012
%   This is a direct implementation of the pseudocode on pg 9-10.
%   Implemented by Allen Hill <AllenHill@letu.edu>


ITERS = 5000; % Number of iterations in least median calculation
r_min = inf; % Beginning minimum residual

% Only use the bins that actually have points within them
binHasPts = ismember(1:OT.BinCount, OT.PointBins);
binswPts = sort(find(binHasPts));
clear binHasPts

% Pre-allocate for speed
Fp = zeros(length(binswPts),3);
numPtsInBin = zeros(length(binswPts),1);

% Calculate the feature point of the points within the bin
for n=1:length(binswPts)
    tmp = find(OT.PointBins==binswPts(n)); % Indices of data points in bin binswPts(n)
    numPtsInBin(n) = length(tmp); % Density
    Fp(n,:) = mean(cn(tmp,:),1); % Feature point of bin, mean of all points in bin
end

% Pre-allocation for speed
c_temp = zeros(4,3);
residuals = zeros(length(binswPts),1);
c_temp_ind = zeros(4,1);

for T = 1:ITERS
    % Sample a set number of points uniformly from all of the bins available
    selectedBins = binswPts(gendist(numPtsInBin',k,1));
    for i=1:k
        pntIndices = find(OT.PointBins==selectedBins(i));
        c_temp_ind(i) = randsample(pntIndices,1);
        c_temp(i,:) = cn(c_temp_ind(i),:);
    end
    PC = barepca(c_temp);

    % Compute residuals
    for n=1:length(binswPts)
        residuals(n) = norm(Fp(n,:) * PC(1,:)' - Fp(n,:));
    end

    r_half = median(residuals);

    % If the median of the residuals of this set are better than the
    % previous best, use these points instead.
    if (r_half < r_min)
        r_min = r_half;
        Q = c_temp;
        Qind = c_temp_ind;
    end

end
end
