% vim: set tabstop=4 shiftwidth=4 :

clear all;
addpath('../');

% CSV file describing where the images are.
CSV_FILE_PATH = GetFullPath('../../py/images.csv');
% Generate and save the image features.
image_cells = get_image_features(CSV_FILE_PATH);
save image_cells image_cells;

rmpath('../');
