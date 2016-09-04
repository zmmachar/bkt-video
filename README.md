This repository contains the code for running BKT analysis incorporating video observation over a synthetic set of khan academy data, in the same raw format as the data used in 'Evaluating Educational Videos' article.

In order to run the analysis, starting from the initial parsing of logs from the raw log format to the actual BKT model building and training, run sample_pipeline.sh, from the data_pipeline directory.

The folder structure is already provided and the script should execute without error.
If you'd like to inspect the trained models or results, start matlab in the data_pipeline/analysis directory and load 'results.mat', which contains both the computer results and the structs used in the computation thereof
 
Feel free to email me any questions at zack.machardy@gmail.com

