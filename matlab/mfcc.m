function MFCC_matrix = mfcc(song_file_name, NUM_BINS, NUM_FRAMES, NUM_COEFF, STEP_TIME)
% MFCC_MATRIX = MFCC(song_file_name, NUM_BINS, NUM_FRAMES, NUM_COEFF, STEP_TIME)
%
% song_file_name is a string specifying a .mp3 file.
% MFCC_MATRIX is the NUM_FRAMES-by-NUM_COEFF matrix of MFCC coefficients.
% NUM_FRAMES is how many frames (20 ms samples) of the song to use.
% NUM_BINS is how many mel frequency bins to map each frame spectrum to.
% NUM_COEFF is how many mel coefficients to keep (NUM_COEFF <= NUM_BINS).
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
%    NUM_FRAMES = 200;       % from IMECS 2010 paper (Li, Chan, Chun)
%    NUM_BINS = 20;          % 20 mel freq bins
%    NUM_COEFF = 15;         % keep 15 of the 20 coefficients
%    frame_time = 0.020;  % 20ms frames
%    STEP_TIME = 0.030;   % take a 20ms frame every 30ms (10ms gap)
%    OR
%    STEP_TIME = 0.010;   % take a 20ms frame every 10ms (50% overlap)
%
% Example:
% NUM_FRAMES = 200; NUM_BINS = 20; NUM_COEFF = 15; STEP_TIME = 0.010;
% song_file_name = 'songname.mp3';
% MFCC_matrix = mfcc(song_file_name, NUM_FRAMES, NUM_BINS, NUM_COEFF, STEP_TIME);
%
% Notes:
% - Can also support .wav or .au audio file.
% - For 30 sec audio file, analysis time of ~0.7 sec, given NUM_FRAMES=1000,
% NUM_BINS=20, NUM_COEFF=20, STEP_TIME=0.030.
%
% See also: melbankm.m, mp3read.m, GetFullPath.m
%

%%pathdir = GetFullPath('../music/');
%[s, fs] = mp3read([pathdir song_file_name]);
[slength, channels] = mp3read(song_file_name, 'size');
offset = floor(slength/4);
[s, fs] = mp3read(song_file_name, [offset slength-offset]);


% tic; fprintf('Analysis time...'); 

% format = song_file_name(end-1:end);
% 
% if (strcmp(format, 'av')) 
%     [s, fs] = wavread(song_file_name);
% elseif (strcmp(format, 'au'))
%     [s, fs] = auread(song_file_name);
% elseif (strcmp(format, 'p3'))
%     [s, fs] = mp3read(song_file_name);
% else 
%     error('Wrong input. Use a .wav or .au audio file');
% end

% NUM_FRAMES = 1000;
% NUM_BINS = 20;                 % # mel filters (bins)
fft_len = 512;              % length of fft
frame_time = 0.020;         % # seconds/frame
frame_len = floor(fs*frame_time);  % # samples/frame
% STEP_TIME = 0.010;          % # seconds/frame step
step_len = floor(fs*STEP_TIME);    % # samples/frame step

MFCC_matrix = zeros(NUM_FRAMES, NUM_COEFF);

window = hamming(frame_len);
stop = 1+floor(fft_len/2);  % 257

[x, y] = size(s);
begin = floor(x/2);

for i = 1:NUM_FRAMES
    first = begin + (i-1)*step_len + 1;
    last = begin + (i-1)*step_len + frame_len;
    f = s(first:last);
    %in song 67, Sam Hart - Mario Kart Love Song
    %f is a vertical vector for some reason. 
    %in the rest f is a horizontal vector. I added this as a quick fix
    %but we should prob investigate
    heightF = size(f, 1);
    widthF = size(f, 2);
    if (heightF > widthF)
        f = f.*window;
        fprintf('f is a vertical vector\n');
    else
        f = f'.*window;
    end
    f = fft(f, frame_len);
    mel_bins = melbankm(NUM_BINS, fft_len, fs);
    f = abs(f(1:stop)).^2; 
    m = log10(mel_bins*f);
    m = dct(m);          % dim(m): NUM_BINS x 1
    m = m(1:NUM_COEFF);
    MFCC_matrix(i, :) = m';
end

% t = toc; fprintf('%5.2f sec\n',t);

end
