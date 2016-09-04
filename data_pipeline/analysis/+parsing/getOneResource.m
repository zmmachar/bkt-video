function resources = getOneResource( rawData )
    import containers.Map;
    responses = rawData(:, 5);
    resources = (1 + (responses == 0))';

end

