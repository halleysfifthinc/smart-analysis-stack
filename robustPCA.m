% SMART Analysis Stack  Copyright (C) 2015-2016  Allen Hill
%  This program comes with ABSOLUTELY NO WARRANTY; for details, see 'LICENSE.txt'.
%  This is free software, and you are welcome to redistribute it
%  under certain conditions; for details, see 'LICENSE.txt'.

function [ origin, PC, Q ] = robustPCA( pointSet )
%RobustPCA A robust prinicpal component analysis method.
%   This method uses least median of squares for outlier detection and
%   optimized using foward search techniques. Based on the work of Liu
%   et al. doi:10.1016/j.cad.2008.10.012
%   Implemented by Allen Hill <AllenHill@letu.edu>

%   INPUT:
%       pointSet = The given point set to perform PCA on
%   OUTPUT:
%       origin = A point, the origin of the reference frame
%       PC = [e1,e2,e3] = The first, second, and third principal axes
%       Q = The set of points used in the PCA calculations

%% Setup
d = 5; % Octree depth
OT = OcTree(pointSet,'binCapacity',inf,'maxDepth',d,'maxSize',0);
k = 4; % Subset size
m = 45;
gamma = 1.25;
% Maximum times loop will run
MAX_ITERS = 100000;
r_max = 0;

%% Plot bins if desired
% figure
% boxH = OT.plot;
% cols = lines(OT.BinCount);
% doplot3 = @(p,varargin)plot3(p(:,1),p(:,2),p(:,3),varargin{:});
% for i = 1:OT.BinCount
%    set(boxH(i),'Color',cols(i,:),'LineWidth', 2)
%    doplot3(cn(OT.PointBins==i,:),'.','Color',cols(i,:))
% end
% binHasPts = ismember(1:OT.BinCount, OT.PointBins);
% set(boxH(~binHasPts),'Visible','off');
% axis image, view(3)
%%

[Q, Qind, PC] = lms(pointSet, k, OT);

% Calculate the max residual among all the points in Q
for n=1:k
    r_t = norm(Q(n,:) * PC(1,:)' - Q(n,:));
    if r_max<(gamma*r_t)
        r_max = gamma*r_t;
    end
end

i = 0;

% Copy the input and remove the points in Qind so they aren't accidentally
% added twice
c_rem = pointSet;
c_rem(Qind,:) =[];
breakflag = 0;

while ( i < MAX_ITERS )
    % Find the origin and principal components of the points in Q
    origin = mean(Q,1);
    PC = barepca(Q);

    %Pre-allocate for speed
    residuals = zeros(length(c_rem),1);

    % Calculate the residuals of the remaining points
    for n=1:length(c_rem)
        residuals(n) = norm(c_rem(n,:) * PC(1,:)' - c_rem(n,:));
    end

    [residuals, indices] = sort(residuals);

    % Get the indices of all points less than the maximum allowed residual
    tmp = find(residuals<r_max,m);
    % Try to add add these acceptable indices to Q, if not set the
    % breakflag
    try
        if(residuals(m) < r_max)
            Q = [Q; c_rem(indices(tmp),:)];
            c_rem(indices(tmp),:) = [];
        end
    catch
        breakflag = 1;
        Q = [Q; c_rem(indices(tmp),:)];
        c_rem(indices(tmp),:) = [];
    end

    % Break out of while loop
    if(breakflag)
        break;
    end
    i = i + 1;
end

end
