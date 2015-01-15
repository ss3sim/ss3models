### ------------------------------------------------------------
## This is the central R file for doing tests with ss3sim for the empirical
## group. The idea is that it uses the development branch of ss3sim and any
## development versions of R functions written here. At the end of the
## project this file will be converted into one to recreate the entire
## simulation. Any intermediate code should be saved by commenting it out
## and putting it at the end of the file. (We might want to incorporate it
## into a "how to test" type document later, so it's worth saving for now).

### ------------------------------------------------------------
## Startup the working environment
## ## Update the development tools, if you haven't recently
## update.packages(c('r4ss','knitr', 'devtools', 'roxygen2'))
options(device = 'quartz')

## Load the neccessary libraries
library(devtools)
library(r4ss)
library(ggplot2)

#Install ss3sim package. Be sure to pull before installing
devtools::install("F:/ss3sim")
library(ss3sim)

## install.packages(c("doParallel", "foreach"))
library(doParallel)
registerDoParallel(cores = 4)
# require(foreach)
getDoParWorkers()

### ------------------------------------------------------------
#Function for substr_r which for some reason is never around.
substr_r <- function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))
}

### ------------------------------------------------------------
setwd("F:/")

case_folder <- '../binning/cases'
d <- system.file("extdata", package = "ss3sim")
fla.om <- '../growth_models/fla-om'
fla.em <- '../growth_models/fla-em'

# bin.n <- 5
# bin.seq <- floor(seq(8, 40, len=bin.n))
# for(i in 1:bin.n){
#     x <- c(paste("bin_vector; list(len=seq(2, 86, length.out=", bin.seq[i],"))"),
#             "type;c('len', 'cal')", "pop_bin;NULL")
#     writeLines(x, con=paste0(case_folder, "/bin",i, "-fla.txt"))
# }
# scen.df <- data.frame(B.value=bin.seq, B=paste0("B", 1:bin.n))
# scen <- expand_scenarios(cases=list(D=100:103, E=0:1, F=0, B=1:bin.n),
#                          species="fla")

scen <- 'B0-D100-E0-F0-fla'
case_files <-  list(F = "F", D =
    c("index", "lcomp", "agecomp"), E = "E", B="bin")

get_caseargs(folder = case_folder, scenario = scen,
                  case_files = case_files)

run_ss3sim(iterations = 1, scenarios = scen,           
           case_folder = case_folder, om_dir = fla.om,
           em_dir = fla.em, case_files = case_files)

### ------------------------------------------------------------
#Check sample_wtatage function. Should be multinomial across ages and 
# mostly check that it works with ss3. 
#Get Flatfish running First

infile <- '/B0-D100-E1-F0-fla/1/om/wtatage.ss_new'
infile <- paste0(getwd(), infile)

outfile <- '/B0-D100-E1-F0-fla/1/om/out.dat'
outfile <- paste0(getwd(), outfile)

datfile <- '/B0-D100-E1-F0-fla/1/om/ss3.dat'
datfile <- paste0(getwd(), datfile)

ctlfile <- '/B0-D100-E1-F0-fla/1/om/om.ctl'
ctlfile <- paste0(getwd(), ctlfile)

fleets <- c(1, 2)

years <- list(c(78, 80, 85), c(76, 82, 90), c(85, 86, 89))


write_file = TRUE
fill_fnc <- fill_across
# fill_type <- 'First' #Fill missing values with first row of data










# #Problems
# #MLA Comp is going to be an issue with cod at least.
# #"needs to end in .dat" Wait is this writing a .dat file or wtatage file?
# #substr_r issue?
# #Not sure if fleets and years need to be the same lengths.
# #mla.means issue






# function (infile, outfile, datfile, ctlfile, fleets = 1, years, 
#     write_file = TRUE) 


# ### ------------------------------------------------------------
# #Run Test Cases

# d <- system.file("extdata", package = "ss3sim")

# #Define Cod Cases
# case_folder <- paste0(d, "/eg-cases")
# om <- paste0(d, "/models/cod-om")
# em <- paste0(d, "/models/cod-em")


# #Run Shit.
# run_ss3sim(iterations = 1:1, scenarios =
#              c("D0-E0-F0-R0-M0-cod",
#                "D1-E0-F0-R0-M0-cod",
#                "D0-E1-F0-R0-M0-cod",
#                "D1-E1-F0-R0-M0-cod"),
#            case_folder = case_folder, om_dir = om,
#            em_dir = em, bias_adjust = TRUE)









# #For Hake Here
# om <- "/Users/peterkuriyama/School/Research/capam_growth/allan_branch/models/hake-om-test"
# em <- "/Users/peterkuriyama/School/Research/capam_growth/allan_branch/models/hake-em"
# ## ## devtool tasks
# ## devtools::document('../ss3sim')
# ## devtools::run_examples("../ss3sim")
# ## devtools::check('../ss3sim', cran=TRUE)
# user.recdevs <- matrix(data=rnorm(100^2, mean=0, sd=.001),
#                        nrow=100, ncol=100)
# ### ------------------------------------------------------------
# #Run Hake Tests
 
# #Function to Hit Switch to Read WTATAGE

# run_ss3sim(iterations = 1:1, scenarios = 'D1-E0-F0-M0-R0-hak', 
#            case_folder = case_folder, om_dir = om, em_dir = em)










# ### ------------------------------------------------------------
# ### Preliminary bin analysis with cod across multiple data types
# ## WRite the cases to file
# bin.n <- 2
# bin.seq <- seq(2, 15, len=bin.n)
# for(i in 1:bin.n){
#     x <- c(paste("bin_vector; seq(2, 86, by=", bin.seq[i],")"),
#             "type;len", "pop_bin;NULL")
#     writeLines(x, con=paste0(case_folder, "/B",i, "-fla.txt"))
# }
# scen.df <- data.frame(B.value=bin.seq, B=paste0("B", 1:bin.n))
# scen <- expand_scenarios(cases=list(D=c(2:3), E=0, F=0, R=0,M=0, B=1:bin.n),
#                          species="fla")
# run_ss3sim(iterations = 1:1, scenarios = scen, parallel=TRUE,
#            case_folder = case_folder, om_dir = om,
#            em_dir = em, case_files = list(M = "M", F = "F", D =
#     c("index", "lcomp", "agecomp"), R = "R", E = "E", B="B"))

# ## Look at a couple of models closer using r4ss
# res.list <- NULL
# for(i in 1:length(scen)){
#     res.list[[i]] <- SS_output(paste0(scen[i], "/1/em"), covar=FALSE)
# }
# for(i in 1:length(scen)){
#     SSplotComps(res.list[[i]], print=TRUE)
# }
# for(i in 1:length(scen)){
#     SS_plots(res.list[[i]], png=TRUE, uncer=F, html=F)
# }

# ## Read in the results and convert to relative error in long format
# get_results_all(user_scenarios=scen, over=TRUE)
# file.copy("ss3sim_scalar.csv", "results/bin_datatest_scalar.csv", over=TRUE)
# file.copy("ss3sim_ts.csv", "results/bin_datatest_ts.csv", over=TRUE)
# results <- read.csv("results/bin_datatest_scalar.csv")
# em_names <- names(results)[grep("_em", names(results))]
# results_re <- as.data.frame(
#     sapply(1:length(em_names), function(i)
#            (results[,em_names[i]]- results[,gsub("_em", "_om", em_names[i])])/
#            results[,gsub("_em", "_om", em_names[i])]
#             ))
# names(results_re) <- gsub("_em", "_re", em_names)
# write.csv(results_re, "results_re_datatest.csv")
# results_re$B <- results$B
# results_re$D <- results$D
# results_re$replicate <- results$replicate
# results_re <- results_re[sapply(results_re, function(x) any(is.finite(x)))]
# results_re <- results_re[sapply(results_re, function(x) !all(x==0))]
# results_re <- results_re[, names(results_re)[-grep("NLL",names(results_re))]]
# results_long <- reshape2::melt(results_re, c("B", "D","replicate"))
# results_long <- merge(scen.df, results_long)
# results_long$B <- factor(results_long$B, levels=paste0("B", 1:bin.n))
# ## Make exploratory plots
# ggplot(subset(results_long, D=="D0"), aes(x=B.value, y=value, colour=D))+ ylab("relative error")+
#     geom_line(aes(group=replicate))+facet_wrap("variable", scales="fixed") + ylim(-1,1) +
#     xlab("bin width")
# ggsave("plots/bin_test_cod_D0.png", width=9, height=5)
# ggplot(subset(results_long, D=="D1"), aes(x=B.value, y=value, colour=D))+ ylab("relative error")+
#     geom_line(aes(group=replicate))+facet_wrap("variable", scales="fixed") + ylim(-1,1) +
#     xlab("bin width")
# ggsave("plots/bin_test_cod_D1.png", width=9, height=5)

# ## Clean up everything
# unlink(scen, TRUE)
# file.remove(c("ss3sim_scalar.csv", "ss3sim_ts.csv"))
# rm(results, results_re, results_long, scen.df, scen, em_names, bin.seq, bin.n, x, i)
# ## End of tail compression run
# ### ------------------------------------------------------------




# ### ------------------------------------------------------------
# ### Preliminary bin analysis with cod
# ## WRite the cases to file
# bin.n <- 5
# bin.seq <- seq(2, 15, len=bin.n)
# for(i in 1:bin.n){
#     x <- c(paste("bin_vector; seq(20, 150, by=", bin.seq[i],")"),
#             "type;len", "pop_bin;NULL")
#     writeLines(x, con=paste0(case_folder, "/B",i, "-cod.txt"))
# }
# (args <- ss3sim:::get_args('cases/B4-cod.txt'))
# (args <- ss3sim:::get_args('cases/lencomp1-cod.txt'))
# scen.df <- data.frame(B.value=bin.seq, B=paste0("B", 1:bin.n))
# scen <- expand_scenarios(cases=list(D=0:1, E=0, F=0, R=0,M=0, B=1:bin.n),
#                          species="cod")
# run_ss3sim(iterations = 1:1, scenarios = scen, parallel=TRUE,
#            case_folder = case_folder, om_dir = om,
#            em_dir = em, case_files = list(M = "M", F = "F", D =
#     c("index", "lcomp", "agecomp"), R = "R", E = "E", B="B"))
# ## Read in the results and convert to relative error in long format
# get_results_all(user_scenarios=scen, over=TRUE)
# file.copy("ss3sim_scalar.csv", "results/bin_test1_scalar.csv", over=TRUE)
# file.copy("ss3sim_ts.csv", "results/bin_test1_ts.csv", over=TRUE)
# results <- read.csv("results/bin_test1_scalar.csv")
# em_names <- names(results)[grep("_em", names(results))]
# results_re <- as.data.frame(
#     sapply(1:length(em_names), function(i)
#            (results[,em_names[i]]- results[,gsub("_em", "_om", em_names[i])])/
#            results[,gsub("_em", "_om", em_names[i])]
#             ))
# names(results_re) <- gsub("_em", "_re", em_names)
# results_re$B <- results$B
# results_re$D <- results$D
# results_re$replicate <- results$replicate
# results_re <- results_re[sapply(results_re, function(x) any(is.finite(x)))]
# results_re <- results_re[sapply(results_re, function(x) !all(x==0))]
# results_re <- results_re[, names(results_re)[-grep("NLL",names(results_re))]]
# results_long <- reshape2::melt(results_re, c("B", "D","replicate"))
# results_long <- merge(scen.df, results_long)
# results_long$B <- factor(results_long$B, levels=paste0("B", 1:bin.n))
# ## Make exploratory plots
# ggplot(subset(results_long, D=="D0"), aes(x=B.value, y=value, colour=D))+ ylab("relative error")+
#     geom_line(aes(group=replicate))+facet_wrap("variable", scales="fixed") + ylim(-1,1) +
#     xlab("bin width")
# ggsave("plots/bin_test_cod_D0.png", width=9, height=5)
# ggplot(subset(results_long, D=="D1"), aes(x=B.value, y=value, colour=D))+ ylab("relative error")+
#     geom_line(aes(group=replicate))+facet_wrap("variable", scales="fixed") + ylim(-1,1) +
#     xlab("bin width")
# ggsave("plots/bin_test_cod_D1.png", width=9, height=5)

# ## Clean up everything
# unlink(scen, TRUE)
# file.remove(c("ss3sim_scalar.csv", "ss3sim_ts.csv"))
# rm(results, results_re, results_long, scen.df, scen, em_names, bin.seq, bin.n, x, i)
# ## End of tail compression run
# ### ------------------------------------------------------------



# ### ------------------------------------------------------------
# ### Preliminary tail compression analysis with cod
# ## WRite the cases to file
# tc.n <- 10
# tc.seq <- seq(0, .25, len=tc.n)
# for(i in 1:tc.n){
#     tc <- tc.seq[i]
#     x <- c(paste("tail_compression;", tc), "file_in; ss3.dat", "file_out; ss3.dat")
#     writeLines(x, con=paste0(case_folder, "/T",i, "-cod.txt"))
# }
# scen.df <- data.frame(T.value=c(-.001,tc.seq), T=paste0("T", 0:tc.n))
# scen <- expand_scenarios(cases=list(D=0, E=0, F=0, R=0,M=0, T=0:tc.n), species="cod")
# ## Run them in parallel
# ## RUns parallel=F but not TRUE??????
# run_ss3sim(iterations = 1:10, scenarios = scen, parallel=TRUE,
#            case_folder = case_folder, om_dir = om,
#            em_dir = em, case_files = list(M = "M", F = "F", D =
#     c("index", "lcomp", "agecomp"), R = "R", E = "E", T="T"))
# ## Read in the results and convert to relative error in long format
# get_results_all(user_scenarios=scen)
# file.copy("ss3sim_scalar.csv", "results/tc_test1_scalar.csv", over=TRUE)
# file.copy("ss3sim_ts.csv", "results/tc_test1_ts.csv", over=TRUE)
# results <- read.csv("results/tc_test1_scalar.csv")
# em_names <- names(results)[grep("_em", names(results))]
# results_re <- as.data.frame(
#     sapply(1:length(em_names), function(i)
#            (results[,em_names[i]]- results[,gsub("_em", "_om", em_names[i])])/
#            results[,gsub("_em", "_om", em_names[i])]
#            ))
# names(results_re) <- gsub("_em", "_re", em_names)
# results_re$replicate <- results$replicate
# results_re$T <- results$T
# results_re <- results_re[sapply(results_re, function(x) any(is.finite(x)))]
# results_re <- results_re[sapply(results_re, function(x) !all(x==0))]
# results_re <- results_re[, names(results_re)[-grep("NLL",names(results_re))]]
# results_long <- reshape2::melt(results_re, c("T", "replicate"))
# results_long <- merge(scen.df, results_long)
# results_long$T <- factor(results_long$T, levels=paste0("T", 0:tc.n))
# ## Make exploratory plots
# ggplot(results_long, aes(x=T.value, y=value))+ ylab("relative error")+
#     geom_line(aes(group=replicate))+facet_wrap("variable", scales="fixed") + ylim(-1,1) +
#     xlab("tail compression value")
# ggsave("plots/tc_test1.png", width=10, height=7)
# ## Clean up everything
# unlink(scen, TRUE)
# file.remove(c("ss3sim_scalar.csv", "ss3sim_ts.csv"))
# rm(results, results_re, results_long, scen.df, scen, em_names, tc.seq, tc, x, i)
# ## End of tail compression run
# ### ------------------------------------------------------------

# ### ------------------------------------------------------------
# ### Preliminary lcomp constant analysis with cod
# ## WRite the cases to file
# lc.n <- 10
# lc.seq <- seq(1e-7, .1, len=lc.n)
# for(i in 1:lc.n){
#     lc <- lc.seq[i]
#     x <- c(paste("lcomp_constant;", lc), "file_in; ss3.dat", "file_out; ss3.dat")
#     writeLines(x, con=paste0(case_folder, "/C",i, "-cod.txt"))
# }
# ## (xx <- get_args("cases/C1-cod.txt"))
# ## add_nulls(xx, c("lcomp_constant", "file_in", "file_out"))
# scen.df <- data.frame(C.value=c(lc.seq), C=paste0("C", 1:lc.n))
# scen <- expand_scenarios(cases=list(D=0, E=0, F=0, R=0,M=0, C=1:lc.n), species="cod")
# ## Run them in parallel
# run_ss3sim(iterations = 1:10, scenarios = scen, parallel=TRUE,
#            case_folder = case_folder, om_dir = om,
#            em_dir = em, case_files = list(M = "M", F = "F", D =
#     c("index", "lcomp", "agecomp"), R = "R", E = "E", C="C"))
# ## Read in the results and convert to relative error in long format
# get_results_all(user_scenarios=scen)
# file.copy("ss3sim_scalar.csv", "results/lc_test1_scalar.csv", over=TRUE)
# file.copy("ss3sim_ts.csv", "results/lc_test1_ts.csv", over=TRUE)
# results <- read.csv("results/lc_test1_scalar.csv")
# em_names <- names(results)[grep("_em", names(results))]
# results_re <- as.data.frame(
#     sapply(1:length(em_names), function(i)
#            (results[,em_names[i]]- results[,gsub("_em", "_om", em_names[i])])/
#            results[,gsub("_em", "_om", em_names[i])]))
# names(results_re) <- gsub("_em", "_re", em_names)
# results_re$replicate <- results$replicate
# results_re$C <- results$C
# results_re <- results_re[sapply(results_re, function(x) any(is.finite(x)))]
# results_re <- results_re[sapply(results_re, function(x) !all(x==0))]
# results_re <- results_re[,names(results_re)[-grep("NLL",names(results_re))]]
# results_long <- reshape2::melt(results_re, c("C", "replicate"))
# results_long <- merge(scen.df, results_long)
# results_long$C <- factor(results_long$C, levels=paste0("C", 0:lc.n))
# ## Make exploratory plots
# ggplot(results_long, aes(x=C.value, y=value))+ylab("relative error")+
#     geom_line(aes(group=replicate))+facet_wrap("variable", scales="fixed") + ylim(-1,1) +
#     xlab("robustification constant value")
# ggsave("plots/lc_test1.png", width=10, height=7)
# ## Clean up everything
# unlink(scen, TRUE)
# file.remove(c("ss3sim_scalar.csv", "ss3sim_ts.csv"))
# rm(results, results_re, results_long, scen.df, scen, em_names, lc.seq, lc, x, i)
# ## End of lcomp constant test run
# ### ------------------------------------------------------------




# ### ------------------------------------------------------------
# ### Old testing code, leave here for now, eventually migrate to a testing
# ### folder in the package.


# ## ### ------------------------------------------------------------
# ## ### Code for testing the change_tail_compression
# ## ## Test whether cases are parsed correctly
# ## get_caseargs("cases", scenario = "D0-E0-F0-M0-R0-S0-T0-cod",
# ##              case_files = list(E = "E", D = c("index", "lcomp", "agecomp"), F =
# ##              "F", M = "M", R = "R", S = "S", T="T"))
# ## ## Run the example simulation with tail compression option
# ## case_folder <- 'cases'
# ## d <- system.file("extdata", package = "ss3sim")
# ## om <- paste0(d, "/models/cod-om")
# ## em <- paste0(d, "/models/cod-em")
# ## run_ss3sim(iterations = 1, scenarios =
# ##            c("D0-E0-F0-R0-M0-T0-cod", "D0-E0-F0-R0-M0-T1-cod"),
# ##            case_folder = case_folder, om_dir = om,
# ##            em_dir = em, case_files = list(M = "M", F = "F", D =
# ##     c("index", "lcomp", "agecomp"), R = "R", E = "E", T="T"))
# ## ## Make sure it runs with no tail compression option
# ## run_ss3sim(iterations = 1, scenarios =
# ##            c("D0-E0-F0-R0-M0-cod"),
# ##            case_folder = case_folder, om_dir = om,
# ##            em_dir = em)
# ## ## quickly grab results to see if any difference
# ## get_results_all(user_scenarios=
# ##                 c("D0-E0-F0-R0-M0-T0-cod",
# ##                   "D0-E0-F0-R0-M0-T1-cod",
# ##                   "D0-E0-F0-R0-M0-cod" ), over=TRUE)
# ## results <- read.csv("ss3sim_scalar.csv")
# ## results$ID <- gsub("D0-E0-F0-R0-M0-|-1", "", as.character(results$ID))
# ## results.long <- cbind(ID=results$ID, results[,grep("_em", names(results))])
# ## results.long <- reshape2::melt(results.long, "ID")
# ## library(ggplot2)
# ## ggplot(results.long, aes(x=ID, y=value))+
# ##     geom_point()+facet_wrap("variable", scales="free")
# ## results.long
# ## ## End of session so clean up
# ## unlink("D0-E0-F0-R0-M0-T0-cod", TRUE)
# ## unlink("D0-E0-F0-R0-M0-T1-cod", TRUE)
# ## unlink("D0-E0-F0-R0-M0-cod", TRUE)
# ## file.remove("ss3sim_scalar.csv", "ss3sim_ts.csv")
# ## ### ------------------------------------------------------------