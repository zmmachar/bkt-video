function [ data ] = reformatDataWithSubparts( rawData )
    %no guarantee we have removed resources yet, need to only consider
    %question response data regardless
    noResourceData = rawData(not((rawData(:,5) == 0)), :);
    numSubparts = max(noResourceData(:, 3));
    data = zeros(numSubparts, size(rawData, 1));
    for i=1:size(rawData, 1)
        response = rawData(i, 5);
        if response ~= 0
            data(rawData(i, 3), i) = response;
        end
    end

end

