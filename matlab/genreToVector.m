function [output] = genreToVector(genre, NUM_GENRES)


%genreMap = [1 -1 -1 -1; -1 1 -1 -1; -1 -1 1 -1; -1 -1 -1 1];
genreMap = eye(4);
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