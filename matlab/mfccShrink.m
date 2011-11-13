function mfcc_cells = mfccShrink(CSV_FILE_NAME, NUM_BINS, NUM_FRAMES)


csv_data = csvread(CSV_FILE_NAME);

numRows = size(csv_data, 1);

mfcc_cells = cell(numRows, 2);

for row = 1 : numRows
    cur_song = csv_data(row, :);
    song_file_name = cur_song(1, 1);
    mfcc = MFCC(song_file_name, NUM_BINS, NUM_FRAMES);  
    mfcc_cells{row, 1} = mean(mfcc);
    mfcc_cells{row, 1} = cov(mfcc);
end

end