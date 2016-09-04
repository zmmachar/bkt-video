  fprintf('Mean RMSE for standard BKT:              %f\n\n', mean(noMeanErr{1}))
  fprintf('Mean RMSE for percent-correct model:     %f\n', mean(pctMeanErr{1}))
  [~, p] = ttest(noMeanErr{1}, pctMeanErr{1});
  fprintf('p value(compared to standard BKT):       %f\n\n', p)
  fprintf('Mean RMSE for template-videos model:     %f\n', mean(withMeanErr{1}))
  [~, p] = ttest(noMeanErr{1}, withMeanErr{1});
  fprintf('p value(compared to standard BKT):       %f\n', p)
  disp('***********************************');
