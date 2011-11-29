function [output cur_max] = format_mfcc_to_vector(mean_vec, cov_matrix, ...
NUM_COEFF, num_features)
% [output cur_max] = format_mfcc_to_vector(mean_vec, cov_matrix, NUM_COEFF,
% num_features
%
% output refers to the vector that takes the mean vector and top triangle
% of the cov_matrix an flatens it into 1 vector. This is designed for the
% mean-vector and cov-matrix of the mfcc data. 
% 
% Should be used for neural networks and SVM
    output = zeros(1, num_features);
    for j = 1:NUM_COEFF
        output(1, j) = mean_vec(1, j);
    end
    
    idx = NUM_COEFF+1;
    for j = 1:NUM_COEFF
        for k = j:NUM_COEFF
            output(1, idx) = cov_matrix(j, k);
            idx = idx + 1;
        end
    end    
    cur_max = max(abs(output(1,:)));
end