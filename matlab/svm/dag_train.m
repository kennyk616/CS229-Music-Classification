% vim: set tabstop=4 shiftwidth=4 :
function [ dag_model ] = dag_train( training_data )
%DAG_TRAIN trains a multi-class DAG SVM model.
% Args:
%   training_data: A cell vector where each cell is an m by n matrix of m
%       training points each made up of n features. All points in the i'th
%       cell are in the i'th category.
% Returns:
%   dag_model: Model for use in prediction.

num_categories = length(training_data);
%m is a vector whose i'th position holds the number of training samples in
%the i'th cell of training data.
m = zeros(1, num_categories);
for i = 1:num_categories
    m(i) = size(training_data{i}, 1);
end

%populate dag_model, a cell matrix of liblinear models.
dag_model = cell(num_categories);
for i = 1:num_categories - 1
    for j = i:num_categories
        train_category = [-1*ones(m(i), 1); ones(m(j), 1)];
        sparse_train_matrix = sparse([training_data{i}; training_data{j}]);
        dag_model{i, j} = train(train_category, sparse_train_matrix);
    end
end
