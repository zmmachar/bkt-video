function [ rscCounts ] = getResourceCounts( data )
%GETRESOURCECOUNTS Grab the number of resources in each student trace as an
%array of len(number of students)
    rscCounts = zeros(1, length(data.starts));
    for i=1:length(data.starts)
        trace = data.data(:, data.starts(i):(data.starts(i) + data.lengths(i) - 1));
        rscCounts(i) = sum(sum(trace,1) == 0);
    end

end

