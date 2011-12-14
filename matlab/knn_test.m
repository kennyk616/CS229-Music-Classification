load mfcc_training_data400;
load mfcc_testing_data400;

mfcc_cells = mfcc_cells_training400;

%path of the music file
num_files = size(mfcc_cells_testing400, 1);
classified = cell(num_files, 2);
k = 5;
field_num = 3; %% 1: title, 2: artist, 3: genre

for i = 1:num_files
  testCell{1, 1} = mfcc_cells_testing400{i, 1};
  testCell{1, 2} = mfcc_cells_testing400{i, 2};

  class = knn(mfcc_cells, testCell, field_num, k);
  classified{i, 1} = mfcc_cells_testing400{i, field_num};
  classified{i, 2} = class;
end

fprintf('classification:\n');
fprintf('-------------------------\n');
for i = 1:num_files
  if ~strcmp(classified{i, 1}, classified{i, 2})
    fprintf('New disagreement. %s misidentified as ', cell2mat(classified{i, 1}));
    classified{i, 2}
    %fprintf('title: %s, genre: %s\n', ...
    %    cell2mat(classified{i,1}), cell2mat(classified{i,2}{1}));
  end
end
