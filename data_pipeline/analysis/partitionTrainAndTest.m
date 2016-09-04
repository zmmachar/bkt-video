function  results = partitionTrainAndTest( data, numPartitions )
%PARTITIONTRAINANDTEST Summary of this function goes here
%   Detailed explanation goes here
partitions = getPartitions(data, numPartitions);
errs = zeros(numPartitions, 1);
trainAccuracies = zeros(numPartitions, 1);
trainAccFull = cell(numPartitions, 1);
testAccuracies = zeros(numPartitions, 1);
testAccFull = cell(numPartitions, 1);
trainErrFull = cell(numPartitions, 1);
testErrFull = cell(numPartitions, 1);
errorPerAttempt =  cell(numPartitions, 1);
errorByResourceCount = cell(numPartitions, 1);
errorByTraceLength = cell(numPartitions, 1);
models = cell(numPartitions, 1);
for i = 1:numPartitions
    fprintf('Partition %d:\n', i);
    [trainData, testData] = partitionData(partitions, i, data);
    [models{i}, ~] = trainModels(trainData, 25);
    [trainAccuracy, thresholds, trainrmses] = testAllModels(models{i}, trainData);
    [testAccuracy, rmses, errorPerAttempt{i}, errorByResourceCount{i}, errorByTraceLength{i}] = actuallyTestAllModels(models{i}, testData, thresholds);
    trainSizes =  cellfun(@(x) size(x.data, 2), trainData);
    testSizes = cellfun(@(x) size(x.data, 2), testData);
    trainAccFull{i} = trainAccuracy;
    testAccFull{i} = testAccuracy;
    trainErrFull{i} = trainrmses;
    testErrFull{i} = rmses;
    tracc = sum((trainSizes/sum(trainSizes)) .* trainAccuracy);
    teacc = sum((testSizes/sum(testSizes)) .* testAccuracy);
    errs(i) = sum(rmses(:, 1));
    testAccuracies(i) = teacc;
    trainAccuracies(i) = tracc;
end
cverr = sum(errs);
testAcc = mean(testAccuracies);

results.cverr = cverr;
results.testAcc = testAcc;
results.testAccFull = testAccFull;
results.trainAccFull = trainAccFull;
results.testErrFull = testErrFull;
results.trainErrFull = trainErrFull;
results.models = models;
results.errorPerAttempt = errorPerAttempt;
results.errorByResourceCount = errorByResourceCount;
results.errorByTraceLength = errorByTraceLength;
end

