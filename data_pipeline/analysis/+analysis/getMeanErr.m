%Convenience function to combine the five fold results
function [ meanErr ] = getMeanErr( fiveFoldResults )
%GETMEANERR Summary of this function goes here
%   Detailed explanation goes here
    meanErr = mean([fiveFoldResults{1} fiveFoldResults{2} fiveFoldResults{3}...
        fiveFoldResults{4} fiveFoldResults{5}], 2);

end

