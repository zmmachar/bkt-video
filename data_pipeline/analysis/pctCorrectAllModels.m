function [accuracy, rmses, errorPerAttempt, errorByResourceCount, errorByTraceLength, actualPctCorrect]...
    = pctCorrectAllModels( models, data)
%TESTALLMODELS Summary of this function goes here
%   Detailed explanation goes here
    numberOfExercises = size(models, 1);
    accuracy = zeros(numberOfExercises, 1);
    rmses = zeros(numberOfExercises, 2);
    errorPerAttempt = zeros(numberOfExercises, 5);
    errorByResourceCount = zeros(numberOfExercises, 5);
    errorByTraceLength = zeros(numberOfExercises, 5);
    actualPctCorrect = zeros(numberOfExercises, 2);
    fprintf('testing for exercise %d\n', 1);
    for i = 1:numberOfExercises
        if ~mod(i, 50)
            fprintf('testing for exercise %d\n', i);
        end
        %Repeatedly adding things to analyze has led to this sorry state
        %apologies to whoever is trying to interpret this
        %I am looking at:
        %acc: raw 'accuracy' of prediction
        %rmse: calculated rmse
        %count: just number of predictions made by exercise
        %errorPerAttempt: 1x5 array listing RMSE for the 1st-4+th individual attempt
        %errorByResourceCount: 1x5 array, separates out calculated RMSE by number of resources in trace
        %errorByLength: 1x5 array, separates out calculated RMSE by length of trace
        [acc, rmse, count, errorPerAttempt(i, :), errorByResourceCount(i, :),...
            errorByTraceLength(i, :), pctC] = fit.predict_and_compare_pctCorrect(models{i}, data{i}, 0);%, thresholds(i));
        rmses(i, 1) = rmse;
        rmses(i, 2) = count;
        accuracy(i) = acc;
        actualPctCorrect(i, 1) = pctC;
        actualPctCorrect(i, 2) = count;
    end

end

