This folder contains model files and case files when using the age-based selectivity and maturity (instead of length-based) through [ss3sim](https://github.com/ss3sim/ss3sim) package.
This should be the models to start with for ALL groups (and then modify as needed)
=======================

Specific changes: 
1. Age based selectivity (using double normal but parametrized to mimic a logistic curve)
2. Age based logistic maturity 
3. Years span from 1:100
4. Wider bounds for EM models (based on Kelli's approach: lower bounds = 0.5% of init values, upper bounds = 500% of init values)
5. Changed the "F" case files to reflect the pop dyn of these new models


Current contributors: the Fish600 team
