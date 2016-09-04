function [ meanResourcePerStudent ] = getMeanResourceCount( data )
%GETMEANRESOURCECOUNT Summary of this function goes here
%   Detailed explanation goes here
    meanResourcePerStudent = arrayfun(@(x) mean(data{x}.resourceCounts), [1:length(data)]);

end

