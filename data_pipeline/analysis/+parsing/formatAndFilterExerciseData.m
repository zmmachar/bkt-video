function  [data, ex, rawLogs] = formatAndFilterExerciseData( rawLogs, dataParsingFunc, exercises, subpartThreshold)
%FORMATEXERCISEDATA Summary of this function goes here
%   Detailed explanation goes here
    numberOfExercises = size(rawLogs, 1);
    data = cell(numberOfExercises, 1);
    for i = 1:numberOfExercises
        data{i} = dataParsingFunc(rawLogs{i});
    end
    enoughSubpartIdx = cellfun(@(x) parsing.hasSufficientSubpartData(x, subpartThreshold), data);
    data = data(enoughSubpartIdx);
    rawLogs = rawLogs(enoughSubpartIdx);
    ex = exercises(enoughSubpartIdx);
    enoughRscIdx = cellfun(@(x) parsing.hasSufficientResourceData(x, 10), data);
    data = data(enoughRscIdx);
    ex = ex(enoughRscIdx);
    rawLogs = rawLogs(enoughRscIdx);
    if(size(data{1}.data,1) == 0 || size(data{1}.data,2) == 0)
        data = data(2:end);
        ex = exercises(2:end);
        rawLogs = rawLogs(2:end);
    end
    %data = setQuartilePrior(data);


end

