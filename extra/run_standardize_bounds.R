library(devtools)
install_github("r4ss/r4ss", ref = "master")
install_github("ss3sim/ss3models")
install_github("ss3sim/ss3sim")
library(r4ss)
library(ss3sim)
library(ss3models)

temp_path <- file.path(tempdir(), "ss3models")
dir.create(temp_path, showWarnings = FALSE)
wd <- getwd()
setwd(temp_path)

## Set to the path and filename of the OM and EM control files
## This doesn't work for me. 
file.copy(system.file("inst", "models", "cod", package = "ss3models"),
          ".", recursive = TRUE)
ctlom <- system.file("inst", "models", "cod", "om","ss3.ctl",
                     package = "ss3models")

mod.path<-"~/GitHub/ss3models/inst/models"
#Don't standardize age-structured mackerel or yelloweye
models.to.standardize<-dir(getwd())[-c(4,6,8)]
paths<-file.path(mod.path,models.to.standardize)
om.paths<-file.path(paths,"om/ss3.ctl")
em.paths<-file.path(paths,"em/ss3.ctl")



  # Use SS_parlines to get the proper names for parameters for the data frame
om.pars<-em.pars<-vector("list")
for(i in 1:length(om.paths)){
  om.pars[[i]] <- SS_parlines(ctlfile = om.paths[i])
  em.pars[[i]] <- SS_parlines(ctlfile = em.paths[i])
}

  #From the Johnson et al paper
  lo.percent<-c(rep(0.05, 3), rep(0.01, 2),4,rep(-20,2),.1,0,.1,0)
  hi.percent<-c(rep(5,3),rep(.5,2),rep(20,3),2,5,2,5)
  #Populate data frame using EM parameter names and percentages from the
  # Johnson et al (2015) paper
  #Indices are the parameters you want to modify
  parlines <- c(2:6,17,25:27,29,33,35)
  percent.df <- data.frame(
    Label = as.character(em.pars[[1]][parlines, "Label"]),
    lo = lo.percent, hi = hi.percent)
  newpars<-vector("list")

for(i in 1:length(om.paths)){
  standardize_bounds(percent_df = percent.df, dir = paths[i],
                     em_ctl_file = "em/ss3.ctl")

}
