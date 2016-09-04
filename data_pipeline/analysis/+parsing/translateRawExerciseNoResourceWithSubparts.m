function d = translateRawExerciseNoResourceWithSubparts( rawData )
%TRANSLATERAWEXERCISENORESOURCE Summary of this function goes here
%   Take in relevant response data for a single exercise and
%   transform it into a data object usable for the HMM library
    noResourceData = rawData(not((rawData(:,5) == 0)), :);
    d.data = int8(parsing.reformatDataWithSubparts(noResourceData));
    [d.lengths, d.starts] = parsing.getStudentBoundries(noResourceData);
    d.resources = int16(ones(1, size(d.data, 2)));
end

