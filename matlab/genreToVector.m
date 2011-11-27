function [output] = genreToVector(genre, NUM_GENRES)

%1000000: 'Alt. Rock'
%0100000: 'Electronic'
%0010000: 'Other'
%0001000: 'Pop'
%0000100: 'Pop.Rock'
%0000010: 'R&B'
%0000001: 'Rock'

genreMap = eye(NUM_GENRES);
    if strcmp(genre, 'Alt. Rock')
        output = genreMap(1, :);
    elseif strcmp(genre, 'Electronic')
        output = genreMap(2, :);
    elseif strcmp(genre, 'Other')
        output = genreMap(3, :);
    elseif strcmp(genre, 'Pop')
        output = genreMap(4, :);
    elseif strcmp(genre, 'Pop.Rock')
        output = genreMap(5, :);
    elseif strcmp(genre, 'R&B')
        output = genreMap(6, :);
    else 
        output = genreMap(7, :);
    end
end