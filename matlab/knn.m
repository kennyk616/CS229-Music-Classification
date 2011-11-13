% vim: set tabstop=4 shiftwidth=4 :
function [ class ] = knn(training_data, input, field_num, k)
% CLASS = KNN(TRAINING_DATA, INPUT, FIELD_NUM, K)
%
% CLASS is the class which our algorithm determined input falls into.
% TRAINING_DATA is the gaussians and metadata for each song in the training
% data. This should be the same format as data written by mfcc_test_data.m.
% INPUT is the gaussian for the song we wish to classify.
% FIELD_NUM is the <index of the field>-2 in TRAINING_DAT by which we wish to
% classify.
% K is the number of nearest neighbors to keep track of.
%
% Runs a k nearest neighbors algorithm to determine what class input falls
% into. Returns said class.
%
% See also: mfcc.m, mfcc_test_data.m

% Top row is index in training_data, bottom is distance to input.
k_nearest = inf(2, k);
m = size(training_data, 1);
for i = 1:m
    % Current maximum distance to k neareset neighbors.
    k_max_index = find(k_nearest(2, :) == max(k_nearest(2,:)));
    k_max_index = k_max_index(1);
    % Distance from training_sample to input.
    % TODO training_sample indexing
    sample_dist_from_input = KLdiv(training_data{i, 1},...
        training_data{i, 2}, input{1, 1}, input{1, 2});
    if sample_dist_from_input < k_nearest(2, k_max_index)
        k_nearest(1, k_max_index) = i;
        k_nearest(2, k_max_index) = sample_dist_from_input;
    end
end

% Count occurences of the field we're classifying
field_counts = cell(k, 2);
new_field = 1;
field_index = field_num + 2;
for i = 1:k
    % First search to see if the field has already been seen, if so
    % increment.
    inFieldCounts = 0;
    k_nearest_index = k_nearest(1, i);
    for j = 1:k         
        % TODO fix training_data
        if strcmp(field_counts{j, 1}, training_data{k_nearest_index, field_index})
            inFieldCounts = 1;
            field_counts{j, 2} = field_counts{j, 2} + 1;
            field_counts{1,1}
            field_counts{1,2}
            break;
        end
    end
    if (inFieldCounts == 0)
        field_counts{new_field, 1} = training_data{k_nearest_index, field_index};
        field_counts{new_field, 2} = 1;
        new_field = new_field + 1;
    end
end

% Determine the most popular of the k nearest neighbors.
max_field_count = 0;
max_field_index = 0;
for i = 1:k
    if field_counts{i, 2} > max_field_count
        max_field_count = field_counts{i, 2};
        max_field_index = i;
    end
    field_counts{max_field_index, 1}
end
%max_field_index;
% Return the most popular class among the k nearest neighbors
class = field_counts{max_field_index, 1};

end
