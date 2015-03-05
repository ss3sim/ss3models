<!-- README.md is generated from README.Rmd. Please edit that file and run
     `rmarkdown::render()` on this file. -->
ss3sim models
=============

[![Travis-CI Build Status](https://travis-ci.org/ss3sim/ss3models.png?branch=master)](https://travis-ci.org/ss3sim/ss3models)

This R package contains operating model (OM) and estimating model (EM) files and case files for use within the [ss3sim](https://github.com/ss3sim/ss3sim) package. [ss3sim](https://github.com/ss3sim/ss3sim) is an R package that facilitates flexible, rapid, and reproducible fisheries stock assessment simulation testing with the widely-used [Stock Synthesis 3](http://nft.nefsc.noaa.gov/Stock_Synthesis_3.htm) (SS3) statistical age-structured stock assessment framework.

Install the ss3models package with:

``` r
# install.packages("devtools")
devtools::install_github("ss3sim/ss3models")
library("ss3models")
```

The model setups are stored in the package in the [`inst/models`](inst/models) folder. The local file path to the operating models (`om` folders) and estimating models (`em` folders) can be accessed using the `ss3model` function:

``` r
ss3model("hake", "em")
#> "/Library/Frameworks/R.framework/Versions/3.1/Resources/library/ss3models/models/hake/em"
ss3model("flatfish", "om")
#> "/Library/Frameworks/R.framework/Versions/3.1/Resources/library/ss3models/models/flatfish/om"
```

You can get a list of all available models in R with:

``` r
list_models()
#>  [1] "cod"          "cod-age"      "flatfish"     "flatfish-age" "hake"        
#>  [6] "hake-age"     "mackerel"     "mackerel-age" "yellow"       "yellow-age"
```

The SS3 model setup files in the operating model folders are:

``` r
ss3model("hake", "om") %>%
  dir
#> [1] "forecast.ss" "ss3.ctl"     "ss3.dat"     "ss3.par"     "starter.ss"
```

SS3 files in the estimating model folders are:

``` r
ss3model("hake", "em") %>%
  dir
#> [1] "forecast.ss" "ss3.ctl"     "starter.ss"
```

The ss3models package also contains a couple helper functions for working with and checking model setups. For example:

``` r
system.file("models", package = "ss3models") %>%
  get_parvalues(write_csv = FALSE) %>%
  head
#>                  Label    LO INIT.om INIT.em  HI PHASE PRIOR PR_type   SD model
#> 1        cohortgrowdev -4.00     1.0     1.0 4.0    -4  0.00      -1  0.0   cod
#> 2      cv_old_fem_gp_1  0.01     0.1     0.1 0.5     5  0.10      -1  0.8   cod
#> 3    cv_young_fem_gp_1  0.01     0.1     0.1 0.5     3  0.10      -1  0.8   cod
#> 4    eggs/kg_inter_fem -3.00     1.0     1.0 3.0    -3  0.00      -1  0.0   cod
#> 5 eggs/kg_slope_wt_fem -3.00     0.0     0.0 4.0    -3  0.00      -1  0.0   cod
#> 6       initf_1fishery  0.00     0.0     0.0 2.0    -1  0.01       0 99.0   cod
```

You can test all the operating model setups (run them through SS3 with `-noest`) and run all the files through `ss3sim::check_data()` by running `devtools::test()` in the base `ss3models` folder.

If you also want to test the estimation model setups (run them through SS3 with `-nohess`) then uncomment the relevant code in [`tests/testthat/test-models.R`](tests/testthat/test-models.R). For now the code is commented out while we develop the models. They take a while to run.

Included models
---------------

### Base models (length-based selectivity)

1.  `cod`: (North Sea cod) length-based double normal selectivity (mimicking logistic) in OM, length-based double normal selectivity (mimicking logistic) in EM, narrow bounds

2.  `flatfish`: (yellow tail flounder) length-based double normal selectivity (mimicking logistic) in OM, length-based double normal selectivity (mimicking logistic) in EM, narrow bounds

3.  `yellow`: (yelloweye rockfish) length-based double normal selectivity (mimicking logistic) in OM, length-based double normal selectivity (mimicking logistic) in EM, length-based maturity. M increased to 0.08 to reduce % in plusgroup.

4.  `hake`: (Pacific hake) length-based double normal selectivity (mimicking logistic) in OM, length-based double normal selectivity (mimicking logistic) in EM, length-based maturity (slightly changed compared t o the original assessment to match the purpose of this simulation study)

5. `mackerel`: (Pacific mackerel) length-based double normal selectivity (mimicking logistic) in OM, length-based double normal selectivity (mimicking logistic) in EM, length-based maturity. Steepness reduced from 0.9 to 0.8 given convergence issues.

### Base models (age-based selectivity)

1.  `cod-age`: TODO

2.  `flatfish`: TODO

3.  `yellow-age`: (yelloweye rockfish) age-based double normal selectivity (mimicking logistic) in OM, age-based double normal selectivity (mimicking logistic) in EM, age-based maturity. M increased to 0.08 to reduce % in plusgroup.

4.  `hake-age`: (Pacific hake) age-based double normal selectivity (mimicking logistic) in OM, age-based double normal selectivity (mimicking logistic) in EM, age-based maturity (converted from the 'hake' model)

5.  `mackerel-age`: (Pacific mackerel) age-based double normal selectivity (mimicking logistic) in OM, age-based double normal selectivity (mimicking logistic) in EM, age-based maturity. Steepness reduced from 0.9 to 0.8 given convergence issues.

### Model summaries

Specific information for each model can be found in the [information document](https://github.com/ss3sim/growth_models/blob/master/extra/modelinfo.csv). Columns with todo in the name should be filled out with your initials once completed. All other columns pertain to information specific the parameterization of each model.

Eventually more summary data and descriptive plots will be available on the `README.md` files within each species folder.

### Paramerization

-   Selectivity: parameterized using a double normal to mimic logistic selectivity
-   age-based
-   length-based

-   Maturity:
     -   age-based logistic maturity
     -   length-based logistic maturity

### Additional changes done

-   [ ] lbin type = 3
-   [ ] population bin width must be divisible by the data bin width
-   [ ] years = 1:100
-   [ ] Standardize parameter bounds using [standardize\_bounds](https://github.com/ss3sim/ss3sim/blob/master/R/standardize_bounds.R): approach used in [Johnson *et al*. (2015)](http://icesjms.oxfordjournals.org/content/early/2014/04/09/icesjms.fsu055.full.pdf?keytype=ref&ijkey=NEXmZIkz3289u3z)) of lower bounds = 0.5% of init values and upper bounds = [ ] 500% of init values
-   [ ] Fishing case files: "F" case files for each model are based on Fmsy, which can be found with [profile\_fmsy](https://github.com/ss3sim/ss3sim/blob/master/R/profile_fmsy.r). Casefiles are automatically generated from the script [create\_f.R](https://github.com/ss3sim/growth_models/blob/master/create_f.R). Please rerun this script any time a new model is added.
-   F0 = Constant fishing at Fmsy (constant): years 25 - 100 at Fmsy;
-   F1 = Two way trip (contrast): years 25 - 65 ramp up to 0.9 x Fmsy (right limb), years 66 - 100 ramp down from 0.9 x Fmsy (right limb) to 0.9 x Fmsy (left limb;
-   F2 = One way trip (increase): years 25 - 100 ramp up to 0.9 x Fmsy (left limb).
