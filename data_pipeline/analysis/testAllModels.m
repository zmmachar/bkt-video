function [accuracy, thresholds, rmses] = testAllModels( models, data )
%TESTALLMODELS Summary of this function goes here
%   Detailed explanation goes here
    numberOfExercises = size(models, 1);
    accuracy = zeros(numberOfExercises, 1);
    thresholds = zeros(numberOfExercises, 1);
    rmses = zeros(numberOfExercises, 1);
%     fprintf('training threshold for exercise %d\n', 1);
    for i = 1:numberOfExercises
%         if ~mod(i, 50)
%              fprintf('training threshold for exercise %d\n', i);
%         end
%         max = 0;
        maxThresh = .5;
%         currRmse = 0;
        threshold = .5;
        %for threshold = 0:0.05:1
        [acc, rmse] = fit.predict_and_compare(models{i}, data{i}, threshold);
        max = acc;
        currRmse = rmse;
        %Removing threshold training since it mostly just wastes time ATM.
%             if acc > max
%                 max = acc;
%                 maxThresh = threshold;
%                 currRmse = rmse;
%             end
%         end
        rmses(i) = currRmse;
        accuracy(i) = max;
        thresholds(i) = maxThresh;
    end

end

