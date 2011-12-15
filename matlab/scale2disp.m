function I_scale = scale2disp(I)
% I_SCALE = SCALE2DISP(I) scales I for imshow display.
%
% I is matrix of values. I_SCALE is displayable in range
% [0, 255] for imshow().
%
% See also: imshow
%

scale = 255;
minval = min(min(I));
maxval = max(max(I));
range = maxval - minval;
scale_factor = scale/range;
I_scale = (I-minval).*scale_factor;

