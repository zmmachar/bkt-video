function [exercises, perExerciseTraces] = getTracesAboveThreshold( data, threshold)
%GETTRACESABOVETHRESHOLD Summary of this function goes her
%   Detailed explanation goes here
    aboveThreshold = data(ismember(data(:,2), (find(histc(data(:, 2), unique(data(:, 2))) > threshold))), :);
    exercises = unique(aboveThreshold(:, 2));
    numberOfExercises = size(exercises, 1);
    perExerciseTraces = cell(numberOfExercises,1);
    for i = 1:numberOfExercises
        perExerciseTraces{i} = getPerExerciseTrace(aboveThreshold, exercises(i));
    end
end

