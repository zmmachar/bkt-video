function trace = getPerExerciseTrace( data, ID )
%GETPEREXERCISETRACE Retrieve all log events associated with an exercise ID
    trace = data((data(:,2) == ID), :);
end

