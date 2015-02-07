# Hake estimation model

TODO add a brief description

Estimation model is set up generally to mimic the cod model.

Initial work was by Allan Hicks, Peter Kuriyama, and probably others I'm not aware of at this point. Sean Anderson made finishing touches adapting the model setups for ss3sim.

### Remaining discrepancies with the cod EM

- [ ] `_maturity_option`: set to 2 (age logistic) in hake model and 1 (length logistic) in cod model
- [ ] --> this is something that caused confusion to many people (and even to myself) but the DEFAULT model for the cod like species is named 'cos' and not 'cod'. The 'cod' model is archaic and doesn't have ALL modifications. `_maturity_option` needs to be 1 in both OM and EM
- [ ] Should we set the priors on the selectivity parameters to match the `INIT` values? They currently don't in the hake model.
- [ ] --> the init are not used on any model but it could be a good thing to do if one day we decide to begin using these priors
- [ ] See the values for `#_Pattern Discard Male Special`. These are set to `0` in the cod model but were set to `24` in the hake model. I set them to `0`. Not sure what `24` would do.
- [ ] --> I think this was put by mistake. Thanks for noticing
- [ ] There are 4 columns of `lambdas` in the cod model but only 1 in the hake model. Looks like these are for different phases, so should there be 5 or is one column repeated as needed? I used 5.
- [ ] --> this is not used in the current model so we do not need to worry too much but I think we need 4 columns. The lambda controls the weight for each likelihood component. 
