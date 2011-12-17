% vim: set tabstop=4 shiftwidth=4 :
function image_cells = get_image_features(CSV_FILE_PATH)
%
% Args:
%   CSV_FILE_PATH is the path to the CSV file describing which images to read.
%   
% Returns:
%   IMAGE_CELLS is a <# images> by 2 cell matrix, where column 1 mellin 2D
% version of an image and column 2 is the associated filename. Each row
% corresponds to one image.
%
% See also: mellin2d.m
%

addpath('../');

NUM_BINS = 6;

fid = fopen(CSV_FILE_PATH);
CSV_FILE_PATH
csv_data = textscan(fid, '%s %s', 'Delimiter', '|', 'CollectOutput', 1);
$csv_data = csv_data{1};
fclose(fid);

[numRows numCols] = size(csv_data);
image_cells = cell(numRows-1, 1 + numCols);

for row = 2:numRows
    fprintf('Image # %d\n', row - 1);
    cur_image = csv_data(row, :)

    % Record the processed Mellin 2D of the song
    image_path = cell2mat(cur_image(1, 1))
    mellin_mat = mellin2d(imread(image_path), NUM_BINS);
    image_cells{row-1, 1} = mellin_mat;

    % Record image name (ie im.jpg)
    image_cells{row-1, 2} = cur_image(1, 2);

    fprintf('Appended ??, %s\n', char(image_cells{row-1, 2}));
end

rmpath('../');
end
