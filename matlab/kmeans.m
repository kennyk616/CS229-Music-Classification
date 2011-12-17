function [clusters, centroids] = kmeans(features, k, num_iter, type)
% [CLUSTERS, CENTROIDS] = KMEANS(MFCC, K, NUM_ITER)
%
% k-means clustering (unsupervised learning)
%
% FEATURES is the cell matrix of features from a data set to train on
% K is number of groups to cluster data set into
% NUM_ITER is the number of iterations to update centroids
% CLUSTERS are the data element indices in each cluster
% CENTROIDS are the average centers (represented like a feature) for each cluster
%
% Algorithm:
%    1. init cluster centroids (mu)
%    2. assign songs to closest centroid (KL "distance")
%    3. update centroids to be mean of its assigned songs
%    4. repeat 2-3 until convergence
%
% See also: kmeans_test.m, kmeans_eval.m, KLdiv.m
%
% Example:
%     load mfcc_test_data.mat
%     mfcc = mfcc_cells;
%     k = 4; num_iter = 10;
%     [clusters, centroids] = kmeans(mfcc, k, num_iter);
%

if (strcmp(type, 'songs'))
    mfcc = features;
    num_songs = size(mfcc,1);  % # songs
    % initialize centroids to random songs
    % centroids = mfcc(ceil(rand(1,k)*num_songs),1:2);
    centroids = mfcc([35 105 175 245],1:2);
    allDist = zeros(1, k);
    count = 0;  % num_iter of 10 found to be best;
    while (count < num_iter) 
        oldcentroids = centroids;
        clusters = cell(1, k);
        % assign data to centroids
        for song = 1:num_songs
            % calculate dist from song to each centroid
            mu_song = mfcc{song, 1}; 
            covar_song = mfcc{song, 2};
            for cent = 1:k
                mu_cent = oldcentroids{cent, 1};
                covar_cent = oldcentroids{cent, 2};
                allDist(cent) = KLdiv(mu_song', covar_song, mu_cent', covar_cent);
            end
            [~, cent_idx] = min(allDist);
            clusters{1, cent_idx} = [clusters{1, cent_idx} song];  % assign song to closest centroid
            %clusters{2, cent_idx} = [clusters{2, cent_idx}; mu_song];
            %clusters{3, cent_idx} = [clusters{3, cent_idx}; covar_song];
        end
        % compute new centroids
        for cent = 1:k
            songs_idx = clusters{1, cent};  % vector of songs assigned to this centroid
            % get centroid mu
            all_mu = mfcc(songs_idx, 1);  % cells of mfcc means of the songs
            all_mu_mat = cell2mat(all_mu);  % (#songs in this cluster)x15 matrix
            mean_mu = mean(all_mu_mat, 1);  % 1x15 mean of mu's
            % get centroid covar
            all_covar = mfcc(songs_idx, 2);  % (#songs in this cluster)x1 cell
            len = length(songs_idx);
            all_covar_mat = zeros(15, 15, len);
            for i = 1:len
                all_covar_mat(:,:,i) = all_covar{i,1};
            end
            mean_covar = mean(all_covar_mat,3);
            % update centroid
            centroids{cent,1} = mean_mu;
            centroids{cent,2} = mean_covar;
        end
        count = count + 1;
    end
elseif (strcmp(type, 'images'))
    mellin = features;
    num_images = size(mellin,1);  % # songs
    % initialize centroids to random images
    % centroids = mfcc(ceil(rand(1,k)*num_songs),1:2);
    centroids = mellin([15 45 75 105],:);
    allDist = zeros(1, k);
    count = 0;  % num_iter of 10 found to be best;
    while (count < num_iter) 
        oldcentroids = centroids;
        clusters = cell(1, k);
        % assign data to centroids
        for image = 1:num_images
            % calculate dist from song to each centroid
            mel_image = mellin{image, 1}; 
            for cent = 1:k
                mel_cent = oldcentroids{cent, 1};
                norm_dist = norm(mel_image - mel_cent, 'fro'); %2-norm or frobenius?
                allDist(cent) = norm_dist;
            end
            [~, cent_idx] = min(allDist);
            clusters{1, cent_idx} = [clusters{1, cent_idx} image];  % assign image to closest centroid
        end
        % compute new centroids
        for cent = 1:k
            images_idx = clusters{1, cent};  % vector of images assigned to this centroid
            % get centroid matrix
            all_mel = mellin(images_idx, 1);  % (#images in this cluster)x1 cell
            len = length(images_idx);
            all_mel_mat = zeros(6, 6, len);
            for i = 1:len
                all_mel_mat(:,:,i) = all_mel{i,1};
            end
            mean_mel = mean(all_mel_mat,3);
            % update centroid
            centroids{cent,1} = mean_mel;
        end
        count = count + 1;
    end
end
        
        
