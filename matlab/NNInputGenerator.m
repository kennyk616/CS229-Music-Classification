%generates the input for Neural Network Analysis
clear all;
load mfcc_gztan_data

NUM_COEFF = 15;
NUM_GENRES = 4;

%mfcc_cells = mfcc_cells_training400;


m = size(mfcc_cells, 1);

num_features = NUM_COEFF + (1 + NUM_COEFF)*NUM_COEFF/2;

nn_input = zeros(m, num_features);
nn_output = zeros(m, NUM_GENRES);


max_all = 0;

%scaling input
for i = 1 : m
    [nn_input(i, :) cur_max] = format_mfcc_to_vector(mfcc_cells{i, 1}, ...
        mfcc_cells{i, 2}, NUM_COEFF, num_features);    

    if(cur_max > max_all)
        max_all = cur_max;
    end  
    
    nn_output(i, :) = genreToVector(mfcc_cells{i, 3}(1), NUM_GENRES);
    
    
end

nn_input = nn_input./max_all;
save nn_input_training_data nn_input;
save nn_output_training_data nn_output

