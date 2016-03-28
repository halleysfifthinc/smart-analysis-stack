% SMART Analysis Stack  Copyright (C) 2015-2016  Allen Hill
%  This program comes with ABSOLUTELY NO WARRANTY; for details, see 'LICENSE.txt'.
%  This is free software, and you are welcome to redistribute it
%  under certain conditions; for details, see 'LICENSE.txt'.

function [ W ] = barepca( cn )
%pca Principal component analysis using EVD
%   Principal component analysis finds the principal axes of
%   multidimensional data by maximizing variation along each axis. Here is
%   a link for a great conceptual explanation: http://setosa.io/ev/principal-component-analysis/
%   This function is called barepca because it only computes and returns the
%   principle components, and does not perform any other calculations. For
%   more information about what the math here is doing, check out a linear
%   algebra textbook (maybe) or look it up on Wikipedia.

cn = cn';

cn = cn - repmat(mean(cn,2),1,size(cn,2));

[W, ~] = eig(cov(cn'));

W = W(:,end:-1:1);
W = W';

end
