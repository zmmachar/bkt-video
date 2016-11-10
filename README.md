This repository contains the code for running BKT analysis incorporating video observation over a synthetic set of khan academy data, in the same raw format as the data used in 'Evaluating Educational Videos' article.

In order to run the analysis, starting from the initial parsing of logs from the raw log format to the actual BKT model building and training, run sample_pipeline.sh, from the data_pipeline directory.

The folder structure is already provided and the script should execute without error.
If you'd like to inspect the trained models or results, start matlab in the data\_pipeline/analysis directory and load 'results.mat', which contains both the computer results and the structs used in the computation thereof
 
Feel free to email me any questions at zack.machardy@gmail.com


**Details**

This code consists of two major parts.  The first, found in the data\_pipeline/scripts directory, is python code that performs preprocessing on the raw data to transform it into a more easily usable format.  The second, found in the data\_pipeline/analysis directory, is matlab code which uses the output from the python scripts and actually runs the BKT model training and testing.

**Data Parsing**

Two files in the scripts directory, **aggregate\_user\_khan** and **trace\_generator\_khan** perform preliminary data parsing for the analysis code.
Specifically, aggregate\_user\_khan first takes the raw log data, which is roughly, though not 100% reliably, sorted by timestamp, and organizes it by user and time.   trace\_generator\_khan takes the data thus aggregated and performs two tasks.  First, it does KC-video matching.  That is, it attempts to heuristically determing which videos are likely related to which KCs.  This mapping is output to the reference directory for later human reference.  Next, the script actually reformats the data, based on KC-Video mappings determined earlier, into a format easily parseable for the matlab analysis code.

**Data Analysis**

The matlab analysis code is somewhat more complex.  At an abstract level, the log data parsed by the python scripts is first loaded into memory, placed into structs organized by KC, and then decorated with some features that will be used later in the analysis pipeline.  Next, the code is split into five separate folds, under the condition that each containins a sufficient amount of data per KC/video in the dataset.  The data thus split is used for 5-fold cross validation, where for each fold of the data, models are first trained on 4/5 of the folds, then tested on the fifth, with the fold used for testing changing across each run.  The results of this process, a large collection of models and results including RMSE, are then used to present human-readable results.  Additionally, the models thus trained, the results, and the data itself are all left in memory for manual exploration.

What follows is a more detailed outline about what is happening where in the code:

*runAnalysis.m* is the file from which code execution begins.  The first few lines are setup, defining minimum thresholds for KC quantitiy and sub-problem quantity per fold, followed by a number of cell objects used to hold intermediate and final analysis results.

The first essential function called is the loadData function, located in the loadData.m file.  This file loads the output of the python scripts into memory and does some preliminary processing.  First, the file loads in data with resources included, filtering out KCs with fewer than a specified number of examples.  A list of KCs, for reference, is kept in the 'exercises' variable.  Next, the data is loaded into structs representing the single-resource 'Template-1-Video' and no resource 'BKT IDEM' models.  These structures are returned to the runAnalysis function.

The next essential function, run once for each model (Template, Template-1-video, BKT IDEM) under consideration, is partitionTrainAndTest, found in the file PartitionTrainAndTest.m.  This function does exactly what the name would imply, first partitioning the data into a number of folds determined by input to the function.  Following this, for each fold of the function, four of the five partitions are used as training data.  This calls into a function for generating and training BKT models.  The essential file to check, where a model is generated and trained is the +fit/EM\_fit.m file.  This file is where the expectation maximization algorithm for training the model can actually be seen, along with E\_step.cpp and M\_step.m.

Back in the partitionTrainAndTest function, the model now trained is used to test prediction of the training and test data.  This calls into the testAllModels.m file, which is similar to the somewhat redundantly named actuallyTestAllModels.m file, save that it tracks fewer properties, which are of more interest in the analysis run over the test set.  These functions both call into the +fit/predict_and_compare.m file, which performs the actual testing.  In this file, predictions of the model are compared against real data, and RMSE is accordingly computed and returned to the caller.

Finally, partitionTrainAndTest performs some bookkeeping to track some output values more easily for later reference.  These results are returned to the runAnalysis function.  A couple of results are extracted here, like mean RMSE across folds by KC.  Finally, the script summarizeResults is called, which outputs the results of the analysis in human readable format.
 
