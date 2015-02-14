# ss3sim models

This folder contains operating model (OM) and estimating model (EM) files and case files for use within the [ss3sim][ss3sim] package. [ss3sim][ss3sim] is an R package that facilitates flexible, rapid, and reproducible fisheries stock assessment simulation testing with the widely-used [Stock Synthesis 3][SS3] (SS3) statistical age-structured stock assessment framework.

**We are currently rearranging this repository into an R data package**

Install the R package with:

```R
# install.packages("devtools")
devtools::install_github("ss3sim/ss3models")
```

The model setups are installed with the package. The location of the operating models (`om` folders; OM) and estimation models (`em` folders; EM) can be accessed using `system.file()`:

```R
system.file("hake/om", package = "ss3models")
system.file("hake/em", package = "ss3models")
```

The SS3 model setup files in the operating model folders are:

```
starter.ss
ss3.ctl
ss3.dat
forecast.ss
```

SS3 files in the estimation model folders are:

```
starter.ss
ss3.ctl
forecast.ss
```

## Included models

### Base models (length-based selectivity)

1. `cod`: length-based double normal selectivity (mimicking logistic) in OM, length-based double normal selectivity (mimicking logistic) in EM, narrow bounds

2. `flatfish`: length-based double normal selectivity (mimicking logistic) in OM, length-based double normal selectivity (mimicking logistic) in EM, narrow bounds

3. `yellow`: (yellowtail flounder) length-based double normal selectivity (mimicking logistic) in OM, length-based double normal selectivity (mimicking logistic) in EM, length-based maturity

4. `hake`: length-based double normal selectivity (mimicking logistic) in OM, length-based double normal selectivity (mimicking logistic) in EM, length-based maturity (slightly changed compared t o the original assessment to match the purpose of this simulation study)

### Base models (age-based selectivity)

1. `cod-age`: TODO

2. `flatfish`: TODO

3. `yellow-age`: (yellowtail flounder) age-based double normal selectivity (mimicking logistic) in OM, age-based double normal selectivity (mimicking logistic) in EM, age-based maturity

4. `hake-age`: age-based double normal selectivity (mimicking logistic) in OM, age-based double normal selectivity (mimicking logistic) in EM, age-based maturity (converted from the 'hake' model)

### Model summaries

Specific information for each model can be found in the [information document][info.csv]. Columns with todo in the name should be filled out with your initials once completed. All other columns pertain to information specific the parameterization of each model.

Eventually more summary data and descriptive plots will be available on the `README.md` files within each species folder.

### Paramerization

- Selectivity: parameterized using a double normal to mimic logistic selectivity
  * age-based
  * length-based

- Maturity:
  * age-based logistic maturity
  * length-based logistic maturity

### TODO

- lbin type = 2
- population bin width must be divisible by the data bin width
- years = 1:100
- Standardize parameter bounds using [standardize_bounds](https://github.com/ss3sim/ss3sim/blob/master/R/standardize_bounds.R): approach used in [Johnson *et al*. (2015)][johnsonetal] of lower bounds = 0.5% of init values and upper bounds = 500% of init values
- Fishing case files: "F" case files for each model are based on Fmsy, which can be found with [profile_fmsy](https://github.com/ss3sim/ss3sim/blob/master/R/profile_fmsy.r). Casefiles are automatically generated from the script [create_f.R][fscript]. Please rerun this script any time a new model is added.
  * F0 = Constant fishing at Fmsy (constant): years 25 - 100 at Fmsy;
  * F1 = Two way trip (contrast): years 25 - 65 ramp up to 0.9 x Fmsy (right limb), years 66 - 100 ramp down from 0.9 x Fmsy (right limb) to 0.9 x Fmsy (left limb;
  * F2 = One way trip (increase): years 25 - 100 ramp up to 0.9 x Fmsy (left limb).

[vignette]: https://dl.dropboxusercontent.com/u/254940/ss3sim-vignette.pdf
[paper]: http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0092725
[SS3]: http://nft.nefsc.noaa.gov/Stock_Synthesis_3.htm
[r-project]: http://www.r-project.org/
[SAFS]: http://fish.washington.edu/
[ss3sim]: https://github.com/ss3sim/ss3sim
[johnsonetal]: http://icesjms.oxfordjournals.org/content/early/2014/04/09/icesjms.fsu055.full.pdf?keytype=ref&ijkey=NEXmZIkz3289u3z)
[info.csv]: https://github.com/ss3sim/growth_models/blob/master/extra/modelinfo.csv
[fscript]: https://github.com/ss3sim/growth_models/blob/master/create_f.R
