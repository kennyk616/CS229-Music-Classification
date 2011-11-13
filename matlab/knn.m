% vim: set tabstop=4 shiftwidth=4 :
function [ class ] = knn(training_data, input, field_num, k)
% TODO docs

% Top row is index in training_data, bottom is distance to input.
k_nearest = inf(2, k);
m = size(training_data, 1);
for i = 1:m
    % Current maximum distance to k neareset neighbors.
    k_max_index = find(k_nearest == max(k_nearest));
    k_max_index = curr_max[1];
    % Distance from training_sample to input.
    % TODO training_sample indexing
    sample_dist_from_input = KL_div(training_sample{i, 1},
            training_sample{i, 2}, input{1, 1}, input{1, 2});
    if sample_dist_from_input < k_nearest(2, k_max_index)
        k_nearest(1, k_max_index) = i;
        k_nearest(2, k_max_index) = sample_dist_from_input;
    end
end

% Count occurences of the field we're classifying
field_counts = {};
field_index = field_num + 2;
for i = 1:m
    % First search to see if the field has already been seen, if so increment.
    num_field_counts = size(field_counts, 1);
    for j = 1:num_field_counts
        if strcmp(field_counts{j, 1}, training_data{i, field_index})
            field_counts{j, 2} = field_counts{j, 2} + 1;
        else
            field_counts{j, 1} = training_data{i, field_index};
            field_counts{j, 2} = 1;
        end
    end
end

% Determine the most popular of the k nearest neighbors.
num_field_counts = size(field_counts, 1);
max_field_count = 0;
max_field_index = 0;
for i = 1:num_field_counts
    if field_counts{i, 2} > max_field_count
        field_counts{i, 2} = max_field_count;
        max_field_index = 2;
    end
end

% Return the most popular class among the k nearest neighbors
class = field_counts{max_field_index, 1}

end
