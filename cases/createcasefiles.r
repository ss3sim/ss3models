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

###############################################################################
## Step 
## Set working directories 
###############################################################################

wd.curr <- getwd()
setwd(dir.cases)
spp.case <- "col"
start.survey <- 76
start.fishery <- 26
start <- 1
end <- 100

###############################################################################
## Step 
## Standard case files
## These case files do not change per scenario
###############################################################################
for(spp in seq_along(spp.case)) {
r0 <- "retro_yr; 0"
writeLines(r0, paste0("R0-", spp.case[spp], ".txt"))

index0 <- c("fleets; 2", 
            paste0("years; list(c(", paste(
            #Years of survey index of abundance
              seq(start.survey, end, by = 2), 
            collapse = ","),
                   "))"),
            "sds_obs; list(0.2)")
writeLines(index0, paste0("index0-", spp.case, ".txt"))

###############################################################################
## Step 
## Case files that change
###############################################################################
#change_f: case "F"
## Constant F for 75 years
f.info <- c(paste0("years; c(", paste(
        #All years in the simulation
          start:end, 
        collapse = ","), ")"),
        paste0("years_alter; c(", paste(
        #Years to alter F
          start:end, 
        collapse = ","), ")"))
f0 <- c(f.info, paste0("fvals; c(", paste(
        #F vals for each year
          c(rep(0, start.fishery - start), rep(0.07, end - start.fishery + 1)
        ), collapse = ","), ")"))
writeLines(f0, paste0("F0-", spp.case, ".txt"))

## Burn in of 0 for 25 years, up to 0.9*Fmsy (right limb) for 40 years,
## down to 0.9*Fmsy (left limb value) for 35years
f1 <- c(f.info, paste0("fvals; c(", paste(
        #F vals for each year
          c(rep(0, start.fishery - start - 1), seq(0, 0.175, length.out = 41),
            seq(0.175, 0.07, length.out = 35)), 
        collapse = ","),")"))
writeLines(f1, paste0("F1-", spp.case, ".txt"))

## Burn in of 0 for 25 years, up to 0.9*Fmsy (left limb) for 75 years,
f2 <- c(f.info, paste0("fvals; c(", paste(
        #F vals for each year
          c(rep(0, start.fishery - start - 1), seq(0, 0.175, length.out = 76)),
        collapse = ","),")"))
writeLines(f2, paste0("F2-", spp.case, ".txt"))

#change_e: case "E"
allgrowth <- c("L_at_Amin", "L_at_Amax", "VonBert_K", "CV_young", "CV_old")
growthint <- rep(NA, length(allgrowth))
growthphase <- rep(-1, length(allgrowth))

writeE <- function(growthname, growthint, growthphase, case) {
    sink(paste0("E", case, "-", spp.case[spp], ".txt"))
      cat("natM_type; 1Parm \nnatM_n_breakpoints; NULL \n",
           "natM_lorenzen; NULL \nnatM_val; c(NA, NA) \n", sep = "")
      if(is.null(growthname)) {cat("par_name; NULL \n")} else{
      	cat("par_name; c(\"", paste0(growthname, collapse = "\", \""), "\") \n", sep = "")
      }
      cat(paste("par_int;", growthint), "\n")
      cat(paste("par_phase;", growthphase), "\n")
      cat("forecast_num; 0 \nrun_change_e_full; TRUE \n")
	sink()
}

writeE(allgrowth, "rep(NA, 5)", "rep(-1, 5)", 0)
writeE(NULL, "NA", "NA", 1)
writeE(allgrowth, "rep(\"change_e_vbgf\", 5)", "rep(-1, 5)", 2)
writeE(allgrowth, "c(NA, NA, NA, rep(\"change_e_vbgf\", 2))", "c(2, 2, 2, rep(-1, 2))", 3)
writeE(allgrowth, "c(rep(\"change_e_vbgf\", 3), NA, NA)", "c(rep(-1, 3), 2, 2)", 4)

#change_lcomp: case "L"
#change_agecomp: case "A"

bothfleets <- "c(1, 2)"
justfish <- "c(1)"

# allsamples <- "list(c(20, 20, seq(40, 80, 10), rep(100, 30)), rep(100, 13))"
# fishsamples <- "list(c(20, 20, seq(40, 80, 10), rep(100, 30)))"

# allsamples.4 <- "list(c(5, 5, seq(10, 20, 2), rep(25, 30)), rep(25, 13))"
# fishsamples.4 <- "list(c(5, 5, seq(10, 20, 2), rep(25, 30)))"

allsamples <- "list(rep(40, 37), rep(40, 13))"
fishsamples <- "list(rep(40, 37))"

allsamples.4 <- "list(rep(10, 37), rep(10, 13))"
fishsamples.4 <- "list(rep(10, 37))"


allyears <- paste0("list(c(", paste(c(
                   #Fishery
                     seq(start.fishery, start.fishery + 10, by = 10), 
                     seq(start.fishery + 20, start.fishery + 45, by = 5),
                     seq(start.fishery + 46, end)), 
                   collapse = ","), "), c(", paste( c(
                   #Survey
                     seq(start.survey, end, by = 2)),
                   collapse = ","), "))")
fishyears <- paste0("list(c(", paste(c(
                   #Fishery
                     seq(start.fishery, start.fishery + 10, by = 10), 
                     seq(start.fishery + 20, start.fishery + 45, by = 5),
                     seq(start.fishery + 46, end)),
                   collapse = ","), "))")

writeL <- function(fleets, Nsamp, years, case) {
	l <- c(paste("fleets;", fleets),
	       paste("Nsamp;", Nsamp),
	       paste("years;", years),
	       "cpar; 1",
	       "lengthbin_vector; NULL",
	       "write_file; TRUE")
	writeLines(l, paste0("lcomp", case, "-", spp.case[spp], ".txt"))
}
writeA <- function(fleets, Nsamp, years, case) {
	a <- c(paste("fleets;", fleets),
	       paste("Nsamp;", Nsamp),
	       paste("years;", years),
	       "cpar; 1",
	       "agebin_vector; NULL",
	       "write_file; TRUE")
	writeLines(a, paste0("agecomp", case, "-", spp.case[spp], ".txt"))
}

writeL(fleets = bothfleets, Nsamp = allsamples, years = allyears, case = 0)
writeL(fleets = justfish, Nsamp = fishsamples, years = fishyears, case = 1)
writeA(fleets = bothfleets, Nsamp = allsamples, years = allyears, case = 0)
writeA(fleets = "NULL", Nsamp = "NULL", years = "NULL", case = 1)
writeA(fleets = justfish, Nsamp = fishsamples, years = fishyears, case = 2)

writeL(fleets = bothfleets, Nsamp = allsamples.4, years = allyears, case = 2)
writeL(fleets = justfish, Nsamp = fishsamples.4, years = fishyears, case = 3)
writeA(fleets = bothfleets, Nsamp = allsamples.4, years = allyears, case = 3)
writeA(fleets = justfish, Nsamp = fishsamples.4, years = fishyears, case = 4)
}


writeX <- function(fleets, years, Nsamp, case) {
  a <- c(paste("fleets;", fleets),
         paste("years;", years),
         paste("Nsamp;", Nsamp),
         "write_file; TRUE")
  writeLines(a, paste0("mlacomp", case, "-", spp.case[spp], ".txt"))
}

writeX(fleets = "NULL", years = "NULL", Nsamp = "NULL", case = 0)
writeX(fleets = justfish, years = "list(c(26))", Nsamp = "list(50)", case = 1)
writeX(fleets = "c(2)", years = paste0("list(",start.survey,")"), Nsamp = "list(50)", case = 2)

writeC <- function(fleets, years, case) {
  a <- c(paste("fleets;", fleets),
         paste("years;", years),
         "write_file; TRUE")
  writeLines(a, paste0("calcomp", case, "-", spp.case[spp], ".txt"))
}

writeC(fleets = bothfleets, years = "list(c(26:27), c(95:100))", case = 1)

writeS <- function(vals, case) {
  parnames <- paste0("SizeSel_1P_", 1:6, "_Fishery")
  beg <- paste("function_type; change_tv")
  sec <- "param;"
  mid <- "dev; rep("
  end <- ", 100)"
  let <- toupper(letters[10:15])
  
  lapply(seq_along(parnames), function(x) {
    info <- c(beg, paste(sec, parnames[x]), paste0(mid, vals[x], end))
    writeLines(info, paste0(let[x], case, "-", spp.case[spp], ".txt"))
  })
}

writeS(vals = rep(0, 6), case = 0)
writeS(vals = c(51.5 - 50.8, -4 - -3 , 5.2 - 5.1, 8 - 15, 0, 0), case = 1)

setwd(wd.curr)