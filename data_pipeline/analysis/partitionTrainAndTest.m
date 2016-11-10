function  results = partitionTrainAndTest( data, numPartitions )
%First generate indices to be used as each data partition, given
%constraints on minimum data presence (no partitions lacking data for
%a particular KC, say
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
    %First, divide the data using the partition indices determined above
    [trainData, testData] = partitionData(partitions, i, data);
    %Train the BKT model
    [models{i}, ~] = trainModels(trainData, 25);
    %For reference, test the accuracy of the model of the training set
    [trainAccuracy, thresholds, trainrmses] = testAllModels(models{i}, trainData);
    %Now test the accuracy of the model over the test set, gathering information about RMSE
    [testAccuracy, rmses, errorPerAttempt{i}, errorByResourceCount{i}, errorByTraceLength{i}] = actuallyTestAllModels(models{i}, testData, thresholds);
    %Do some bookkeeping with the results of the above testing
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

