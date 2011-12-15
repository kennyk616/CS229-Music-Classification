function [output] = genreToVector(genre, NUM_GENRES)

%1 -1 -1: 'classical'
%-1 1 -1: 'jazz'
%-1 -1 1: 'Other'
%1 1 1: 'pop'

genreMap = [1 -1 -1 -1; -1 1 -1 -1; -1 -1 1 -1; -1 -1 -1 1];
%genreMap = eye(4);
    if strcmp(genre, 'classical')
        output = genreMap(1, :);
    elseif strcmp(genre, 'jazz')
        output = genreMap(2, :);
    elseif strcmp(genre, 'metal')
        output = genreMap(3, :);
%    elseif strcmp(genre, 'pop')
%        output = genreMap(4, :);
    else 
        output = genreMap(4, :);
    end
    
end