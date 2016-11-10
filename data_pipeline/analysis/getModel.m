function [best_model, best_likelihood] = getModel(data, numIter)
    best_likelihood = -inf;
    num_subparts = size(data.data, 1);
    num_resources = max(data.resources);
    otherMeasure = length(unique(data.resources));
    if otherMeasure ~= num_resources
        disp('Error: number of resources sanity check failed');
    end
    for i=1:numIter
        model = generate.random_model(num_resources, num_subparts);
        model.forgets = zeros(size(model.forgets));
        [fitmodel, log_likelihoods] = fit.EM_fit(model,data);
        if (log_likelihoods(end) > best_likelihood)
            best_likelihood = log_likelihoods(end);
            best_model = fitmodel;
        end
        
    end
    if best_likelihood == -inf || ~exist('best_model', 'var')
        disp('Error: model training has failed')
    end
end
