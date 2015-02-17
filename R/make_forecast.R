#' Write a \code{forecast.ss} file for use in \pkg{ss3sim}.


#' @param outfile A character value specifying the name to save the forecast
#'   file as. Will not be written to the disk unless \code{write_file = TRUE}.
#'   The default is \code{"forecast.ss"}.
#' @param dir A directory to save \code{outfile} in. The default is \code{NULL},
#'   where the \code{outfile} will be saved in \code{getwd()}.
#' @param msy Specifies whether or not to do a forecast and which \emph{F} to 
#'   use for that forecast. Use \code{0} to have no forecast, \code{1} to set to 
#'   F(SPR), \code{2} to calculate F(MSY), \code{3} to set to F(Btarget),
#'   and \code{4} to set to F(endyr). Default is \code{2}.
#' @param spr_target Stock Synthesis searches for an \emph{F} multiplier that 
#'   will produce this level of spawning stock biomass (or reproductive output)
#'   per recruit relative to an unfished value. Default is \code{0.4}.
#' @param b_target Stock Synthesis searches for an \emph{F} multiplier that 
#'   will produce this level of spawning stock biomass relative to an unfished 
#'   value. This is not per recruit and takes into account the Spawner-Recruit
#'   relationship. Default is \code{0.4}.
#' @param bmark_years A vector of \code{length} 6: 1) beginning year of biology,
#'   2) ending year of biology, 3) beginning year of selectivity, 4) ending year
#'   of selectivity, 5) beginning year of relative F, and ending year of relative
#'   F. All entries are less than or equal to zero, to set years relative to the
#'   terminal year of the model. Default is \code{c(0, 0, 0, 0, 0, 0)}.
#' @param bmark_relf A numeric value of \code{1} or \code{2}, where the former
#'   instructs Stock Synthesis to use the year range from \code{bmark_years} to 
#'   calculate a relative fishing mortality level and the later uses the same
#'   years as specified for the forecast in \code{fcast_years}.
#' @param forecast Specifies whether or not to do a forecast benchmarks and which 
#'   to calculate. Use \code{0} to have no forecast, \code{1} to set to 
#'   F(SPR), \code{2} to calculate F(MSY), \code{3} to set to F(Btarget),
#'   and \code{4} to set to F(endyr). Default is \code{0}. Inputs are the same
#'   as \code{msy}.
#' @param nforecast A numeric value specifying the number of forecast years.
#'   The default number of years is \code{0}.
#' @param forecast_years A vector length, where each value corresponds to years
#'   relative to the end year of the simulation that will be used in the forecasts.
#'   Values correspond to the beginning and end years for selectivity and the
#'   relative \emph{F}s that will be used in population forecasts.
#' @param fleet A numeric value assigning the forecast to a specific fleet in 
#'   the model. Default is fleet \code{1}.
#' @param verbose A logical specifying whether or not to write information to the 
#'   console while writing the forecast files. Useful for debugging.
#'   Default is \code{FALSE}.
#' @param write_file A logical specifying whether or not to write the file to the
#'   disk or not. File will always be returned as a \code{invisible} independent of
#'   \code{write_file}. Default is to write to the disk.

#' @importfrom r4ss SS_writeforecast
#' @author Kelli Johnson

make_forecast <- function(outfile = "forecast.ss", dir = NULL, msy = 2, 
  spr_target = 0.4, b_target = 0.4, bmark_years = rep(0, 6), bmark_relf = 1, 
  forecast = 0, nforecast = 0, forecast_years = rep(0, 4), fleet = 1, 
  verbose = FALSE, write_file = TRUE) {
  # perform some checks
  if (length(bmark_years) != 6) {
      stop(paste("bmark_years should be a vector of length six, not", 
        length(bmark_years), "as entered."))
  }
  if (length(forecast_years) != 4) {
      stop(paste("forecast_years should be a vector of length six, not", 
        length(forecast_years), "as entered."))
  }
  if (length(fleet) > 1) {
      stop(paste("write_forecast only works with a single fleet, please change",
        "fleets to a single numeric value."))
  }
  if (msy > 4 | msy < 0) {
      stop(paste("msy should be a value between zero and four corresponding to",
        "acceptable input values in Stock Synthesis."))
  }
  if (forecast > 4 | forecast < 0) {
      stop(paste("msy should be a value between zero and four corresponding to",
        "acceptable input values in Stock Synthesis."))
  }
  if (nforecast < 0) {
      stop(paste("nforecast must be a positive number declaring the number of",
        "forecasts to perform."))
  }
  if (nforecast == 0 & forecast != 0) {
      stop(paste("If forecast is 0 the number of forecast years should also be",
        "zero, please change either forecast or nforecast."))
  }


  data <- list()
  data$sourcefile <- "forecast.ss"
  data$type <- "Stock_Synthesis_forecast_file"
  data$SSversion <- "SSv3.21_or_later"
  data$benchmarks <- 1
  data$MSY <- msy
  data$SPRtarget <- spr_target
  data$Btarget <- b_target
  data$Bmark_years <- bmark_years
  data$Bmark_relF_Basis <- bmark_relf
  data$Forecast <- forecast
  data$Nforecastyrs <- nforecast
  data$F_scalar <- 0
  data$Fcast_years <- forecast_years
  data$ControlRuleMethod <- 2
  data$BforconstantF <- 1
  data$BfornoF <- 0
  data$Flimitfraction <- 0
  data$N_forecast_loops <- 3
  data$First_forecast_loop_with_stochastic_recruitment <- 100
  data$Forecast_loop_control_3 <- 0
  data$Forecast_loop_control_4 <- 0
  data$Forecast_loop_control_5 <- 0
  data$FirstYear_for_caps_and_allocations <- 0
  data$stddev_of_log_catch_ratio <- 0
  data$Do_West_Coast_gfish_rebuilder_output <- 0
  data$Ydecl <- 0
  data$Yinit <- 0
  data$fleet_relative_F <- 1
  data$basis_for_fcast_catch_tuning <- 2
  data$max_totalcatch_by_fleet <- -1
  data$max_totalcatch_by_area <- -1
  data$fleet_assignment_to_allocation_group <- fleet
  data$N_allocation_groups <- 1
  data$allocation_among_groups <- 1
  data$Ncatch <- 0
  data$InputBasis <- 2

  SS_writeforecast(data, dir = dir, file = outfile, overwrite = TRUE,
    verbose = verbose)

  return(invisible(data))
}
