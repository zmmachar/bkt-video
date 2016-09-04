echo 'Generating per-user files'

rm -rf data/users_sample
mkdir data/users_sample

python2.7 scripts/aggregate_user_khan.py data/sample_problems data/sample_videos data/users_sample/

echo 'Translating native format into matlab-friendly format'

python2.7 scripts/trace_generator_khan.py data/users_sample/ output/sample reference/sample_KC reference/sample_vid 1 3

echo 'Running Matlab Analysis'

(cd analysis && matlab -nodisplay -nodesktop -r "run runAnalysis.m")

echo 'Analysis complete. If you would like to inspect any of the structures created and used during the analysis, start matlab and load results.mat'
