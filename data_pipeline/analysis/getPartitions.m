function partitions = getPartitions( data, numPartitions)
%GETPARTITIONS Returns array of 'starts' indices to use for training data
%   Detailed explanation goes here
    numberOfExercises = size(data, 1);
    partitions = cell(numberOfExercises, 1);
    counter = 0;

    for i =1:numberOfExercises
        internalCounter = 0;
        partitionValid = 0;
        while ~partitionValid
            if ~mod(counter, 1000)
                fprintf('Partitioning %d counter: %d:%d\n', i, internalCounter, counter);
            end
            starts = data{i}.starts;
            partition = cvpartition(length(starts), 'Kfold', numPartitions);
            partitionValid = checkPartitions(partition, data{i}, numPartitions);
            counter = counter + 1;
            internalCounter = internalCounter + 1;
        end
        partitions{i} = partition;
    end
end

function valid = checkPartitions(partition, data, numPartitions)
    for index =1:numPartitions
        trainStartidx = partition.training(index);
        trainData = grabPartition(data, trainStartidx);
        testData = grabPartition(data, ~trainStartidx);
        numRsc = length(unique(data.resources));
        if sum(sum(testData.data, 2) == 0)...
            || sum(sum(trainData.data, 2) == 0)...
            || length(unique(trainData.resources)) < numRsc...
            || length(unique(testData.resources)) < numRsc
            valid = 0;
            return;
        end
    end
    valid = 1;

end

