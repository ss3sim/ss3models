### This folder contains model files and case files when using the age-based selectivity and maturity (instead of length-based) through [ss3sim](https://github.com/ss3sim/ss3sim) package.

### This should be the models to start with for ALL groups (and then modify as needed)


# Specific changes: 
- 1. Age based selectivity (using double normal but parametrized to mimic a logistic curve) (last changed 10/28)
- 2. Age based logistic maturity (last changed 10/27)
- 3. Years span from 1:100 (last changed 10/27)
- 4. Wider bounds for EM models (based on Kelli's approach: lower bounds = 0.5% of init values, upper bounds = 500% of init values) (last changed 10/27)
- 5. Changed the "F" case files to reflect the pop dyn of these new models (last changed 10/28)
- 6. Added length based selectivity (double-normal) for cod, although the model is called "col". The bounds are still narrow on this model and need to be changed, but I (KFJ) need to focus on other things and will come back to this. If someone else wants to change it, then just remove this portion of the comment after completion. Casefiles for this model include F-0:2, where the F was calculated using profile_fmsy and 90% of the upper and lower limit as appropriate and defined by KO. The EM is logistic for both the survey and the fishery (i.e., not paramaterized as a double normal like the OM). (last changed 10/30/2014)

Current contributors: the Fish600 team
