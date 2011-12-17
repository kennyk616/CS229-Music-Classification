function kmeans_test(k, num_iter, type)
% KMEANS_TEST(K, NUM_ITER, TYPE)
%
% Testing k-means algorithm on 120 songs:
% K is number of genres to cluster songs into
% NUM_ITER is the number of iterations to update centroids
% TYPE is 'songs' or 'images' to train/test classification on
%
% Outputs timing, genre spread, and statistics for songs in each cluster.
% 
% Example:
%   k = 4; num_iter = 10;
%   kmeans_test(k, num_iter);
%
% See also: kmeans_eval.m, kmeans.m
%

if (strcmp(type, 'songs'))
    % train k-means to get cluster centroids
    load mfcc_training_data400;
    mfcc = mfcc_cells_training400;

    tic; fprintf('\nAnalysis time for kmeans, k = %d...',k);
    [~, centroids] = kmeans(mfcc, k, num_iter);
    t = toc; fprintf('%5.2f sec\n',t); % 5 sec for num_iter = 10

    genres = {'classical', 'jazz', 'metal', 'pop'};
    fprintf('Cluster songs into %d genres:\n', k);
    fprintf('%s %s %s %s\n\n', genres{:});

    % classify test data using trained k-means clustering
    load mfcc_testing_data400;
    mfcc = mfcc_cells_testing400;
    num_songs = size(mfcc,1);  % # songs (120)
    clusters = cell(1, k);
    % assign data to centroids
    allDist = zeros(1, k);
    for song = 1:num_songs
        % classify: calculate dist from song to each centroid
        mu_song = mfcc{song, 1}; 
        covar_song = mfcc{song, 2};
        for cent = 1:k
            mu_cent = centroids{cent, 1};
            covar_cent = centroids{cent, 2};
            allDist(cent) = KLdiv(mu_song', covar_song, mu_cent', covar_cent);
        end
        [~, cent_idx] = min(allDist);
        clusters{1, cent_idx} = [clusters{1, cent_idx} song];  % assign song to closest centroid
    end

    % evaluate and print classification results
    kmeans_eval(genres, mfcc, clusters);
    
elseif (strcmp(type, 'images'))
    
    % train k-means to get cluster centroids
    load image_cells;
    mellin = image_cells;
 
    tic; fprintf('\nAnalysis time for kmeans, k = %d...',k);
    [~, centroids] = kmeans(mellin, k, num_iter);
    t = toc; fprintf('%5.2f sec\n',t); 

    genres = {'classical', 'jazz', 'metal', 'pop'};
    fprintf('Cluster songs into %d genres:\n', k);
    fprintf('%s %s %s %s\n\n', genres{:});

    % classify test data using trained k-means clustering
    num_images = size(mellin,1);  % # songs (120)
    clusters = cell(1, k);
    % assign data to centroids
    allDist = zeros(1, k);
    for image = 1:num_images
        % calculate dist from song to each centroid
        mel_image = mellin{image, 1}; 
        for cent = 1:k
            mel_cent = centroids{cent, 1};
            norm_dist = norm(mel_image - mel_cent, 'fro'); %2-norm or frobenius?
            allDist(cent) = norm_dist;
        end
        [~, cent_idx] = min(allDist);
        clusters{1, cent_idx} = [clusters{1, cent_idx} image];  % assign image to closest centroid
    end

    % evaluate and print classification results
    kmeans_eval(genres, mellin, clusters);
end

% ---- RESULTS for song genres: (final statistics at bottom) ---- %
%{
kmeans_test(4,10);

Analysis time for kmeans, k = 4... 5.01 sec
Cluster songs into 4 genres:
classical jazz metal pop

Cluster 1:
 -Highest: classical
# songs in genre: 16
  genre: classical, count: 14
  genre: jazz, count: 2
  genre: metal, count: 0
  genre: pop, count: 0
Cluster 2:
 -Highest: jazz
# songs in genre: 44
  genre: classical, count: 16
  genre: jazz, count: 27
  genre: metal, count: 0
  genre: pop, count: 1
Cluster 3:
 -Highest: metal
# songs in genre: 29
  genre: classical, count: 0
  genre: jazz, count: 1
  genre: metal, count: 27
  genre: pop, count: 1
Cluster 4:
 -Highest: pop
# songs in genre: 31
  genre: classical, count: 0
  genre: jazz, count: 0
  genre: metal, count: 3
  genre: pop, count: 28

-- Final stats: --
Total songs: 120
Total songs correct: 96
Total accuracy: 80%
Percent accuracy for each genre:
Genre: classical | Accuracy: 87.50%
Genre: jazz | Accuracy: 61.36%
Genre: metal | Accuracy: 93.10%
Genre: pop | Accuracy: 90.32%
%}