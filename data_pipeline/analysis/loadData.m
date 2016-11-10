function  [withResourceFormattedData, noResourceFormattedData, oneResourceFormattedData, exercises] = loadData(filename, threshold, subpartThreshold)
    disp('Loading data...')
    allData = load(filename);
    fprintf('Filtering for exercises with more than %d events...\n', threshold);
    [exercises, perExerciseTraces] = getTracesAboveThreshold(allData, threshold);
    disp('Reformatting Data');
    %First, format the data for the with-resource models, filtering out students with insufficient data
    [withResourceFormattedData, exercises, perExerciseTraces] = parsing.formatAndFilterExerciseData(...
        perExerciseTraces, @parsing.translateRawExerciseWithResource, exercises, subpartThreshold);
    hasVideoIdx = cellfun(@(x)max(x.resources), withResourceFormattedData) > 1;
    withResourceFormattedData = withResourceFormattedData(hasVideoIdx);
    exercises = exercises(hasVideoIdx);
    perExerciseTraces = perExerciseTraces(hasVideoIdx);
   %Now, load the data for the one resource model and the no resource model, already having filtered out potentially problematic exercises
    oneResourceFormattedData = parsing.formatAndFilterExerciseData(...
        perExerciseTraces, @parsing.translateRawExerciseWithOneResource, exercises, subpartThreshold);
    noResourceFormattedData = parsing.formatAndFilterExerciseData(...
        perExerciseTraces, @parsing.translateRawExerciseNoResourceWithSubparts, exercises, subpartThreshold);
    
        
    %add some diagnostic info about
    %resource counts to no-resource data
    
    for i=1:length(withResourceFormattedData)
        withResourceFormattedData{i}.resourceCounts = parsing.getResourceCounts(withResourceFormattedData{i});
        noResourceFormattedData{i}.resourceCounts = removeAllResourceTraceCounts(withResourceFormattedData{i});
        oneResourceFormattedData{i}.resourceCounts = withResourceFormattedData{i}.resourceCounts;
    end
end

function filteredResourceCounts = removeAllResourceTraceCounts(data) 
    %obviously, don't include data about traces that only involved
    %resources for models not using them
    filteredResourceCounts = data.resourceCounts(data.resourceCounts ~= data.lengths);
end
