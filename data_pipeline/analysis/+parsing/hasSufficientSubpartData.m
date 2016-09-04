function [ sufficient ] = hasSufficientSubpartData( data , threshold)
%HASSUFFICIENTSUBPARTDATA Summary of this function goes here
%   Detailed explanation goes here
    sufficient = true;
    counts = zeros(size(data.data,1), 1);
    for i=1:length(data.starts)
        studentData = data.data(:, data.starts(i):data.starts(i) + data.lengths(i) -1);
        counts = counts + (sum(studentData, 2) ~= 0);
    end
    if sum(counts < threshold)
        sufficient = false;
    end
        
    

end

