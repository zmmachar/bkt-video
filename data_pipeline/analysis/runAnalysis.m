%setup and config
%number of events required to consider an exercise
threshold = 1;
%required amount of data for each subpart of an exercise
subpartThreshold = 5;
%Run through each of the courses, generate results
filename = '';
files = {'../output/sample_1-3'};
%number of folds for cross validation
folds = 5;
%actually load and format the data
withResource = cell(1, 1);
noResource = cell(1, 1);
oneResource = cell(1, 1);
exerciseReference = cell(1, 1);

withResourceResults = cell(1, 1);
noResourceResults = cell(1, 1);
pctCorrectResults = cell(1, 1);
noMeanErr = cell(1, 1);
withMeanErr = cell(1, 1);
pctMeanErr = cell(1, 1);
noCountErr = cell(1, 1);
withCountErr = cell(1, 1);


withBestModels = cell(1, 1);
withWorstModels = cell(1, 1);


i = 1
filename = files{i}

%load in the python-processed data
  [withResource{i}, noResource{i}, oneResource{i}, exerciseReference{i}] = loadData(filename, threshold, subpartThreshold);



%% training and testing
  disp('Training models with resources');
  withResourceResults{i} = partitionTrainAndTest(withResource{i}, folds);
  disp('*********Training models without resources********');
  noResourceResults{i} = partitionTrainAndTest(noResource{i}, folds);
  disp('*********Testing Percent Correct Model*********');
  pctCorrectResults{i} = pctCorrectTest(noResource{i}, folds);
  %calculate the mean RMSE per exercise
  noMeanErr{i} = analysis.getMeanErr_extra(noResourceResults{i}.testErrFull);
  withMeanErr{i} = analysis.getMeanErr_extra(withResourceResults{i}.testErrFull);
  pctMeanErr{i} = analysis.getMeanErr_extra(pctCorrectResults{i}.testErrFull);

  %errors by count of number of resource in trace
  noCountErr{i} = analysis.getMeanAttemptError(noResourceResults{i}.errorByResourceCount);
  withCountErr{i} = analysis.getMeanAttemptError(withResourceResults{i}.errorByResourceCount);



summarizeResults

save 'results'
