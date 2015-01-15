setwd("F:/growth_models")

library(devtools)
install("F:/ss3sim")
library(ss3sim)
library(r4ss)

#'
# Find the data in the ss3sim package:
d <- getwd()
om <- paste0(d, "/fla-om")
em <- paste0(d, "/fla-em")
case_folder <- paste0(d, "/cases")

# Pull in file paths from the package example data:
case_files <-  list(F = "F", D =
    c("index", "lcomp", "agecomp"), E = "E", M = "M", R = "R", B="bin")
a <- get_caseargs(folder = case_folder, scenario =
"M0-F0-D6-R0-E0-B0-fla", case_files = case_files)


  calcomp_params=NULL; 
  wtatage_params=NULL;  mlacomp_params=NULL; 
  
  tc_params = NULL;  bin_params = NULL;  lc_params = NULL; 
  user_recdevs = NULL;  bias_adjust = FALSE; 
  bias_nsim = 5;  bias_already_run = FALSE;  hess_always = FALSE; 
  print_logfile = TRUE;  sleep = 0;  conv_crit = 0.2;  seed = 21;  
  
  
iterations = 1;  scenarios = "M0-F0-D6-R0-E0-cod"; 
f_params = a$F;  index_params = a$index;  lcomp_params = a$lcomp; 
agecomp_params = a$agecomp;  tv_params = a$tv_params;  retro_params =a$R;  estim_params = a$E;  om_dir = om;  em_dir= em






d <- system.file("extdata", package = "ss3sim")
f_in <- paste0(d, "/example-om/data.ss_new")
out <- change_bin(f_in, file_out = NULL,
  type = c("len", "age", "cal", "mla", "mwa"),
  fleet_dat = list(
    "len" = list(years = list(1:3, 1:3), fleets = 1:2),
    "age" = list(years = list(1:3, 1:3), fleets = 1:2),
    "cal" = list(years = list(1:3, 1:3), fleets = 1:2),
    "mla" = list(years = list(1:3, 1:3), fleets = 1:2),
    "mwa" = list(years = list(1:3, 1:3), fleets = 1:2)),
  bin_vector = list(
    "len" = seq(2, 8, 2),
    "age" = seq(2, 8, 2)),
  write_file = FALSE)
print(out$agebin_vector)
print(head(out$agecomp))
print(tail(out$agecomp))
print(head(out$MeanSize_at_Age_obs))
print(head(out$MeanSize_at_Age_obs))
