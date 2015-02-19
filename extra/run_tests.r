### ------------------------------------------------------------
## This file is used to run simple tests on the models. Mostly used during
## development.

## Last update: 2/11/15 by Cole to add determinstic runs for newest models
### ------------------------------------------------------------

## Startup the working environment
## ## Update the development tools, if you haven't recently
## update.packages(c('r4ss','knitr', 'devtools', 'roxygen2'))
## options(device = 'quartz')

## Load the neccessary libraries
library(devtools)
library(r4ss)
library(ggplot2)
library(plyr)
library(reshape2)
## Install ss3sim package. Be sure to pull before installing
## devtools::install("../ss3sim")
library(ss3sim)

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
case_folder <- 'cases'
## modelnames <- dir(pattern = "om$", full.names = FALSE)[1:2]
model_names <- c("hake", "yel", "mac")
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

## Loop through all of the species and run Nsim iterations
Nsim <- 15
user.recdevs <- matrix(rnorm(Nsim*100,0, .01), nrow=100)
results.sc <- results.ts <- list()
for(i in 1:length(model_names)){
    print(paste("starting model", model_names[i]))
    scen <- expand_scenarios(species=model_names[i], cases=list(D=100, F=1, E=0))
    om.dir <- paste0(model_names[i], "-om")
    em.dir <- paste0(model_names[i], "-em")
    case_files <-
        list(F = "F", D = c("index", "lcomp", "agecomp"), E="E")
    run_ss3sim(iterations = 1:Nsim, scenarios = scen, parallel=TRUE,
               parallel_iterations=TRUE, case_folder = case_folder, om_dir
               = om.dir, em_dir = em.dir, case_files = case_files,
               user_recdevs=user.recdevs)
    ## Read in and save key data for plotting
    get_results_all(user=scen, parallel=FALSE, over=TRUE)
    results.sc[[i]] <-
        subset(calculate_re(read.csv("ss3sim_scalar.csv"), add=TRUE),
               select=c("ID", "species", "D", "replicate", "L_at_Amin_Fem_GP_1_re","L_at_Amax_Fem_GP_1_re",
               "VonBert_K_Fem_GP_1_re","CV_young_Fem_GP_1_re", "CV_old_Fem_GP_1_re",
               "depletion_re", "SSB_MSY_re", "params_on_bound_em", "max_grad") )
    results.ts[[i]] <-
        subset(calculate_re(read.csv("ss3sim_ts.csv"), add=TRUE),
               select=c("ID","species", "D", "replicate", "year","SpawnBio_re",
               "Recruit_0_re", "F_re"))
    file.copy("ss3sim_scalar.csv", paste0("scalar_", model_names[i], ".csv"))
    file.copy("ss3sim_ts.csv", paste0("ts_", model_names[i], ".csv"))
    unlink(scen, TRUE); file.remove("ss3sim_scalar.csv", "ss3sim_ts.csv")
}

## Put all data together into long form for plotting
results.sc.long <- melt(do.call(rbind, results.sc), id.vars=
        c("ID","species", "D", "replicate", "max_grad", "params_on_bound_em"))
results.ts.long <- melt(do.call(rbind, results.ts), id.vars=c("ID","species", "D", "replicate", "year"))
results.ts.long <- merge(x=results.ts.long, y= subset(results.sc.long,
                         select=c("ID", "params_on_bound_em", "max_grad")),
                         by="ID")
levels(results.sc.long$variable) <- gsub("_Fem_GP_1_re|_re", "", levels(results.sc.long$variable))
levels(results.ts.long$variable) <- gsub("_re", "", levels(results.ts.long$variable))
plot_scalar_points(results.sc.long, x="variable", y='value',
                   horiz='species', rel=TRUE, color='max_grad')
ggsave("plots/new_models_scalars.png", width=9, height=7)
plot_ts_lines(results.ts.long, vert="variable", y='value', horiz='species',
              rel=TRUE, color="max_grad")
ggsave("plots/new_models_TS.png", width=9, height=7)
plyr::ddply(results.sc.long, .(species), summarize,
            median.maxgrad=round(median(max_grad),2),
            max.bounds=max(params_on_bound_em))
### End of deterministic runs. Check plots and table make sure everything
### looks good.
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
