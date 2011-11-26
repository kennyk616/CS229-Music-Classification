function mfcc_audio_test
% Testing various audio formats (for mfcc.m)
% 10 seconds read from each song and played out

NUM_SEC = 10;

% Test reading .wav file
song_file_name = 'tlove.wav';
slength = wavread(song_file_name, 'size');
offset = floor(slength(1,1)/3);
[~, fs] = wavread(song_file_name, 1);
[s, fs] = wavread(song_file_name, [offset offset+fs*NUM_SEC]);
ap = audioplayer(s, fs);
play(ap);
pause on
pause(10);
pause off
% Test reading .au file
song_file_name = 'blues.00000.au';
slength = auread(song_file_name, 'size');
offset = floor(slength(1,1)/3);
[~, fs] = auread(song_file_name, 1);
[s, fs] = auread(song_file_name, [offset offset+fs*NUM_SEC]);
ap = audioplayer(s, fs);
play(ap);
pause on
pause(10);
pause off
% Test reading .mp3 file
song_file_name = 'dfd.mp3';
slength = mp3read(song_file_name, 'size');
offset = floor(slength(1,1)/3);
[~, fs] = mp3read(song_file_name, [offset offset+1]);
[s, fs] = mp3read(song_file_name, [offset offset+fs*NUM_SEC]);
ap = audioplayer(s, fs);
play(ap);
pause on
pause(10);
pause off
