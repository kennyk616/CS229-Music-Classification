function mfcc_cells = get_mfcc_features(CSV_FILE_PATH, NUM_BINS, NUM_FRAMES, NUM_COEFF, STEP_TIME)
% MFCC_CELLS = GET_MFCC_FEATURES(CSV_FILE_NAME, NUM_BINS, NUM_FRAMES,
%              NUM_COEFF, STEP_TIME);
%
% MFCC_CELLS is a <# songs> by 2 cell matrix, where column 1 is the means
% of the mfcc and column 2 is the covariances of the mfcc. Each row is the
% mfcc data of a song.
%
% Heuristics:
%   NUM_BINS = 20; NUM_COEFF = 15; STEP_TIME = 0.010;
%
% See also: mfcc.m, mp3tags_to_csv.py
%

fid = fopen(CSV_FILE_PATH);
csv_data = textscan(fid, '%s %s %s %s', 'Delimiter', ',', 'CollectOutput', 1);
csv_data = csv_data{1};
fclose(fid);

[numRows numCols] = size(csv_data);
mfcc_cells = cell(numRows-1, 1 + numCols);

for row = 2:numRows
    cur_song = csv_data(row, :);
    song_file_name = cell2mat(cur_song(1, 1));
    mfcc_mat = mfcc(song_file_name, NUM_BINS, NUM_FRAMES, NUM_COEFF, STEP_TIME);  
    mfcc_cells{row-1, 1} = mean(mfcc_mat);
    mfcc_cells{row-1, 2} = cov(mfcc_mat);
    for col = 3:numCols + 1
        mfcc_cells{row-1, col} = csv_data(row, col-1);
    end
end

end