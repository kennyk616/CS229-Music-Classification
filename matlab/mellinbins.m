function B = mellinbins(I, BINS)
% B = MELLINBINS(I, BINS) bins the square matrix I according to a non-uniform DFT log grid.
%
% I is the square matrix to be binned (Ex. I = log(abs(fft(I_grayimg))))
% BINS is the # of bins in one direction
% B is the BINS x BINS square matrix where each pixel is the average of its
% corresponding cell of pixels from applying the non-uniform log grid to I.
%
% See also: mellin2d.m
% 
% Referenced from The Computer Journal 2011 paper, S. Cakir & E. Cetin
%


num_bins = BINS;  % # of bins in one direction
num_logbins = BINS/2;  % # unique log intervals

B = zeros(num_bins);  % num_bins x num_bins binned output matrix

midI = length(I)/2;

maxlog = midI;
logvals = round(logspace(0, log10(maxlog), num_logbins));
logvals = [0 logvals];

% get indices (6x2 for start and stop of each bin)
vertidx = zeros(num_bins, 2); % horiz idx is same
for i = 1:num_logbins
    inedge = logvals(i);
    outedge = logvals(i+1);
    vertidx(num_logbins-i+1, :) = [midI-outedge+1 midI-inedge];
    vertidx(num_logbins+i, :) = [midI+inedge+1 midI+outedge];
end

% index into I to get cells of grid, average each cell for B value
horiidx = vertidx;
for i = 1:num_bins
    vstart = vertidx(i,1); vstop = vertidx(i,2);
    for j = 1:num_bins
        hstart = horiidx(j,1); hstop = horiidx(j,2);
        cellgrid = I(vstart:vstop, hstart:hstop);
        avg = mean(mean(cellgrid));
        B(i,j) = avg;
    end
end

