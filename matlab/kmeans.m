function [clusters, centroids] = kmeans(mfcc, k)
% [CLUSTERS, CENTROIDS] = KMEANS(MFCC, K)
%
% k-means clustering (unsupervised learning)
%
% NUM_GENRES - default at 5 genres
% 
% Algorithm:
%    1. init cluster centroids (mu)
%    2. assign songs to closest centroid (KL "distance")
%    3. update centroids to be mean of its assigned songs
%    4. repeat 2-3 until convergence
%
% See also: KLdiv.m, mfcc_test_data.mat, get_mfcc_features.m
%
% Example:
%     load mfcc_test_data.mat
%     mfcc = mfcc_cells;
%     k = 5;
%     [clusters, centroids] = kmeans(mfcc, k);

num_songs = size(mfcc,1);  % # songs

% initialize centroids to random songs
centroids = mfcc(ceil(rand(1,k)*num_songs),1:2);
allDist = zeros(1, k);
clusters = cell(1, k);
count = 0;  max_count = 20;
% TO DO: change the while condition
while (count < max_count)  % larger error/faster, pick empirically
    oldcentroids = centroids;
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

