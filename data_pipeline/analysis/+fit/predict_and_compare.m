function [tot, rmse, count, perAttemptError, byResourceError, byLengthError] = predict_and_compare(model,data, threshold)
% returns the proportion of incorrect predictions

import fit.*

predicted_correct_ans_probs = predict_onestep(model,data);
rmse = 0;
tot = 0;
numResources = 0;
count = 0;
predictionError = zeros(1, 5);
totalPredictions = zeros(1, 5);
byResourceError = zeros(1, 5);
byResourceTotal = zeros(1, 5);
byLengthError = zeros(1, 5);
byLengthTotal = zeros(1, 5);
ind = 0;
for startlen=[data.starts;data.lengths]
    ind = ind + 1;
    start = startlen(1);
    len = startlen(2);
    d = data.data(:,start:start+len-1);
    if(size(d, 1) == 1) 
        numResources = numResources + sum(d == 0);
    else
        numResources = numResources + sum(sum(d,1) == 0);
    end
    p = predicted_correct_ans_probs(:,start:start+len-1);
    %this measures the number of resources observed
    numRsc = data.resourceCounts(ind);
    p = p(d ~= 0);
    d = d(d ~= 0);
    if(size(d, 1) == 1)
        p = p';
        d = d';
    end
    %In the event the predictor spits out a NaN, interpret it as 1
    p(isnan(p)) = 1;
    if size(d, 1) > 0
        %calculate mean squared error for each sequence
        traceRmse = sqrt(sum(abs((d == 2) - p).^2)/size(d, 1));
        rmse = rmse + traceRmse;
        
        %record error by number of resources, and length of attempt trace
        rscIdx = min(numRsc + 1, 5);
        lengthIdx = min(length(d), 5);
        [byResourceError, byResourceTotal] = updateTrackingArrays(rscIdx,...
            traceRmse, byResourceError, byResourceTotal);
        [byLengthError, byLengthTotal] = updateTrackingArrays(lengthIdx,...
            traceRmse, byLengthError, byLengthTotal);
        
        count = count + 1;
        
        %if(threshold)
        %    p = p > threshold;
        %end
        
        
        summand = sum(abs((d == 1) - p),1);
        if summand
            tot = tot + summand;
        end
        
        %just doing some book keeping to track per-attempt error here
        %looking for, say, whether we do better on the first or later
        %attempts
        totalPredictions(1:min(size(d, 1), 4)) = totalPredictions(1:min(size(d, 1), 4)) + 1;
        totalPredictions(5) = totalPredictions(5) + max(0, size(d, 1) - 4);
        for i = 1:size(d,1)
            index = min(i, 5);
            predictionError(index) = predictionError(index) + ((d(i, 1) == 2) - p(i, 1))^2;
        end
    end
end

tot = tot / (sum(data.lengths) - numResources);
perAttemptError = sqrt(predictionError ./ totalPredictions);
byResourceError = byResourceError ./ byResourceTotal;
byLengthError = byLengthError ./ byLengthTotal;
end

function [sumArr, totalArr] = updateTrackingArrays(index, val, sumArr, totalArr) 
    sumArr(index) = sumArr(index) + val;
    totalArr(index) = totalArr(index) + 1;
end
