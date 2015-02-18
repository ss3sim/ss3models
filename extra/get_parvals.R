###############################################################################
###############################################################################
#-----------------------------------------------------------------------------#
####Author     : Kelli Faye Johnson
####Contact    : kellifayejohnson@gmail.com
####Lastupdate :
####Purpose    :
####Packages   :
####Inputs     :
####Outputs    :
####Remarks    : Character width = 80
#-----------------------------------------------------------------------------#
###############################################################################
###############################################################################
dir.main <- "c:/ss/ss3models"
setwd(dir.main)

library(r4ss)

modelfolder <- file.path(getwd(), "inst", "models")
setwd(modelfolder)
models <- dir()

results <- list()
for (mod in seq_along(models)) {
  ctl.in <- dir(file.path(models[mod], "om"), pattern = "ctl", full.names = TRUE)
  ctl.om <- SS_parlines(ctl.in)[, c("INIT", "Label")]
  ctl.in <- dir(file.path(models[mod], "em"), pattern = "ctl", full.names = TRUE)
  ctl.em <- SS_parlines(ctl.in)[,
    c("LO", "HI", "INIT", "PRIOR", "PR_type", "SD", "PHASE", "Label")]
  ctl.om$Label <- tolower(ctl.om$Label)
  ctl.em$Label <- tolower(ctl.em$Label)
  both <- merge(ctl.om, ctl.em, by = "Label", all = TRUE, suffixes = c(".om", ".em"),
    sort = TRUE)
  both <- both[, c(1, 3, 2, 5, 4, 9, 6:8)]
  both$model <- models[mod]
  results[[mod]] <- both
}

final <- do.call("rbind", results)
setwd(dir.main)
write.table(final, file.path("extra", "parlist.csv"), sep = ",", row.names = FALSE)