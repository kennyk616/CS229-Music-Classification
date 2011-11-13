%test

CSV_FILE_NAME = 'test.csv';
NUM_BINS = 22;
NUM_FRAMES = 1000;

mfcc_cells = mfccShrink(CSV_FILE_NAME, NUM_BINS, NUM_FRAMES);


