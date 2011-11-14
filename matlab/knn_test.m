load mfcc_test_data;

%path of the music file
input_dir_path = '../testing music/';
dir_listing = dir(input_dir_path);

input_full_path = GetFullPath(input_dir_path);

NUM_BINS = 22;
NUM_FRAMES = 200;
NUM_COEFF = 15;
STEP_TIME = 0.02;

testCell = cell(1, 2);
num_files = size(dir_listing, 1);
classified = cell(num_files, 2);
offset = 0;
index = 0;
k = 7;
field_num = 3; %% 1: title, 2: artist, 3: genre

for i = 1:num_files
    file_name = dir_listing(i).name;
    file_name_len = length(file_name);
    if file_name_len > 4 && strcmp(file_name(file_name_len - 2: file_name_len), 'mp3') 
        index = index + 1;
        mfcc_matrix = mfcc([input_full_path file_name], NUM_BINS, NUM_FRAMES, NUM_COEFF, STEP_TIME);
        testCell{1, 1} = mean(mfcc_matrix);
        testCell{1, 2} = cov(mfcc_matrix);

        class = knn(mfcc_cells, testCell, field_num, k);
        classified{index, 1} = file_name;
        classified{index, 2} = class;
    end
end

fprintf('classification:\n');
fprintf('-------------------------\n');
for i = 1 : index
    fprintf('title: %s, genre: %s\n', classified{i,1}, classified{i,2}{1});
end
