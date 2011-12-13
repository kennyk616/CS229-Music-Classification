% 2D mellin transform for image feature extraction
function MELLIN_matrix = mellin2d(img_file_name)
% 2D Mellin-cepstrum feature extraction algorithm for images
%
% See also: logpolar.m, mellin_test.m, mfcc.m
%


% img_file_name = 'nature1.jpg';
I_orig = imread(img_file_name);
I = rgb2gray(I_orig);
I = fft2(I);  % 2D DFT
[h, w] = size(I);
H = hpf2d(h, w);
I = H.*abs(I);  % convolve HPF w/ real FFT of I
I = log(abs(I));
% -- mellin transform here -- %%
P = logpolar(I);  % convert cartesian to log-polar coords
P_ift = ifft2(P);
P_ifta = abs(P_ift);
MELLIN_matrix = P_ifta;  % temp for running fcn
% figure, imshow(P_iftabs);
% figure, imshow(P_iftabs.*500);
% figure, imshow(I_orig);
