## Bodo Winter
## July 19, 2019
## Bayesian models

## Preprocessing:

# Packages:

library(tidyverse)
library(brms)

# Data:

power <- read_csv('data/hierarchy_experiment_cleaned.csv')

# ggplot2 theme:

source('timo_theme.R')

## Setting things up for analysis

# Setting the options for parallel computing:

options(mc.cores = parallel::detectCores())

# For sum-coding, convert relevant predictors to factors:

power <- mutate(power,
                SubjGender = factor(SubjGender),
                HierarchyCond = factor(HierarchyCond),
                GenderCond = factor(GenderCond),
                Task = factor(Task))

# Sum-code the categorical predictors:

contrasts(power$SubjGender) <- contr.sum(2) / 2 * -1
contrasts(power$HierarchyCond) <- contr.sum(2) / 2 * -1
contrasts(power$GenderCond) <- contr.sum(2) / 2 * -1
contrasts(power$Task) <- contr.sum(2) / 2

# Rename these for shorter model formulas below:

power <- rename(power,
                Hierarchy = HierarchyCond,
                Gender = GenderCond)

# Setting priors. Regularizing priors on coefficients with SD = 0.2.

my_priors <- c(prior(normal(0, 0.2), class = b))

## Bayesian analysis, main model:

# To explain the model choices:

# * We need fixed effects for subject gender, task, hierarchy condition and gender condition.
# * We predict interactions between hierarchy and gender condition, as well as subject gender * hierarchy condition, and subject gender * gender condition, as well as the three-way interaction between these.
# * It's also possible that the hierarchy and gender conditions interact with task, which is something that we explore.
# * Task is a between-subject variable, so we can't have by-subject random slopes for this variable.

# Run the Bayesian regression, first test run:

main_mdl <- brm(LogRT ~ SubjGender + Task +
                  Hierarchy + Gender +
                  Hierarchy:Gender +
                  SubjGender:Hierarchy +
                  SubjGender:Gender +
                  Hierarchy:Gender:SubjGender +
                  Task:Hierarchy +
                  Task:Gender +
                  (1 + Hierarchy + Gender + Hierarchy:Gender|Subj) +
                  (1 + Hierarchy + Gender + Hierarchy:Gender|PairName),
                data = power,
                prior = my_priors,
                warmup = 200,
                iter = 500,
                chains = 4,
                cores = 4,
                init = 0,
                seed = 42)

# Run with gamma distribution with log link, test run:

gamma_log_mdl <- brm(RT ~ SubjGender + Task +
                  Hierarchy + Gender +
                  Hierarchy:Gender +
                  SubjGender:Hierarchy +
                  SubjGender:Gender +
                  Hierarchy:Gender:SubjGender +
                  Task:Hierarchy +
                  Task:Gender +                  
                  (1 + Hierarchy + Gender + Hierarchy:Gender|Subj) +
                  (1 + Hierarchy + Gender + Hierarchy:Gender|PairName),
                family = Gamma(link = 'log'),
                data = power,
                warmup = 200,
                iter = 500,
                chains = 4,
                cores = 4,
                init = 0,
                seed = 42)

# Save:

save(gamma_log_mdl, file = 'gamma_log_mdl.RData')

# Run with exgaussian distribution:

exgauss_mdl <- brm(RT ~ SubjGender + Task +
                  Hierarchy + Gender +
                  Hierarchy:Gender +
                  SubjGender:Hierarchy +
                  SubjGender:Gender +
                  Hierarchy:Gender:SubjGender +
                  Task:Hierarchy +
                  Task:Gender +
                  (1 + Hierarchy + Gender + Hierarchy:Gender|Subj) +
                  (1 + Hierarchy + Gender + Hierarchy:Gender|PairName),
                family = exgaussian,
                data = power,
                warmup = 200,
                iter = 500,
                chains = 4,
                cores = 4,
                init = 0,
                seed = 42)

# Save:

save(exgauss_mdl, file = 'exgauss_mdl.RData')

# Posterior predictive checks, ex-Gaussian:

pp_check(exgauss_mdl, nsamples = 100)

# Perform posterior predictive checks, Gamma distribution:

pp_check(gamma_log_mdl, nsamples = 100)

# Perform posterior predictive checks, Gaussian distribution:

pp_check(main_mdl, nsamples = 100)

# They are not massively different from each other, so we'll go with the simplest model, the Gaussian one. This also fits our audience, which is unlikely going to be familiar with these other distributions.

## Full model:

# Run the Bayesian regression:

main_mdl <- brm(LogRT ~ SubjGender + Task +
                  Hierarchy + Gender +
                  Hierarchy:Gender +
                  SubjGender:Hierarchy +
                  SubjGender:Gender +
                  Hierarchy:Gender:SubjGender +
                  Task:Hierarchy +
                  Task:Gender +
                  (1 + Hierarchy + Gender + Hierarchy:Gender|Subj) +
                  (1 + Hierarchy + Gender + Hierarchy:Gender|PairName),
                data = power,
                prior = my_priors,
                warmup = 2000,
                iter = 4000,
                chains = 4,
                cores = 4,
                init = 0,
                seed = 42)

# Save this model:

save(main_mdl, file = 'main_mdl.RData')

## Check the posterior predictios of this:

pp_check(main_mdl, nsamples = 100)
	# not perfect at all

# This completes this analysis.




