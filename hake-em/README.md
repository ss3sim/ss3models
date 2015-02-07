# Hake estimation model

TODO add a brief description

Estimation model is set up generally to mimic the cod model.

Initial work was by @allanhicks, @peterkuriyama and probably many others I'm not aware of. @seananderson made finishing touches adapting the models for ss3sim.

### Remaining discrepancies with the cod EM

- [ ] `_maturity_option`: set to 2 (age logistic) in hake model and 1 (length logistic) in cod model
- [ ] Should we set the priors on the selectivity parameters to match the `INIT` values? They currently don't in the hake model.
- [ ] See the values for `#_Pattern Discard Male Special`. These are set to `0` in the cod model but were set to `24` in the hake model. I set them to `0`. Not sure what `24` would do.
- [ ] There are 4 columns of `lambdas` in the cod model but only 1 in the hake model. Looks like these are for different phases, so should there be 5 or is one column repeated as needed? I used 5.
