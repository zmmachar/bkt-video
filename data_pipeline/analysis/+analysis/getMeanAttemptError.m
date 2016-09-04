function [ meanAttemptErr ] = getMeanAttemptError( errorCells )
%GETMEANATTEMPTERROR Summary of this function goes here
%   Detailed explanation goes here
    meanAttemptErr = zeros(1, 5);
    for i=1:length(errorCells)
        errArray = errorCells{i};
        for j = 1:5
            col = errArray(:, j);
            %remove NaNs (result of a divide by zero where an exercise had
            %no n'th attempts)
            col = col(~isnan(col));
            meanAttemptErr(j) = meanAttemptErr(j) + mean(col);
        end   
    end
    
    meanAttemptErr = meanAttemptErr / length(errorCells);

end

