% SMART Analysis Stack  Copyright (C) 2015-2016  Allen Hill
%  This program comes with ABSOLUTELY NO WARRANTY; for details, see 'LICENSE.txt'.
%  This is free software, and you are welcome to redistribute it
%  under certain conditions; for details, see 'LICENSE.txt'.

function [ limits ] = lims( data )
%lims Calculates the lengths of the sides of a bounding box of the data

limits = abs(max(data,[],1) - min(data,[],1));

end
