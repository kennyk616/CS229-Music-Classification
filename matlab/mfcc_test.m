%test
clear all;
CSV_FILE_NAME = '/afs/ir.stanford.edu/users/k/e/kennykao/cs229/CS229-Music-Classification/py/output.csv';
NUM_BINS = 22;
NUM_FRAMES = 1000;
NUM_COEFF = 15;
STEP_TIME = 20;


fid = fopen(CSV_FILE_NAME);
csv_data = textscan(fid, '%s %s %s %s', 'Delimiter', ',', 'CollectOutput', 1);
csv_data = csv_data{1};
fclose(fid);

numRows = size(csv_data, 1);
mfcc_cells = cell(numRows, 2);

row = 2;

cur_song = csv_data(row, :);
song_file_name = cell2mat(cur_song(1, 1));
    
    