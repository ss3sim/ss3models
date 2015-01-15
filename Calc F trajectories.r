library(devtools)
install('F:/ss3sim')
library(ss3sim)

setwd("F:/growth_models/cod-om - Copy")
setwd("F:/growth_models/fla-om - Copy")
setwd("F:/growth_models/fll-om - Copy")

profile_fmsy(om_in=getwd(), results_out=getwd(), simlength = 100, start = 0.15, end = 0.7, by_val = 0.001)


F <- read.table("Fmsy.txt")

# calculate Fmsy and MSY
	which_msy <- which(abs(F[,2]-max(F[,2]))==min(abs(F[,2]-max(F[,2]))))[1]
	MSY <- F[which_msy,2]
	Fmsy <- F[which_msy,1]

# Determine the lower and upper F values for the F trajectories
	perc_MSY <- 0.9
	which_msyperc_l <- (1:which_msy)[which(abs(F[1:which_msy,2]-perc_MSY*max(F[1:which_msy,2]))==min(abs(F[1:which_msy,2]-perc_MSY*max(F[1:which_msy,2]))))]
	which_msyperc_u <- (which_msy:nrow(F))[which(abs(F[which_msy:nrow(F),2]-perc_MSY*max(F[which_msy:nrow(F),2]))==min(abs(F[which_msy:nrow(F),2]-perc_MSY*max(F[which_msy:nrow(F),2]))))]
	F_l <- F[which_msyperc_l,1]
	F_u <- F[which_msyperc_u,1]

# F1 trajectory
	c(rep(0,25), round(seq(0, F_u, length.out=40), 3), round(seq(F_u, F_l, length.out=35), 3))
# F2 trajectory
	c(rep(0,25), round(seq(0, F_u, length.out=75), 3))
