
function filteredData =  grabPartition(data, startIdx)
    starts = data.starts(startIdx);
    lengths = data.lengths(startIdx);
    resourceCounts = data.resourceCounts(startIdx);
    dataIdx = zeros(size(data.data, 2), 1);
    newStarts = zeros(1, length(starts));
    newStarts(1) = 1;
    for i=1:size(starts, 2)
        dataIdx(starts(i):(starts(i)+lengths(i)-1)) = 1;
        if i ~= 1
           newStarts(i) = newStarts(i - 1) + lengths(i - 1);
        end
    end
    dataIdx = logical(dataIdx);
    filteredData.data = int8(data.data(:, dataIdx));
    filteredData.lengths = int32(lengths);
    filteredData.starts = int32(newStarts);
    filteredData.resources = int16(data.resources(dataIdx));
    filteredData.resourceCounts = int32(resourceCounts);

end
