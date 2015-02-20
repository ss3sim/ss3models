#' Write a \code{starter.ss} file for use in \pkg{ss3sim}.
#'
#' @param outfile A character value specifying the name to save the forecast
#'   file as. Will not be written to the disk unless \code{write_file = TRUE}.
#'   The default is \code{"forecast.ss"}.
#' @param dir A directory to save \code{outfile} in. The default is \code{NULL},
#'   where the \code{outfile} will be saved in \code{getwd()}.
#' @param type A character value of either \code{"om"} or \code{"em"}, specifying
#'   if the \code{starter.ss} file pertains to an operating or estimating model
#'   set up.
#' @param last_estimation_phase A numeric value specifying the last estimation
#'   phase in an estimation model. Not used if \code{type = "om"}.
#' @param verbose A logical specifying whether or not to write information to the
#'   console while writing the forecast files. Useful for debugging.
#'   Default is \code{FALSE}.
#' @param write_file A logical specifying whether or not to write the file to the
#'   disk or not. File will always be returned as a \code{invisible} independent of
#'   \code{write_file}. Default is to write to the disk.
#'
#' @export
#' @importFrom r4ss SS_writestarter
#' @author Kelli Johnson

make_starter <- function(outfile = "starter.ss", dir = NULL, type = c("om", "em"),
  last_estimation_phase = 15, verbose = FALSE, write_file = TRUE) {

  type <- match.arg(type)
  data <- list()
  data$sourcefile             <- "starter.ss"
  data$type                   <- "Stock_Synthesis_starter_file"
  data$SSversion              <- "SSv3.10b_or_later"
  data$datfile                <- "ss3.dat"
  data$ctlfile                <- "ss3.ctl"
  data$init_values_src        <- ifelse(type == "om", 1, 0)
  data$run_display_detail     <- 0
  data$detailed_age_structure <- 1
  data$checkup                <- 0
  data$parmtrace              <- 0
  data$cumreport              <- 0
  data$prior_like             <- 0
  data$soft_bounds            <- 1
  data$N_bootstraps           <- 2
  data$last_estimation_phase  <- ifelse(type == "om", 0, last_estimation_phase)
  data$MCMCburn               <- 0
  data$MCMCthin               <- 1
  data$jitter_fraction        <- 0
  data$minyr_sdreport         <- -1
  data$maxyr_sdreport         <- ifelse(type == "om", -1, -2)
  data$N_STD_yrs              <- 0
  data$converge_criterion     <- 1e-04
  data$retro_yr               <- 0
  data$min_age_summary_bio    <- 1
  data$depl_basis             <- 1
  data$depl_denom_frac        <- 1
  data$SPR_basis              <- 4
  data$F_report_units         <- 1
  data$F_age_range            <- c(NA, NA)
  data$F_report_basis         <- 0

  SS_writestarter(data, dir = dir, file = outfile, overwrite = TRUE,
    verbose = verbose)

  return(invisible(data))
}
