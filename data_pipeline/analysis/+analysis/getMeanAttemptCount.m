function [ meanAttemptCount ] = getMeanAttemptCount( data )
%GETMEANATTEMPTCOUNT Summary of this function goes here
%   Detailed explanation goes here
        meanAttemptCount = arrayfun(@(x) mean(double(data{x}.lengths) - data{x}.resourceCounts), 1:length(data));


end

