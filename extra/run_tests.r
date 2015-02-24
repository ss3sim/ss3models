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
load_all("c:/Users/Cole/ss3sim/")
load_all("c:/Users/Cole/ss3models/")
library(ss3sim)
library(ss3models)
## install.packages(c("doParallel", "foreach"))
library(doParallel)
registerDoParallel(cores = 4)
# require(foreach)
getDoParWorkers()

### ------------------------------------------------------------
### Deterministic tests for the models, to test for basic functionality,
### not individual study functionality. Models should pass these tests
### before trying more advanced scenarios, particularly new ones.

## Setup cases and models
case_folder <- system.file("cases", package = "ss3models")
## modelnames <- dir(pattern = "om$", full.names = FALSE)[1:2]
model_names <- c("hake", "yellow", "mackerel")[1]
## These are the high data cases used for deterministic testing. Write them
## for each model to be tested. Age and length comps.
index100 <- c('fleets;2', 'years;list(seq(50,100, by=2))', 'sds_obs;list(.01)')
lcomp100 <- c('fleets;c(1,2)', 'years;list(seq(50,100, by=2), seq(50,100, by=2))', 'Nsamp;list(500, 500)', 'cpar;NA')
agecomp100 <- c('fleets;c(1,2)', 'years;list(seq(50,100, by=2),seq(50,100, by=2))', 'Nsamp;list(500, 500)', 'cpar;NA')
for(species in model_names){
    writeLines(index100, con=paste0(case_folder,"/", "index100-", species, ".txt"))
    writeLines(lcomp100, con=paste0(case_folder,"/", "lcomp100-", species, ".txt"))
    writeLines(agecomp100, con=paste0(case_folder,"/", "agecomp100-", species, ".txt"))
}
scen.all <- expand_scenarios(species=model_names, cases=list(D=100, F=1))

## Loop through all of the species and run Nsim deterministic iterations
Nsim <- 40
user.recdevs <- matrix(rnorm(Nsim*100,0, .01), nrow=100)
for(i in 1:length(model_names)){
    spp <- model_names[i]
    print(paste("starting model", spp))
    scen <- expand_scenarios(species=spp, cases=list(D=100, F=1))
    om.dir <- ss3model(spp, "om"); em.dir <- ss3model(spp, "em")
    case_files <- list(F="F", D=c("index", "lcomp", "agecomp"))
    run_ss3sim(iterations=1:Nsim, scenarios=scen, parallel=TRUE,
               parallel_iterations=TRUE, case_folder=case_folder,
               user_recdevs=user.recdevs,
               om_dir=om.dir, em_dir=em.dir, case_files=case_files)
}
## Read in and save data
get_results_all(user=scen.all, parallel=TRUE, over=TRUE)
file.copy("ss3sim_scalar.csv", "det_sc.csv", over=TRUE)
file.copy("ss3sim_ts.csv", "det_ts.csv", over=TRUE)
file.rename(scen.all, paste0(scen.all, "-det"))
## Now do the same but with process error
for(i in 1:length(model_names)){
    spp <- model_names[i]
    print(paste("starting model", spp))
    scen <- expand_scenarios(species=spp, cases=list(D=100, F=1))
    om.dir <- ss3model(spp, "om"); em.dir <- ss3model(spp, "em")
    case_files <- list(F="F", D=c("index", "lcomp", "agecomp"))
    run_ss3sim(iterations=1:Nsim, scenarios=scen, parallel=TRUE,
               parallel_iterations=TRUE, case_folder=case_folder,
               ## user_recdevs=user.recdevs,
               om_dir=om.dir, em_dir=em.dir, case_files=case_files)
}
## Read in and save data
get_results_all(user=scen.all, parallel=TRUE, over=TRUE)
file.copy("ss3sim_scalar.csv", "sto_sc.csv", over=TRUE)
file.copy("ss3sim_ts.csv", "sto_ts.csv", over=TRUE)
file.rename(scen.all, paste0(scen.all, "-sto"))
## unlink(c(paste0(scen.all, "-sto"), paste0(scen.all, "-det")), TRUE)

## Quick plots
sto.sc <- read.csv("sto_sc.csv")
sto.sc$process_error <- "stochastic"
det.sc <- read.csv("det_sc.csv")
det.sc$process_error <- "deterministic"
results.sc <- rbind(sto.sc, det.sc)
results.sc <- calculate_re(results.sc, add=TRUE)
results.sc$log_max_grad <- log(results.sc$max_grad)
re.names <- names(results.sc)[grep("_re", names(results.sc))]
growth.names <- re.names[grep("GP_", re.names)]
selex.names <- re.names[grep("Sel_", re.names)]
management.names <- c("SSB_MSY_re", "depletion_re", "SSB_Unfished_re", "Catch_endyear_re")
results.sc.long <-
    melt(results.sc, measure.vars=re.names,
         id.vars= c("species", "process_error", "replicate",
         "log_max_grad", "params_on_bound_em"))
results.sc.long.growth <- droplevels(subset(results.sc.long, variable %in% growth.names))
results.sc.long.selex <- droplevels(subset(results.sc.long, variable %in% selex.names))
results.sc.long.management <- droplevels(subset(results.sc.long, variable %in% management.names))
g <- plot_scalar_points(results.sc.long.growth, x="variable", y='value',
                   horiz='species', vert="process_error", rel=TRUE, color='log_max_grad')+
    theme(axis.text.x=element_text(angle=90))
ggsave("plots/sc.growth.png",g, width=9, height=7)
g <- plot_scalar_points(results.sc.long.selex, x="variable", y='value',
                   horiz='species', vert="process_error", rel=TRUE, color='log_max_grad')+
    theme(axis.text.x=element_text(angle=90))
ggsave("plots/sc.selex.png", g, width=9, height=7)
g <- plot_scalar_points(results.sc.long.management, x="variable", y='value',
                   horiz='species', vert="process_error", rel=TRUE, color='log_max_grad')+
    theme(axis.text.x=element_text(angle=90))
ggsave("plots/sc.management.png",g, width=9, height=7)
g <- ggplot(results.sc, aes(x=depletion_om, y=log_max_grad))+geom_point() +
    geom_hline(yintercept=log(.01), color="red") +
    facet_grid(species~process_error)
ggsave("plots/sc.convergence.png",g, width=9, height=7)
plyr::ddply(results.sc.long, .(species, process_error), summarize,
            median.logmaxgrad=round(median(log_max_grad),2),
            max.stuck.on.bounds=max(params_on_bound_em))
ggplot(results.sc, aes(x=process_error, y=log_max_grad))+geom_violin()+
    facet_wrap("species")+geom_hline(yintercept=log(.01), col='red')

## make time series plots
sto.ts <- read.csv("sto_ts.csv")
sto.ts$process_error <- "stochastic"
det.ts <- read.csv("det_ts.csv")
det.ts$process_error <- "deterministic"
results.ts <- rbind(sto.ts, det.ts)
results.ts <- calculate_re(results.ts, add=TRUE)
results.ts <-
    merge(x=results.ts, y= subset(results.sc,
     select=c("ID", "params_on_bound_em", "log_max_grad")), by="ID")
re.names <- names(results.ts)[grep("_re", names(results.ts))]
results.ts.long <-
    melt(results.ts, measure.vars=re.names,
         id.vars= c("ID","species", "process_error", "replicate",
         "log_max_grad", "params_on_bound_em", "year"))
g <- plot_ts_lines(results.ts.long,  y='value', vert="variable", vert2="process_error",
                   horiz='species', rel=TRUE, color='log_max_grad')
ggsave("plots/ts.results.png", g, width=9, height=7)
g <- plot_ts_lines(results.ts, y="SpawnBio_om", horiz="species",
                   vert="process_error", color="log_max_grad")
ggsave("plots/ts.convergence.png", g, width=9, height=7)

## End of test runs. Check plots and table make sure everything looks
## good before deleting the runs. You may need them for investigations of
## issues

## Clean up folder
file.remove(c(paste0(scen,"-sto"),paste0(scen,"-det")))
file.remove(c("ss3sim_scalars.csv", "ss3sim_ts.csv", "det_sc.csv",
              "det_ts.csv", "sto_sc.csv", "sto_ts.csv"))
### ------------------------------------------------------------

### ------------------------------------------------------------
## Some other random checks of plots we wanted to do
res.all <- rbind(read.csv("scalar_hake.csv"),
                 read.csv("scalar_mackerel.csv"),
                 read.csv("scalar_yellow.csv"))
ggplot(res.all, aes(x=species, y=depletion_om))+geom_boxplot()+ ylim(0,1)

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
