function [output cur_max] = format_NN_input(mean_vec, cov_matrix, ...
    NUM_COEFF, num_features)
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