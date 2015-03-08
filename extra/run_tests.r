### ------------------------------------------------------------
## This file is used to run simple tests on the models. Mostly used during
## development.

## Last update: 2/11/15 by Cole to add determinstic runs for newest models
## 2/20/15 by Cole to tweak for the new package format and some other bugs
### ------------------------------------------------------------

## Startup the working environment
## ## Update the development tools, if you haven't recently
## update.packages(c('r4ss','knitr', 'devtools', 'roxygen2'))
## options(device = 'quartz')

## Load the neccessary libraries
library(devtools)
## install_github("r4ss/r4ss")
library(r4ss)
library(ggplot2)
library(plyr)
library(reshape2)
## install_github("ss3sim/ss3models")
## Install ss3sim package. Be sure to pull before installing
## devtools::install_github("ss3sim/ss3sim")
## load_all("f:/Cole/ss3sim/")
## load_all("f:/Cole/ss3models/")
devtools::install("f:/Cole/ss3sim/")
devtools::install("f:/Cole/ss3models/")
library(ss3sim)
library(ss3models)
## install.packages(c("doParallel", "foreach"))
library(doParallel)
registerDoParallel(cores = 5)
# require(foreach)
getDoParWorkers()

### ------------------------------------------------------------
### Deterministic tests for the models, to test for basic functionality,
### not individual study functionality. Models should pass these tests
### before trying more advanced scenarios, particularly new ones.

## Setup cases and models
case_folder <- system.file("cases", package = "ss3models")
model_names <- dir(path="../inst/models/", full.names = FALSE)
## model_names <- c("hake", "yellow", "mackerel")
## These are the high data cases used for deterministic testing. Write them
## for each model to be tested. Age and length comps.
index100 <- c('fleets;2', 'years;list(seq(50,100, by=2))', 'sds_obs;list(.01)')
lcomp100 <- c('fleets;c(1,2)', 'years;list(seq(50,100, by=2), seq(50,100, by=2))', 'Nsamp;list(500, 500)', 'cpar;NA')
agecomp100 <- c('fleets;c(1,2)', 'years;list(seq(50,100, by=2),seq(50,100, by=2))', 'Nsamp;list(500, 500)', 'cpar;NA')
index101 <- c('fleets;2', 'years;list(seq(50,101, by=2))', 'sds_obs;list(.01)')
lcomp101 <- c('fleets;c(1,2)', 'years;list(seq(26,100, by=2), seq(26,100, by=2))', 'Nsamp;list(500, 500)', 'cpar;NA')
agecomp101 <- c('fleets;c(1,2)', 'years;list(seq(26,100, by=2),seq(26,100, by=2))', 'Nsamp;list(500, 500)', 'cpar;NA')
for(species in model_names){
    writeLines(index100, con=paste0(case_folder,"/", "index100-", species, ".txt"))
    writeLines(lcomp100, con=paste0(case_folder,"/", "lcomp100-", species, ".txt"))
    writeLines(agecomp100, con=paste0(case_folder,"/", "agecomp100-", species, ".txt"))
    writeLines(index101, con=paste0(case_folder,"/", "index101-", species, ".txt"))
    writeLines(lcomp101, con=paste0(case_folder,"/", "lcomp101-", species, ".txt"))
    writeLines(agecomp101, con=paste0(case_folder,"/", "agecomp101-", species, ".txt"))
}
scen.all <- expand_scenarios(species=model_names, cases=list(D=100:101, F=1))

## Loop through all of the species and run for two high data cases with
## process error
Nsim <- 50
for(i in 1:length(model_names)){
    spp <- model_names[i]
    print(paste("starting model", spp))
    scen <- expand_scenarios(species=spp, cases=list(D=100:101, F=1))
    om.dir <- ss3model(spp, "om"); em.dir <- ss3model(spp, "em")
    case_files <- list(F="F", D=c("index", "lcomp", "agecomp"))
    run_ss3sim(iterations=1:Nsim, scenarios=scen, parallel=TRUE,
               parallel_iterations=TRUE, case_folder=case_folder,
               om_dir=om.dir, em_dir=em.dir, case_files=case_files,
               bias_adjust=TRUE, bias_nsim=15)
}
## Read in and save data
get_results_all(user=scen.all, parallel=TRUE, over=TRUE)
file.copy("ss3sim_scalar.csv", "det_sc.csv", over=TRUE)
file.copy("ss3sim_ts.csv", "det_ts.csv", over=TRUE)

## quickly manipulate results for plots
det.sc <- read.csv("det_sc.csv")
(scenario.counts <- ddply(det.sc, .(scenario), summarize, replicates=length(scenario)))
det.sc$log_max_grad <- log(det.sc$max_grad)
det.sc$converged <- ifelse(det.sc$max_grad<.1, "yes", "no")
det.sc <- calculate_re(det.sc, add=TRUE)
det.sc$runtime <- det.sc$RunTime
## species needs to be fixed due to the dash in the age ones; crazy stupid
## way to get around this for now
det.sc$species <-
    as.vector(do.call(rbind, lapply(strsplit(gsub("-age", "_age", det.sc$ID), '-'),
                 function(x) x[3])))
## Drop fixed params (columns of zeroes)
re.names <- names(det.sc)[grep("_re", names(det.sc))]
det.sc.long <-
    melt(det.sc, measure.vars=re.names, id.vars=
         c("species", "replicate", "converged", "D",
           "log_max_grad", "params_on_bound_em", "runtime"))
growth.names <- re.names[grep("GP_", re.names)]
det.sc.long.growth <- droplevels(subset(det.sc.long, variable %in% growth.names))
det.sc.long.growth$variable <- gsub("_Fem_GP_1_re|_re", "", det.sc.long.growth$variable)
selex.names <- re.names[grep("Sel_", re.names)]
det.sc.long.selex <- droplevels(subset(det.sc.long, variable %in% selex.names))
det.sc.long.selex$variable <- gsub("ery|ey|Size|_re", "", det.sc.long.selex$variable)
det.sc.long.selex$variable <- gsub("_", ".", det.sc.long.selex$variable)
management.names <- c("SSB_MSY_re", "depletion_re", "SSB_Unfished_re", "Catch_endyear_re")
det.sc.long.management <- droplevels(subset(det.sc.long, variable %in% management.names))
det.sc.long.management$variable <- gsub("_re", "", det.sc.long.management$variable)
## also look at the NLL values
NLL.names <- names(det.sc)[grep("NLL_.*_em",names(det.sc))]
NLL.names <- NLL.names[which(sapply(NLL.names, function(ii) sd(det.sc[,ii], na.rm=TRUE))>0)]
det.sc.long.NLL <-
    melt(det.sc, measure.vars=NLL.names, id.vars=
         c("species", "replicate", "converged", "D",
           "log_max_grad", "params_on_bound_em", "runtime"))
## center them so easier to plot
det.sc.long.NLL <- ddply(det.sc.long.NLL, .(D, species, variable), transform,
                         value.centered=value-min(value, na.rm=TRUE))
det.sc.long.NLL$variable <- gsub("NLL_|_em", "", det.sc.long.NLL$variable)


## Quick plots
g <- plot_scalar_points(det.sc.long.growth, x="variable", y='value',
                   horiz='species', vert="D", rel=TRUE,
                        color='log_max_grad', print=FALSE)+
    theme(axis.text.x=element_text(angle=90))
ggsave("plots/sc.growth.png",g, width=9, height=7)
g <- plot_scalar_points(det.sc.long.selex, x="variable", y='value',
                   horiz='species', vert="D", rel=TRUE,
                        color='log_max_grad', print=FALSE)+
    theme(axis.text.x=element_text(angle=90))
ggsave("plots/sc.selex.png", g, width=9, height=7)
g <- plot_scalar_points(det.sc.long.management, x="variable", y='value',
                   horiz='species', vert="D", rel=TRUE,
                        color='log_max_grad', print=FALSE)+
    theme(axis.text.x=element_text(angle=90))
ggsave("plots/sc.management.png",g, width=9, height=7)
g <- ggplot(det.sc, aes(x=D, y=log_max_grad, color=runtime, size=params_on_bound_em,))+
    geom_jitter()+
    facet_wrap('species')+
        geom_hline(yintercept=log(.01), col='red')
ggsave("plots/sc.convergence.png",g, width=9, height=7)
plyr::ddply(det.sc.long, .(species, D), summarize,
            median.logmaxgrad=round(median(log_max_grad),2),
            max.stuck.on.bounds=max(params_on_bound_em))
g <- ggplot(det.sc, aes(x=replicate, y=log_max_grad, color=species)) +
    geom_point()+
    facet_grid(D~.)
ggsave("plots/sc.replicate.convergence.png",g, width=9, height=7)

g <- ggplot(subset(det.sc.long.NLL, D=="D100"), aes(x=species, y=value.centered,
                                 color=converged, size=params_on_bound_em)) +geom_jitter() +
    facet_grid(variable~D, scales='free_y') +
    theme(axis.text.x=element_text(angle=90)) + ylab("NLL-min(NLL)")
ggsave("plots/sc.NLL.png",g, width=9, height=10)
g <- ggplot(subset(det.sc.long.NLL, D=="D100" & converged=="yes"), aes(x=species, y=value.centered,
                                 size=params_on_bound_em)) +geom_jitter() +
    facet_grid(variable~D, scales='free_y') +
    theme(axis.text.x=element_text(angle=90)) + ylab("NLL-min(NLL)")
ggsave("plots/sc.NLL_converged_only.png",g, width=9, height=10)


## make time series plots
det.ts <- read.csv("det_ts.csv")
det.ts <- calculate_re(det.ts, add=TRUE)
## species needs to be fixed due to the dash in the age ones; crazy stupid
## way to get around this for now
det.ts$species <-
    as.vector(do.call(rbind, lapply(strsplit(gsub("-age", "_age", det.ts$ID), '-'),
                 function(x) x[3])))
det.ts <-
    merge(x=det.ts, y= subset(det.sc,
     select=c("ID", "params_on_bound_em", "log_max_grad")), by="ID")
det.ts$converged <- ifelse(det.ts$log_max_grad<log(.1), "yes", "no")
re.names <- names(det.ts)[grep("_re", names(det.ts))]
det.ts.long <-
    melt(det.ts, measure.vars=re.names,
         id.vars= c("ID","species", "D", "replicate", "converged",
         "log_max_grad", "params_on_bound_em", "year"))
g <- plot_ts_lines(det.ts.long,  y='value', vert="variable", vert2="D",
                   horiz='species', rel=TRUE, color='log_max_grad', print=FALSE)
ggsave("plots/ts.results_lines.png", g, width=9, height=7)
g <- plot_ts_boxplot(det.ts.long,  y='value', vert="variable", vert2="D",
                   horiz='species', rel=TRUE, print=FALSE)
ggsave("plots/ts.results.png", g, width=9, height=7)
g <- plot_ts_lines(subset(det.ts, D=="D100"), y="SpawnBio_om", horiz="species",
                   vert="D", color="log_max_grad", print=FALSE)
ggsave("plots/ts.convergence.png", g, width=9, height=7)

## End of test runs. Check plots and table make sure everything looks
## good before deleting the runs. You may need them for investigations of
## issues

## Clean up folder
file.remove(scen.all)
file.remove(c("ss3sim_scalars.csv", "ss3sim_ts.csv", "det_sc.csv",
              "det_ts.csv"))
### ------------------------------------------------------------


## ## Run a few with ParmTrace turned on to see behavior of estimation
## trace.hake <- read.table("D100-E0-F1-hake/1/em/ParmTrace.sso", header=TRUE)
## trace.hake$LogObjFun <- log(trace.hake$ObjFun)
## trace.hake$ObjFun <- NULL
## n.half <- floor(nrow(trace.hake)/2)
## n <- nrow(trace.hake)
## trace.hake.recdevs1 <- trace.hake[1:n.half, grep("Phase|Iter|Main_Recr", x=names(trace.hake))]
## trace.hake.notrecdevs1 <- trace.hake[1:n.half, c(-grep("Main_Recr", x=names(trace.hake)))]
## trace.hake.recdevs2 <- trace.hake[n.half:n, grep("Phase|Iter|Main_Recr", x=names(trace.hake))]
## trace.hake.notrecdevs2 <- trace.hake[n.half:n, c(-grep("Main_Recr", x=names(trace.hake)))]
## trace.hake.notrecdevs.long1 <- melt(trace.hake.notrecdevs1, id.vars=c("Phase", "Iter"))
## trace.hake.recdevs.long1 <- melt(trace.hake.recdevs1, id.vars=c("Phase", "Iter"))
## trace.hake.notrecdevs.long2 <- melt(trace.hake.notrecdevs2, id.vars=c("Phase", "Iter"))
## trace.hake.recdevs.long2 <- melt(trace.hake.recdevs2, id.vars=c("Phase", "Iter"))
## g <- ggplot(trace.hake.recdevs.long1, aes(Iter, value, color=Phase, group=variable))+ geom_line()
## ggsave("plots/hake_traces1_recdevs.png", g, width=12, height=6)
## g <- ggplot(trace.hake.notrecdevs.long1, aes(Iter, value, color=Phase))+
##     geom_line()+facet_wrap("variable", scales="free_y")
## ggsave("plots/hake_traces1.png", g, width=15, height=7)
## g <- ggplot(trace.hake.recdevs.long2, aes(Iter, value, color=Phase, group=variable))+ geom_line()
## ggsave("plots/hake_traces2_recdevs.png", g, width=12, height=6)
## g <- ggplot(trace.hake.notrecdevs.long2, aes(Iter, value, color=Phase))+
##     geom_line()+facet_wrap("variable", scales="free_y")
## ggsave("plots/hake_traces2.png", g, width=15, height=7)

## trace.yel <- read.table("D100-E0-F1-yel/1/em/ParmTrace.sso", header=TRUE)
## trace.yel$LogObjFun <- log(trace.yel$ObjFun)
## trace.yel$ObjFun <- NULL
## n.half <- floor(nrow(trace.yel)/2)
## n <- nrow(trace.yel)
## trace.yel.recdevs1 <- trace.yel[1:n.half, grep("Phase|Iter|Main_Recr", x=names(trace.yel))]
## trace.yel.notrecdevs1 <- trace.yel[1:n.half, c(-grep("Main_Recr", x=names(trace.yel)))]
## trace.yel.recdevs2 <- trace.yel[n.half:n, grep("Phase|Iter|Main_Recr", x=names(trace.yel))]
## trace.yel.notrecdevs2 <- trace.yel[n.half:n, c(-grep("Main_Recr", x=names(trace.yel)))]
## trace.yel.notrecdevs.long1 <- melt(trace.yel.notrecdevs1, id.vars=c("Phase", "Iter"))
## trace.yel.recdevs.long1 <- melt(trace.yel.recdevs1, id.vars=c("Phase", "Iter"))
## trace.yel.notrecdevs.long2 <- melt(trace.yel.notrecdevs2, id.vars=c("Phase", "Iter"))
## trace.yel.recdevs.long2 <- melt(trace.yel.recdevs2, id.vars=c("Phase", "Iter"))
## g <- ggplot(trace.yel.recdevs.long1, aes(Iter, value, color=Phase, group=variable))+ geom_line()
## ggsave("plots/yel_traces1_recdevs.png", g, width=12, height=6)
## g <- ggplot(trace.yel.notrecdevs.long1, aes(Iter, value, color=Phase))+
##     geom_line()+facet_wrap("variable", scales="free_y")
## ggsave("plots/yel_traces1.png", g, width=15, height=7)
## g <- ggplot(trace.yel.recdevs.long2, aes(Iter, value, color=Phase, group=variable))+ geom_line()
## ggsave("plots/yel_traces2_recdevs.png", g, width=12, height=6)
## g <- ggplot(trace.yel.notrecdevs.long2, aes(Iter, value, color=Phase))+
##     geom_line()+facet_wrap("variable", scales="free_y")
## ggsave("plots/yel_traces2.png", g, width=15, height=7)

## trace.mac <- read.table("D100-E0-F1-mac/1/em/ParmTrace.sso", header=TRUE)
## trace.mac$LogObjFun <- log(trace.mac$ObjFun)
## trace.mac$ObjFun <- NULL
## n.half <- floor(nrow(trace.mac)/2)
## n <- nrow(trace.mac)
## trace.mac.recdevs1 <- trace.mac[1:n.half, grep("Phase|Iter|Main_Recr", x=names(trace.mac))]
## trace.mac.notrecdevs1 <- trace.mac[1:n.half, c(-grep("Main_Recr", x=names(trace.mac)))]
## trace.mac.recdevs2 <- trace.mac[n.half:n, grep("Phase|Iter|Main_Recr", x=names(trace.mac))]
## trace.mac.notrecdevs2 <- trace.mac[n.half:n, c(-grep("Main_Recr", x=names(trace.mac)))]
## trace.mac.notrecdevs.long1 <- melt(trace.mac.notrecdevs1, id.vars=c("Phase", "Iter"))
## trace.mac.recdevs.long1 <- melt(trace.mac.recdevs1, id.vars=c("Phase", "Iter"))
## trace.mac.notrecdevs.long2 <- melt(trace.mac.notrecdevs2, id.vars=c("Phase", "Iter"))
## trace.mac.recdevs.long2 <- melt(trace.mac.recdevs2, id.vars=c("Phase", "Iter"))
## g <- ggplot(trace.mac.recdevs.long1, aes(Iter, value, color=Phase, group=variable))+ geom_line()
## ggsave("plots/mac_traces1_recdevs.png", g, width=12, height=6)
## g <- ggplot(trace.mac.notrecdevs.long1, aes(Iter, value, color=Phase))+
##     geom_line()+facet_wrap("variable", scales="free_y")
## ggsave("plots/mac_traces1.png", g, width=20, height=12)
## g <- ggplot(trace.mac.recdevs.long2, aes(Iter, value, color=Phase, group=variable))+ geom_line()
## ggsave("plots/mac_traces2_recdevs.png", g, width=12, height=6)
## g <- ggplot(trace.mac.notrecdevs.long2, aes(Iter, value, color=Phase))+
##     geom_line()+facet_wrap("variable", scales="free_y")
## ggsave("plots/mac_traces2.png", g, width=20, height=12)



## library(r4ss)
## xx <- SS_output("D100-E0-F1-yel/1/om/", covar=FALSE, forecast=FALSE)
## yy <- SS_output("D100-E0-F1-yel/1/em/", covar=FALSE, forecast=FALSE)
## yy <- SS_plots(yy, png=TRUE, uncertainty=FALSE)
