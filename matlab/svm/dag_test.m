% vim: set tabstop=4 shiftwidth=4 :
function dag_test( index, dag_model )
%DAG_TEST
%
% Testing the DAG SVM algorithm.
%

addpath('../');

% -- Train DAG --
TRAINING_FILE_PATH = GetFullPath('../../py/train.csv');
NUM_BINS = 22;
NUM_FRAMES = 200;
NUM_COEFF = 15;
STEP_TIME = 0.02;

fprintf(TRAINING_FILE_PATH);
training_features = get_mfcc_features(TRAINING_FILE_PATH, NUM_BINS, NUM_FRAMES, ...
        NUM_COEFF, STEP_TIME);
num_songs = size(training_features, 1);
%Sort training songs by index'th tag.
training_features = sortrows(training_features, 3 + index);
%Determine number of training songs in each category.
category_num = 1;
current_category = training_features{1, 3 + index};
categories(category_num) = 1;
for i = 2:num_songs
    next_category = trainig_features{i, 3 + index};
    if strcmp(current_category, next_category)
        categories(category_num) = categories(category_num) + 1;
    else
        current_category = next_category;
        category_num = category_num + 1;
        categories(category_num) = 1;
    end
end
num_categories = length(categories);

%Create the cell array training_data
training_data = cell(num_categories, 2);
feature_len = numel(training_freatures{1,1}) + numel(training_freatures{1,2});
for i = 1:num_categories
    training_data{i} = zeros(categories(i), feature_len);
    for j = 1:categories(i)
        feature_matrix = [training_features{i,1}' training_features{i,2}];
        training_data{i}(j,:) = reshape(feature_matrix, 1, feature_len);
    end
end

%Create string cell array training_categories.
training_categories = cell(num_categories);
next_cat_index = 1;
for i = 1:num_categories
    training_categories{i} = training_features{next_cat_index, 3 + index};
    next_cat_index = next_cat_index + categories(i);
end

dag_model = dag_train(training_data);
% -- Train DAG --

% -- Test DAG --
TEST_FILE_PATH = GetFullPath('../../py/test.csv');
test_features = get_mfcc_features(TEST_FILE_PATH, NUM_BINS, NUM_FRAMES, ...
        NUM_COEFF, STEP_TIME);

num_test_songs = size(test_features, 1);
num_wrong = 0;
for i = 1:num_test_songs
    feature_matrix = [test_features{i,1}' test_features{i,2}];
    x = reshape(feature_matrix, 1, feature_len);
    result = dag_eval(x, dag_model);
    if strcmp(training_categories(result), test_features{i, 3 + index})
        num_wrong = num_wrong + 1;
        fprintf('%s (%s) misidentifed as %s', test_features{i, 3}, ...
                test_features{i, 3 + index}, training_categories(result));
    end
end
fprintf('Percent missed: %f', num_wrong/num_test_songs);
% -- Test DAG --

rmpath('../');
