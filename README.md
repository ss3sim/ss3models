# ss3sim models

This folder contains operating model (OM) and estimating model (EM) files and case files for use within the [ss3sim][ss3sim] package. [ss3sim][ss3sim] is an R package that facilitates flexible, rapid, and reproducible fisheries stock assessment simulation testing with the widely-used [Stock Synthesis 3][SS3] (SS3) statistical age-structured stock assessment framework.

### Base models (length-based selectivity)
  1. cos - length based double normal selectivity (mimicking logistic) in OM, length based double normal selectivity (mimicking logistic) in EM, narrow bounds
  2. fll - length based double normal selectivity (mimicking logistic) in OM, length based double normal selectivity (mimicking logistic) in EM, narrow bounds

### Additional models
  1. cod - age based double normal selectivity, age based logistic maturity
  2. col - length based double normal selectivity (mimicking logistic) in OM, length based logistic in EM, narrow bounds (WILL BE REMOVED SOON)
  3. fla - age based double normal selectivity, age based logistic maturity
  4. mac - mackerel model under development (in development by @peterkuriyama )
  5. yel - yellowtail rockfish model under development (in development by @merrillrudd)

### Specific changes: 
- [x] Years: 1-100
- [x] Selectivity: parameterized using a double normal to mimic logistic selectivity (2014-10-28)
   * Age based
   * Length based
- [x] Maturity:
   * Age based logistic maturity (2014-10-27)
- [] Standardize parameter bounds using [standardize_bounds](https://github.com/ss3sim/ss3sim/blob/master/R/standardize_bounds.R): approach used in [Johnson *et al*.][johnsonetal] (2015) of lower bounds = 0.5% of init values and upper bounds = 500% of init values
- [] Fishing case files: "F" case files for each model are based on Fmsy, which can be found with [profile_fmsy](https://github.com/ss3sim/ss3sim/blob/master/R/profile_fmsy.r).
   * F0 = Constant fishing at Fmsy: years 25 - 100 at Fmsy;
   * F1 = Two way trip: years 25 - 65 ramp up to 0.9 x Fmsy (right limb), years 66 - 100 ramp down from 0.9 x Fmsy (right limb) to 0.9 x Fmsy (left limb;
   * F2 = One way trip: years 25 - 100 ramp up to 0.9 x Fmsy (left limb).

Current contributors: the Fish600 team

[vignette]: https://dl.dropboxusercontent.com/u/254940/ss3sim-vignette.pdf
[paper]: http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0092725
[SS3]: http://nft.nefsc.noaa.gov/Stock_Synthesis_3.htm
[r-project]: http://www.r-project.org/
[SAFS]: http://fish.washington.edu/
[ss3sim]: https://github.com/ss3sim/ss3sim
[johnsonetal]: http://icesjms.oxfordjournals.org/content/early/2014/04/09/icesjms.fsu055.full.pdf?keytype=ref&ijkey=NEXmZIkz3289u3z)
