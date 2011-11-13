load mfcc_test_data;

%path of the music file
input_file_path = '../music/jack.mp3';

NUM_BINS = 22;
NUM_FRAMES = 1000;
NUM_COEFF = 15;
STEP_TIME = 0.02;

testCell = cell(1, 2);

mfcc_matrix = mfcc(input_file_path, NUM_BINS, NUM_FRAMES, NUM_COEFF, STEP_TIME);
testCell{1, 1} = mean(mfcc_matrix);
testCell{1, 2} = cov(mfcc_matrix);
field_num = 3; %% 1: title, 2: artist, 3: genre
k = 5;




class = knn(mfcc_cells, testCell, field_num, k);

