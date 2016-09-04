function [models, likelihoods] = trainModels( formattedData , iterations)
%TRAINMODELS Summary of this function goes here
%   Detailed explanation goes here
    numberOfExercises = size(formattedData, 1);
    models = cell(numberOfExercises, 1);
    likelihoods = ones(numberOfExercises, 1);
    fprintf('training model %d/%d\n', 1, numberOfExercises);
    for i=1:numberOfExercises
        if ~mod(i, 25)
            fprintf('training model %d/%d\n', i, numberOfExercises);
        end
        [models{i}, likelihoods(i)] = getModel(formattedData{i}, iterations);
        
    end

end

