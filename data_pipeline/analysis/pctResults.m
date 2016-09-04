%%

%Calculate the mean RMSE per exercise in an easily digestible form
pctMeanErr = analysis.getMeanErr_extra(pctCorrectResults.testErrFull);

%Calculate the mean accuracy for each exercise.  Old code for getMeanErr
%is reusable here, so excuse the function name :^]
pctMeanAcc = analysis.getMeanErr(pctCorrectResults.testAccFull);

total = sum(cellfun(@(x) size(x.data,2),noResourceFormattedData));
correct = sum(cellfun(@(x) sum(sum(x.data,1)-1,2), noResourceFormattedData));
overallPctCorrect = correct/total;
weightedPctCorrect = analysis.getMeanErr_extra(pctCorrectResults.testPctCorrect);
%error by attempt number (e.g. error predicting 1st attempt, 2nd attempt
%etc.
pctAttemptErr = analysis.getMeanAttemptError(pctCorrectResults.errorPerAttempt);

%error by length of attempts in trace
pctLengthErr = analysis.getMeanAttemptError(pctCorrectResults.errorByTraceLength);

%errors by count of number of resource in trace
pctCountErr = analysis.getMeanAttemptError(pctCorrectResults.errorByResourceCount);

 
