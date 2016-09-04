function d = translateRawExerciseWithOneResource( rawData )
%TRANSLATERAWEXERCISENORESOURCE Summary of this function goes here
%   Take in relevant response data for a single exercise and
%   transform it into a data object usable for the HMM library
    d.data = int8(parsing.reformatDataWithSubparts(rawData));
    [d.lengths, d.starts] = parsing.getStudentBoundries(rawData);
    d.resources = int16(parsing.getOneResource(rawData));
end

