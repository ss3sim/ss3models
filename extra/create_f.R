###############################################################################
###############################################################################
#-----------------------------------------------------------------------------#
####Author     : Kelli Faye Johnson
####Contact    : kellifayejohnson@gmail.com
####Lastupdate : 2015-02-03
####Purpose    : Obtain Fmsy and write associated case files
####Packages   : ss3sim
####Inputs     :
####Outputs    :
####Remarks    : Character width = 80
## Modified 2/10/15 by Cole to fix fmsytable and make plots for checking
## Modified 2/20/15 by Cole to make paths work with installed package, not
## cloned git repo. Also changed bounds for F values based on M, and added
## NatM to the plot/table...
## Modified 2/24 by Cole for minor tweaks to models and did relative catch
#-----------------------------------------------------------------------------#
###############################################################################
###############################################################################

###############################################################################
###############################################################################
#### Step 01
#### This file assumes you are in the working directory of "ss3models"
#### All variable inputs are located in Step 01, nothing else should need
#### any alteration to run this file as long as "ss3sim/ss3models" is
#### cloned from github.
###############################################################################
###############################################################################
start <- 1
end <- 100
start.fishery <- 26
years.rup <- 40

###############################################################################
###############################################################################
#### Step 02
#### Load libraries and find folders
###############################################################################
###############################################################################
library(ss3sim)
library(r4ss)
library(ggplot2)
library(plyr)

# If you are a developer uncomment this line
# devtools::load_all("MUST TYPE IN PATH TO CLONED VERSION OF SS3MODELS")
library(ss3models)

modelnames <- dir(system.file("models", package = "ss3models"))
foldername <- file.path(dir(file.path(
  system.file("models", package = "ss3models")), full.names = TRUE), "om")

###############################################################################
###############################################################################
#### Step
#### Get Fmsy
###############################################################################
###############################################################################
fmsy <- list()
## We need a list of F ranges since they vary pretty widely
truem <- vector(length = length(modelnames))
for (ind in seq_along(truem)) {
  om <- dir(foldername[ind], pattern = ".ctl", full.names = TRUE)
  pars <- SS_parlines(om)
  truem[ind] <- pars[grep("NatM", pars$Label), "INIT"]
}
truem.df <- data.frame(species=modelnames, NatM=truem)
F.start <- truem*.05#sapply(truem, function(x) ifelse(x > 0.25, 0.8, 0.015))
F.end <- truem*6 #sapply(truem, function(x) ifelse(x > 0.25, 1.6, 0.4))

N.steps <- 50
for (m in seq_along(modelnames)) {
  dir.results <- file.path("fmsy", modelnames[m])
  dir.create(dir.results, recursive = TRUE, showWarnings = FALSE)
  byval <- (F.end[m]-F.start[m])/N.steps
  fmsy[[m]] <- profile_fmsy(om_in = foldername[m], results_out = dir.results,
    simlength = 100, start = F.start[m], end = F.end[m], by_val = byval,
    ss_mode = "safe")
}

names(fmsy) <- modelnames
fmsytable.full <-
    ldply(fmsy, mutate,
          maxcatch= max(eqCatch),
          relative_catch=eqCatch/maxcatch,
          ## for one of the models this wasn't unique so took first one
          fmsy=fValues[which.max(eqCatch)[1]],
          catch90=0.90 * maxcatch,
          fmsy90l=fValues[which(eqCatch > catch90)][1],
          fmsy90r=fValues[rev(which(eqCatch > catch90))][1])
fmsytable.full$species <- gsub("-om", "", fmsytable.full$.id)
fmsytable.full <- merge(fmsytable.full, y=truem.df, by="species")
fmsytable.full$.id <- NULL
g <- ggplot(fmsytable.full) + geom_line(aes(fValues, relative_catch))+
    facet_wrap("species", scales="free_x") +
    ggtitle("Catch Curves for models") + xlab("Fishing Effort (F)") +
    ylab("Relative Equilibrium Catch")+
    geom_point(aes(x=fmsy, y=1)) +
    geom_hline(aes(yintercept=catch90/maxcatch), col="blue") +
    geom_vline(aes(xintercept=fmsy90r), col="gray") +
    geom_vline(aes(xintercept=fmsy), col="black") +
    geom_vline(aes(xintercept=fmsy90l), col="gray") +
    geom_vline(aes(xintercept=NatM), col="red")
ggsave(file.path("plots/catch_curves.png"),g, width = 9, height = 7)
## Pare down to just the meta data
fmsytable <- unique(subset(fmsytable.full, select=-c(fValues, eqCatch, relative_catch)))
write.csv(fmsytable, file.path("fmsy", "fmsytable.full.csv"))


###############################################################################
###############################################################################
#### Step
#### # F == Fishing mortality
###############################################################################
###############################################################################
#' Write case files for \pkg{ss3sim} fishing mortality -- Case F

#' @param start Starting year of the simulation.
#' @param end Ending year of the simulation.
#' @param fvals Levels of fishing mortality for every year in the simulation.
#' @param species A species deliminator corresponding to the OM name.
#' @param case The case number you want assigned, e.g., F0.
#' @param comment A character string with # as the first value, which will be
#'   used to comment the created text file.
writeF <- function(start = 1, end = 100, fvals, species, case,
                   comment = "# Casefile autogenerated using create_f.R") {
    sink(paste0("F", case, "-", species, ".txt"))
    on.exit(sink())
    cat(comment)
    cat("years; c(", paste(start:end, collapse = ", "), ")\n",
        "years_alter; c(", paste(start:end, collapse = ", "), ")\n",
        "fvals; c(", paste(fvals, collapse = ", "), ")\n", sep = "")
}

###############################################################################
###############################################################################
#### Step
####
###############################################################################
###############################################################################
wd.curr <- getwd()
years.burnin <- start.fishery - start
years.fish <- end + start - start.fishery
years.rdown <- length(start:end) - (years.burnin + years.rup)
comment <- paste0("# Casefile autogenerated using create_f.R, a script in \n",
                  "# ss3sim/ss3models/extra\n")
comment0 <- paste0("# Constant F, at Fmsy for 75 years\n")
comment1 <- paste0("# Two-way trip F, increasing to Fmsy (right limb) for, ",
                   years.rup, "years.\n",
                   "# Then decreasing to Fmsy (left limb) for ", years.rdown,
                   "years.\n")
comment2 <- paste0("# One-way trip F, increasing to Fmsy (right limb) for 75\n")


setwd(system.file("cases", package = "ss3models"))
print(paste("writing F case files to", getwd()))
for (spp in seq_along(modelnames)) {
    ## Some species are special cases and we need to scale the whole F
    ## sequence down to improve convergence. So far just hake and mackerel
    ## models
    scal <- ifelse(length(grep("hake|mackerel",modelnames[spp]))>0, .6, 1)
    print(paste(modelnames[spp], "scalar =", scal))
    writeF(fvals = scal*c(rep(0, years.burnin), rep(fmsytable[spp, "fmsy"], years.fish)),
           species = fmsytable$species[spp], case = 0,
           comment = paste0(comment, comment0))
    writeF(fvals = scal*c(rep(0, years.burnin),
                     seq(0, fmsytable[spp, "fmsy90r"], length.out = years.rup),
                     seq(fmsytable[spp, "fmsy90r"], fmsytable[spp, "fmsy90l"],
                         length.out = years.rdown)),
           species = fmsytable$species[spp], case = 1,
           comment = paste0(comment, comment1))
    writeF(fvals = scal*c(rep(0, years.burnin),
                     seq(0, fmsytable[spp, "fmsy90r"], length.out = years.fish)),
           species = fmsytable$species[spp], case = 2,
           comment = paste0(comment, comment2))
}
setwd(wd.curr)
