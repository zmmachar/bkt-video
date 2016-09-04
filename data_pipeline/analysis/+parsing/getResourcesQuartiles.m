function resources = getResourcesQuartiles( rawData, data, starts, lengths )
    import containers.Map;
    relevant_resources = unique(rawData(:, 3));
    resourceIds = 1:length(relevant_resources);
    dict = Map(relevant_resources, resourceIds);
    resources = arrayfun(@(x) dict(x), rawData(:,3))';
    maxResource = max(resources);
    studentResourcePercent = zeros(size(starts));
    for i = 1:length(starts)
        studentData = data(:, starts(i):starts(i)+lengths(i)-1);
        %studentRsc = data.resources(data.starts(student):data.starts(student)+data.lengths(student)-1);

        studentResourcePercent(i) = sum(sum(studentData, 1) == 0) / size(studentData,2);
    end
    
    sorted = sort(studentResourcePercent);
    half = ceil(length(studentResourcePercent)/2);
    h1 = sorted(half);
    halves = arrayfun(@(x) x <= h1, studentResourcePercent);
    
    for i = 1:length(halves)
        resources(starts(i):starts(i)+lengths(i)-1) = resources(starts(i):starts(i)+lengths(i)-1) + halves(i) * maxResource;
        
    end
    
end
