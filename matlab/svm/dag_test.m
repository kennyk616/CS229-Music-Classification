% vim: set tabstop=4 shiftwidth=4 :
function dag_test( index, retrain )
%DAG_TEST
%
% Testing the DAG SVM algorithm.
%

addpath('../');

TRAINING_FILE_PATH = GetFullPath('../../py/train.csv');
NUM_BINS = 22;
NUM_FRAMES = 200;
NUM_COEFF = 15;
STEP_TIME = 0.02;

if retrain % -- Train DAG --
raw_training_features = get_mfcc_features(TRAINING_FILE_PATH, NUM_BINS, NUM_FRAMES, ...
        NUM_COEFF, STEP_TIME);
feature_len = numel(raw_training_features{1,1}) ...
        + numel(raw_training_features{1,2});
num_songs = size(raw_training_features, 1);

%Get training features in a nicer format
training_features = cell(num_songs, 2);
for i = 1:num_songs
    feature_matrix = [raw_training_features{i,1}' raw_training_features{i,2}];
    training_features{i, 1} = reshape(feature_matrix, 1, feature_len);
    training_features{i, 2} = cell2mat(raw_training_features{i, 2 + index});
end

%Sort training songs by index'th tag.
training_features = sortrows(training_features, 2);
%Determine number of training songs in each category.
category_num = 1;
current_category = training_features{1, 2};
categories(category_num) = 1;
for i = 2:num_songs
    next_category = training_features{i, 2};
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
training_data = cell(num_categories, 1);
curr_index = 1;
for i = 1:num_categories
    training_data{i} = zeros(categories(i), feature_len);
    for j = 1:categories(i)
        training_data{i}(j,:) = training_features{curr_index, 1};
        curr_index = curr_index + 1;
    end
end

%Create string cell array training_categories.
training_categories = cell(num_categories, 1);
next_cat_index = 1;
for i = 1:num_categories
    training_categories{i} = training_features{next_cat_index, 2};
    next_cat_index = next_cat_index + categories(i);
end

dag_model = dag_train(training_data);
save('dag_model_store.mat', 'dag_model', 'training_categories');
else
load('dag_model_store.mat');
end % -- Train DAG --


% -- Test DAG --
TEST_FILE_PATH = GetFullPath('../../py/test.csv');
test_features = get_mfcc_features(TEST_FILE_PATH, NUM_BINS, NUM_FRAMES, ...
        NUM_COEFF, STEP_TIME);
feature_len = numel(test_features{1,1}) ...
        + numel(test_features{1,2});

num_test_songs = size(test_features, 1);
num_wrong = 0;
for i = 1:num_test_songs
    feature_matrix = [test_features{i,1}' test_features{i,2}];
    x = reshape(feature_matrix, 1, feature_len);
    result = dag_eval(x, dag_model);
    if ~strcmp(training_categories(result), cell2mat(test_features{i, 2 + index}))
        num_wrong = num_wrong + 1;
        fprintf('Song %d (%s) misidentifed as %s', i, ...
                cell2mat(test_features{i, 2 + index}), training_categories{result});
    end
end
fprintf('Percent missed: %f %%', num_wrong/num_test_songs*100);
% -- Test DAG --

rmpath('../');
