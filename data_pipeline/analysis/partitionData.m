function [ trainData, testData ] = partitionData( partitions, index, data )
%PARTITIONDATA Summary of this function goes here
%   Detailed explanation goes here
    numberOfExercises = size(data, 1);
    trainData = cell(size(data, 1), 1);
    testData = cell(size(data, 1), 1);
    for i =1:numberOfExercises
        exerciseData = data{i};
        partition = partitions{i};
        trainStartidx = partition.training(index);
        trainData{i} = grabPartition(exerciseData, trainStartidx);
        testData{i} = grabPartition(exerciseData, ~trainStartidx);

    end
end
