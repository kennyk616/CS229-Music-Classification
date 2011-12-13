function H = hpf2d(ht, wd)
% H = HPF2D(HT, WD) generates a high-pass filter window of the given size.
%
% See also: mellin2d.m
%

ht = 650; wd = 650;
res_ht = 1/(ht-1); res_wd = 1/(wd-1);
eta = cos(pi*(-0.5:res_ht:0.5));
neta = cos(pi*(-0.5:res_wd:0.5));
X = eta'*neta;
H = (1.0-X).*(2.0-X);
