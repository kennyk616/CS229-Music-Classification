% 2D mellin transform for image feature extraction
function MELLIN_matrix = mellin2d(I, NUM_BINS)
% 2D Mellin-cepstrum feature extraction algorithm for images
%
% I is a NxN square grayscale matrix, where N = 2^r
% NUM_BINS is the # of bins in one direction, must be even
% MELLIN_matrix is the NUM_BINSxNUM_BINS square matrix
%
% Example:
%   img_file_name = 'nature1.jpg';
%   I = imread(img_file_name);
%   NUM_BINS = 8;  
%   MELLIN_matrix = mellin2d(I, NUM_BINS);
%
% See also: logpolar.m, mellinbins.m, mellin_test.m
%

% frequency domain
I = rgb2gray(I);  % uint8 to double
I = im2double(I);
I = fft2(I);  % 2D DFT

% mellin bins
I = log(abs(I));
B = mellinbins(I, NUM_BINS);  

% log polar coordinates
P = logpolar(B);  
P = dct2(P);
MELLIN_matrix = P;

