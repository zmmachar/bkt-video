function resources = getResources( rawData )
    import containers.Map;
    relevant_resources = unique(rawData(:, 3));
    resourceIds = 1:length(relevant_resources);
    dict = Map(relevant_resources, resourceIds);
    resources = arrayfun(@(x) dict(x), rawData(:,3))';

end

