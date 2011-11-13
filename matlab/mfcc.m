function MFCC_matrix = mfcc(filename, nbins, nframes, ncoeff, step_time)
% MFCC_MATRIX = MFCC(FILENAME, NBINS, NFRAMES, NCOEFF, STEP_TIME)
%
% FILENAME is a string specifying a .mp3 file.
% MFCC_MATRIX is the nframes-by-ncoeff matrix of MFCC coefficients.
% NFRAMES is how many frames (20 ms samples) of the song to use.
% NBINS is how many mel frequency bins to map each frame spectrum to.
% NCOEFF is how many mel coefficients to keep (NCOEFF <= NBINS).
% STEP_TIME is how often (in seconds) to capture a 20ms frame.
%
%      - Mel-Frequency Ceptrum Coefficients -
% 1. Take the Fourier Transform of a 20-30ms windowed excerpt of a signal.
% 2. Map powers of spectrum onto mel scale, using triangular overlapping
% windows.
% 3. Take the logs of the powers at each of the mel frequencies.
% 4. Take the Discrete Cosine Transform of the list of mel log powers (as
% if it were a signal).
% 5. The MFCCs are the amplitudes of the resulting spectrum.
%
% Heuristics:
%    nframes = 200;       % from IMECS 2010 paper (Li, Chan, Chun)
%    nbins = 20;          % 20 mel freq bins
%    ncoeff = 15;         % keep 15 of the 20 coefficients
%    frame_time = 0.020;  % 20ms frames
%    step_time = 0.030;   % take a 20ms frame every 30ms (10ms gap)
%    OR
%    step_time = 0.010;   % take a 20ms frame every 10ms (50% overlap)
%
% Example:
% nframes = 200; nbins = 20; ncoeff = 15; step_time = 0.010;
% filename = 'songname.mp3';
% MFCC_matrix = mfcc(filename, nframes, nbins, ncoeff, step_time);
%
% Notes:
% - Can also support .wav or .au audio file.
% - For 30 sec audio file, analysis time of ~0.7 sec, given nframes=1000,
% nbins=20, ncoeff=20, step_time=0.030.
%
% See also: melbankm.m, mp3read.m, GetFullPath.m
%

pathdir = GetFullPath('music\');
[s, fs] = mp3read([pathdir filename]);

% tic; fprintf('Analysis time...'); 

% format = filename(end-1:end);
% 
% if (strcmp(format, 'av')) 
%     [s, fs] = wavread(filename);
% elseif (strcmp(format, 'au'))
%     [s, fs] = auread(filename);
% elseif (strcmp(format, 'p3'))
%     [s, fs] = mp3read(filename);
% else 
%     error('Wrong input. Use a .wav or .au audio file');
% end

% nframes = 1000;
% nbins = 20;                 % # mel filters (bins)
fft_len = 512;              % length of fft
frame_time = 0.020;         % # seconds/frame
frame_len = floor(fs*frame_time);  % # samples/frame
% step_time = 0.010;          % # seconds/frame step
step_len = floor(fs*step_time);    % # samples/frame step

MFCC_matrix = zeros(nframes, nbins);

window = hamming(frame_len);
stop = 1+floor(fft_len/2);  % 257

for i = 1:nframes
    first = (i-1)*step_len + 1;
    last = (i-1)*step_len + frame_len;
    f = s(first:last);
    f = f.*window;
    f = fft(f, frame_len);
    mel_bins = melbankm(nbins, fft_len, fs);
    f = abs(f(1:stop)).^2;
    m = log10(mel_bins*f);
    m = dct(m);          % dim(m): nbins x 1
    m = m(1:ncoeff);
    MFCC_matrix(i, :) = m';
end

% t = toc; fprintf('%5.2f sec\n',t);

end
