function [ sufficient ] = hasSufficientResourceData( data , threshold)
%HASSUFFICIENTRESOURCEDATA Summary of this function goes here
%   Detailed explanation goes here
    sufficient = true;
    counts = zeros(max(data.resources), 1);
    resources = 1:max(data.resources);
    for i=1:length(data.starts)
        studentRsc = data.resources(data.starts(i):data.starts(i) + data.lengths(i) -1);
        counts = counts + (histc(studentRsc, resources) > 0)';
    end
    counts = counts(counts ~= 0);%We are safe ignoring non-present resource #'s
    if sum(counts < threshold)
        sufficient = false;
    end
        
    

end

