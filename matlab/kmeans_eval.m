function kmeans_eval(genres, mfcc, clusters)
% KMEANS_EVAL(GENRES, MFCC, CLUSTERS)
%
% Evaluate and print results of k-means classification:
% GENRES is a string array of the K genre names
% MFCC is the (testing) data set of songs
% CLUSTERS are the song indices in each cluster
%
% Outputs genre spread for songs in each cluster and total statistics.
%
% See also: kmeans_test.m, kmeans.m
%

k = length(genres);  % # genres
correct = zeros(1, k);  % # songs correctly classified per genre
classified = zeros(1, k);  % # total songs classified per genre
genreid = zeros(1, k);  % genre indices correspond with above vectors

for cent = 1:k 
   fprintf('Cluster %d:\n', cent);
   songs_idx = clusters{1, cent};
   genretags = mfcc(songs_idx, 3); 
   num_songs = length(songs_idx);
   count = zeros(1, k);
   for song = 1:num_songs
       song_genre = genretags{song,1};
       idx = find(strcmp(song_genre, genres));
       count(idx) = count(idx) + 1;
   end
   [maxnum, maxidx] = max(count);
   correct(cent) = maxnum;
   classified(cent) = num_songs;
   genreid(cent) = maxidx;
   fprintf(' -Highest: %s\n', genres{maxidx}); 
   fprintf('# songs in genre: %d\n',num_songs);
   for i = 1:k
       g = genres{i};
       c = count(i);
       fprintf('  genre: %s, count: %d\n', g, c); 
   end
end
total_correct = sum(correct);
total_song_count = sum(classified);
total_accuracy = total_correct/total_song_count;
fprintf('\n-- Final stats: --\n');
fprintf('Total songs: %d\n', total_song_count); 
fprintf('Total songs correct: %d\n', total_correct);
fprintf('Total accuracy: %d%%\n', total_accuracy*100);
fprintf('Percent accuracy for each genre:\n');
for i = 1:k
    fprintf('Genre: %s | ', genres{genreid(i)});
    fprintf('Accuracy: %3.2f%%\n', correct(i)/classified(i)*100);
end
fprintf('\n');

