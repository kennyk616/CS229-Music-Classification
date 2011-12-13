function P = logpolar(I)
% P = LOGPOLAR(I) converts a 2D image to log-polar coordinates
%
% The log-polar coordinate space is used by the 2D Mellin transform
% in image feature extraction. The interpolation method used
% is bilinear interpolation.
%
% See also: mellin2d.m, mellin_test.m
%

[nrows, ncols] = size(I);
P = zeros(nrows, ncols);
theta_step = 2*pi/ncols;  % how much to increment theta
base = 10^(log10(nrows)/nrows);  % log-polar base
halfrows = nrows/2; halfcols = ncols/2;
for i = 1:nrows
    theta = theta_step;
	for j = 1:ncols
		r = base^i-1;
		theta = theta + theta_step;
		x = round(r*cos(theta)+halfcols);
		y = round(r*sin(theta)+halfrows);
        if ((x>0) && (y>0) && (x<ncols) && (y<nrows))
            P(i,j) = I(y,x);
        end
	end
end

