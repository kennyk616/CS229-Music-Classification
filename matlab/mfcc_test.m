%test
clear all;

CSV_FILE_PATH = GetFullPath('../py/output.csv');
NUM_BINS = 22;
NUM_FRAMES = 200;
NUM_COEFF = 15;
STEP_TIME = 0.02;

mfcc_cells = get_mfcc_features(CSV_FILE_PATH, NUM_BINS, NUM_FRAMES, NUM_COEFF, STEP_TIME);
save mfcc_test_data mfcc_cells;

