% SMART Analysis Stack  Copyright (C) 2015-2016  Allen Hill
%  This program comes with ABSOLUTELY NO WARRANTY; for details, see 'LICENSE.txt'.
%  This is free software, and you are welcome to redistribute it
%  under certain conditions; for details, see 'LICENSE.txt'.

function [ angles ] = AverageAngles( data )
%AverageAngles !!DEPRECATED!!
% This was used when the angles were calculated differently, the angles fed
% to this were in a differential form. Left for posterity sake.

angles = mean(data,2);
angles = cumsum(angles);

% Wrap angles from 0 - 360 degrees
for n=1:length(angles)
    while angles(n)<360
        angles(n) = angles(n) + 360;
    end
    while angles(n)>360
        angles(n) = angles(n) - 360;
    end
end

end
