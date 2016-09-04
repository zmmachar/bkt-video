%convenience function to combine the five fold results, for RMSE
function [ meanErr ] = getMeanErr_extra( fiveFoldResults )
%GETMEANERR Summary of this function goes here
%   Detailed explanation goes here
   %fiveFoldResults = cellfun(@(x) sqrt(x(:,1)./x(:,2)), fiveFoldResults, 'UniformOutput', false);
    container = zeros(size(fiveFoldResults{1}, 1), 2);
    for i=1:5
        container = container + fiveFoldResults{i};
    end
    
    meanErr = container(:, 1) ./ container(:, 2);
     
%     meanErr = mean([fiveFoldResults{1} fiveFoldResults{2} fiveFoldResults{3}...
%         fiveFoldResults{4} fiveFoldResults{5}], 2);


end

