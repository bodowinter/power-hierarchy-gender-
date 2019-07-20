# Analysis of Power Experiment

Script files contained in this repository:

*	001_preprocessing.Rmd - processes the experiment data (response time cleaning etc.)
*	002_descriptive_stats.Rmd - descriptive stats
*	003_processing_corpus_data_norms.Rmd - loads corpus data and computes table, correlation with misersky norms, creates figure 1
*	004_bayes_model_estimation.R - the main bayesian model of the experiment
*	005_statistical_model_results_interpretation.Rmd - interpreting the main bayesian model, creates figures 2 to 4

Data files contain in this repository:

*	hierarchy_experiment.csv - raw data of the main experiment, straight from E-Prime
*	hierarchy_experiment_cleaned.csv - cleaned file, output of script 001
*	item_corpus.csv - corpus stats per item (pair), output of script 003 and used in 005 to relate to the Bayesian model
*	item_to_misersky_2014_norm_match.csv - contains Misersky norms to match with corpus stats, relevant for script 003
*	profession_corpus_counts.csv - corpus counts per individual profession

