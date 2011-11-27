%test
clear all;

%training data
CSV_FILE_PATH_training = GetFullPath('../py/train400.csv');
CSV_FILE_PATH_testing = GetFullPath('../py/test400.csv');
NUM_BINS = 22;
NUM_FRAMES = 200;
NUM_COEFF = 15;
STEP_TIME = 0.02;

mfcc_cells_training400 = get_mfcc_features(CSV_FILE_PATH_training, NUM_BINS, NUM_FRAMES, NUM_COEFF, STEP_TIME);
save mfcc_training_data400 mfcc_cells_training400;

mfcc_cells_testing400 = get_mfcc_features(CSV_FILE_PATH_testing, NUM_BINS, NUM_FRAMES, NUM_COEFF, STEP_TIME);
save mfcc_testing_data400 mfcc_cells_testing400;




