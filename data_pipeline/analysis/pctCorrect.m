%setup and config
%number of events required to consider an exercise
threshold = 5;
%required amount of data for each subpart of an exercise
subpartThreshold = 1;
%file to load
% filename = 'data/related_inclusive_10-3';
% filename = 'data/Econ_1-3';
%filename = '~/data_pipeline/output/medstats_1-3';
%filename = '~/data_pipeline/output/khan_10-2';
filename = '../output/sample_1-3';
% filename = 'data/khan_quartiles_10-2';
% filename = 'data/related_inclusive_10-2';
%number of folds for cross validation
folds = 5;
%actually load and format the data
%[withResourceFormattedData, noResourceFormattedData, withHistoryFormattedData, noHistoryFormattedData,exerciseReference] = loadDataStudentHistory(filename, threshold, subpartThreshold);
[withResourceFormattedData, noResourceFormattedData, oneResourceFormattedData, exerciseReference] = loadData(filename, threshold, subpartThreshold);



%% training and testing
disp('*************Running Pct Correct Model************')
pctCorrectResults = pctCorrectTest(noResourceFormattedData, folds);
% disp('*********Training models with single resources******');
%disp('*******Training models with student priors******');
%withHistoryResults = partitionTrainAndTest(withHistoryFormattedData, folds);
%disp('*******Training models with student priors and no resources******');
%noHistoryResults = partitionTrainAndTest(noHistoryFormattedData, folds);

pctResults;
%calculateAnalysisResults;
