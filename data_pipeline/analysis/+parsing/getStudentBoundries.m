%%assuming ordered by student
function [lengths, starts] = getStudentBoundries(rawData)
    studentIds = rawData(:, 1);
    numStudents = size(unique(studentIds));
    starts = zeros(1, numStudents(1));
    lengths = zeros(1, numStudents(1));
    currentStudent = NaN;
    currentStudentIndex = 0;
    for i = 1:size(studentIds)
        if studentIds(i) ~= currentStudent
            if currentStudentIndex ~= 0
                lengths(currentStudentIndex) = i - starts(currentStudentIndex);
            end
            currentStudent = studentIds(i);
            currentStudentIndex = currentStudentIndex + 1;
            starts(currentStudentIndex) = i;
        end
    end
    if currentStudentIndex~=0
        lengths(currentStudentIndex) = i - starts(currentStudentIndex) + 1;
        starts = int32(starts);
        lengths = int32(lengths);
    else
        lengths(1) = 0;
        starts = int32(starts);
        lengths = int32(lengths);
    end
end

