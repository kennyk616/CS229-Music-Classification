function kmeans_test(k, num_iter)
% KMEANS_TEST(K, NUM_ITER)
%
% Testing k-means algorithm:
% K is # genres/clusters to group songs into
% NUM_ITER is # times to update clusters
%
% Outputs timing and genre spread for songs in each cluster.
%


load mfcc_test_data.mat
mfcc = mfcc_cells;

tic; fprintf('Analysis time for kmeans, k = %d...',k);
[clusters, ~] = kmeans(mfcc, k, num_iter);
t = toc; fprintf('%5.2f sec\n',t); % 

genres = {'Pop','Pop.Rock','Alt. Rock','Rock','R&B','Electronic','Other'};
glen = length(genres);
fprintf('%d possible genres in data set:\n', glen);
char(genres)

for cent = 1:k 
   fprintf('Cluster %d:\n', cent);
   songs_idx = clusters{1, cent};
   genretags = mfcc(songs_idx, 5); 
   len = length(songs_idx);
   count = zeros(1, glen);
   for i = 1:len
       g = char(genretags{i,1});
       idx = find(strcmp(g, genres));
       count(idx) = count(idx) + 1;
   end
   [~, maxidx] = max(count);
   fprintf(' -Highest: %s\n', genres{maxidx}); 
   for i = 1:glen
       g = genres{i};
       c = count(i);
       fprintf('  genre: %s, count: %d\n', g, c); 
   end
end
