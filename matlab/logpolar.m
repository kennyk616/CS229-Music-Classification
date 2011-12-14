function P = logpolar(I)
% P = LOGPOLAR(I) converts a 2D image to log-polar coordinates
%
% The log-polar coordinate space is used by the 2D Mellin transform
% in image feature extraction. The interpolation method used
% is bilinear interpolation. The radius of the inscribed circle is taken.
%
% Note: currently hardcoded to 64 x 64 images for speed, easily generalized
%
% See also: mellin2d.m, mellin_test.m
%

[nrows, ncols] = size(I);
% theta_step = 2*pi/nrows;
theta_step = 0.099;  % hardcoded for 64x64 P
% rho_max = ceil(2*pi/theta_step);
rho_max = 64;
center = [nrows/2 ncols/2];
d = min([ncols-center(1) center(1)-1 nrows-center(2) center(2)-1]);

Theta = 0:theta_step:2*pi;
Rho = logspace(0, log10(d), rho_max)';
X = round(Rho*cos(Theta) + center(1));
Y = round(Rho*sin(Theta) + center(2));
P = interp2(I, X, Y, 'linear');

