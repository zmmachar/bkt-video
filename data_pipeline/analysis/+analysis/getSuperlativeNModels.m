function [ superlativeModelReference ] = getSuperlativeNModels(direction, n, ...
    noMeanErr, expMeanErr, noResourceResults, expResourceResults, exerciseRef)
%GETTOPTHREEMODELS Summary of this function goes here
%   Detailed explanation goes here
    deltas = noMeanErr - expMeanErr;
    ordered = sort(deltas, 1, direction);

    nth = ordered(n);
    %idx = zeros(1,length(deltas));
    if strcmp(direction,'ascend')
        idx = deltas <= nth;
    else
        idx = deltas >= nth;
    end
    
    bestDeltas = deltas(idx);
    bestWithModels = getBestModels(idx, expResourceResults);
    bestNoModels = getBestModels(idx, noResourceResults);
    bestExercises = exerciseRef(idx);
    
    %construct a little struct for each of the best model with
    %the associated delta, the reference number for the exercise,
    %and the actually trained models for each fold
    superlativeModelReference = cellfun(@(x) composeModelRef(x, bestDeltas,...
        bestWithModels, bestNoModels, bestExercises), num2cell(1:sum(idx)));
    
end

function modelReference = composeModelRef(cellVal, bestDeltas, ...
    bestWithModels, bestNoModels, bestExercises)
    modelReference.delta = bestDeltas(cellVal);
    modelReference.withResourceModels = bestWithModels{cellVal};
    modelReference.noResourceModels = bestNoModels{cellVal};
    modelReference.exerciseRef = bestExercises(cellVal);
end

%since we have 5 folds worth of models not really stored to be referenced
%like this, getting the n best/worst is a bit awkward
function bestModels = getBestModels(idx, expResourceResults)
    bestModels = cell(sum(idx), 1);
    bestModels = cellfun(@(x) cell(length(expResourceResults.models), 1),...
        bestModels, 'UniformOutput', false);
    %for each fold's models
    for j = 1: length(expResourceResults.models)
        %take the best performers (as previously calculated) from that fold
        bestFoldModels = expResourceResults.models{j}(idx);
        %for each model
        for i = 1:sum(idx)
            bestModels{i}{j} = bestFoldModels{i};
        end
    end
end