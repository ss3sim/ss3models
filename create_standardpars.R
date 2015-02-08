###############################################################################
###############################################################################
#-----------------------------------------------------------------------------#
####Author     : Kelli Faye Johnson
####Contact    : kellifayejohnson@gmail.com
####Lastupdate :
####Purpose    : Standardize bounds of all estimating models
####Packages   : ss3sim
####Inputs     :
####Outputs    :
####Remarks    : Character width = 80
#-----------------------------------------------------------------------------#
###############################################################################
###############################################################################

###############################################################################
###############################################################################
#### Step 01
#### This file assumes you are in the working directory of "growth_models"
#### All variable inputs are located in Step 01, nothing else should need
#### any alteration to run this file as long as "ss3sim/growth_models" is
#### cloned from github.
###############################################################################
###############################################################################
stocksynthesisname <- "ss3_24o_safe.exe"

###############################################################################
###############################################################################
#### Step 02
#### Load libraries and find folders
###############################################################################
###############################################################################
library(r4ss)
library(ss3sim)

modelnames <- dir(pattern = "m$", full.names = FALSE)
foldername <- dir(getwd(), pattern = "m$", full.names = TRUE)
speciesname <- unique(sapply(strsplit(modelnames, "-"), "[[", 1))
oms <- grep("om", modelnames)
ems <- grep("em", modelnames)

# Set up a temporary directory
temp_path <- file.path(tempdir(), "ss3sim-standardize")
dir.create(temp_path, showWarnings = FALSE)
dir.master <- getwd()
###############################################################################
###############################################################################
#### Step
#### Loop through each model
###############################################################################
###############################################################################
for (spp in seq_along(speciesname)) {
  message(paste("Standardizing", speciesname[spp]))
  flush.console()
  # Copy folders and run model to make sure you are using ss_new
  folders <- grep(speciesname[spp], foldername, value = TRUE)
  modfolders <- sapply(strsplit(folders, "/"), "[[", 4)
  mapply(file.copy, folders, to = temp_path, recursive = TRUE, overwrite = TRUE)
  setwd(file.path(temp_path, modfolders[grep("om", modfolders)]))
  system(paste(stocksynthesisname, "-nohess -noest"),
         intern = FALSE, show.output.on.console = FALSE)
  ctl.om <- dir(pattern = "control.ss_new")
  om.pars <- SS_parlines(ctlfile = ctl.om)
  # Move the data.ss_new file to the EM folder
  datfile <- SS_readdat(file = "data.ss_new", section = 3, verbose = FALSE)
  SS_writedat(datfile,
    file.path("..", modfolders[grep("em", modfolders)], "dat.ss"),
    overwrite = TRUE, verbose = FALSE)
  # Copy the OM control file to temp_path
  nameom <- dir(foldername[oms][spp], pattern = "ctl")
  file.copy("control.ss_new", file.path("..", "newOM.ctl"))

  # Move to the EM folder
  setwd(file.path("..", modfolders[grep("em", modfolders)]))
  # Allow the model to run with data copied over from the OM
  starter <- readLines(dir(pattern = "starter"))
  starter[grep("\\.dat", starter)] <- "dat.ss"
  writeLines(starter, "starter.ss")
  system(paste(stocksynthesisname, "-nohess -noest"), intern = FALSE,
         show.output.on.console = FALSE)
  em.pars <- SS_parlines(ctlfile = dir(pattern = "control.ss_new"))
  # Copy the OM control file to temp_path
  nameem <- dir(foldername[ems][spp], pattern = "ctl")
  file.copy("control.ss_new", file.path("..", "newEM.ctl"))

  # Parameter names
  parabbrev <- c("NatM", "L_at", "VonBert", "CV_", "Sel")
  parnames <- unlist(sapply(parabbrev, grep, x = em.pars$Label, value = TRUE))
  parinits <- em.pars$INIT[em.pars$Label %in% parnames]

  # From the Johnson et al paper
  percents <- data.frame(lo = rep(0.5, length(parnames)),
    high = c(500, 1000, 1000, rep(500, length(parnames) - 3)))
  # Swap the percents for parameters that have negative initial values
  percents[parinits < 0, ] <- percents[parinits < 0, c(2, 1)]
  # Populate data frame using EM parameter names and percentages from the
  # Johnson et al paper
  percent.df <- data.frame(Label = parnames,
                           lo = percents[, "lo"], hi = percents[, "high"])
  percent.df.nosel <- percent.df[-grep("Sel", percent.df$Label), ]
  # To standardize bounds -- create a new directory with the OM and EM
  # ctl files and run the function w/o selectivity parameters to make sure
  # EM INITs are same as OM and standardize bounds, then run again with selectivity
  # parameters to just standardize bounds.
  if (exists("testing")) {
    detach("package:ss3sim", unload = TRUE)
    detach("package:r4ss", unload = TRUE)
    devtools::install_github("r4ss/r4ss", ref = "master")
    load_all("c:/ss/ss3sim")
    library(r4ss)
    load_all("c:/ss/r4ss")
  }
  standardize_bounds(percent_df = percent.df.nosel, dir = temp_path,
    em_ctl_file = "newEM.ctl", om_ctl_file = "newOM.ctl", verbose = FALSE, estimate = NULL)
  standardize_bounds(percent_df = percent.df, dir = temp_path,
    em_ctl_file = "newEM.ctl", verbose = FALSE, estimate = NULL)
  # Copy the files back to their respective directories
  # Need to change this so it finds the correct file
  setwd("..")
  permom <- file.path(grep(speciesname[spp], foldername[oms], value = TRUE), nameom)
  file.copy("newOM.ctl", permom, overwrite = TRUE)
  permem <- file.path(grep(speciesname[spp], foldername[ems], value = TRUE), nameem)
  file.copy("newEM.ctl", permem, overwrite = TRUE)
  done <- sapply(dir(), unlink, recursive = TRUE)
  setwd(dir.master)
}
