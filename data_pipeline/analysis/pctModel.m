function [best_model, best_likelihood] = pctModel(data, numIter)
    best_likelihood = -inf;
    num_subparts = size(data.data, 1);
    num_resources = max(data.resources);
    otherMeasure = length(unique(data.resources));
    if otherMeasure ~= num_resources
        disp('what the heck');
    end
    best_model = generate.random_model(num_resources, num_subparts);
    best_likelihood = 1;
end

