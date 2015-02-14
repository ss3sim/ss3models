#' Check SS3 models
#'
#' @param Path to the model
#' @param hess Should the hessian matrix be estimated?
#'
#' @export

check_model <- function(model, opts = "-nohess",
  ss_mode = c("safe", "optimized")) {

  if(!ss_mode %in% c("safe", "optimized")) {
    warning(paste("ss_mode must be one of safe or optimized.",
      "Defaulting to safe mode"))
    ss_mode <- "safe"
  }
  if(ss_mode == "optimized") ss_mode <- "opt"
  ss_bin <- paste0("ss3_24o_", ss_mode)

  wd <- getwd()
  on.exit(setwd(wd))
  td <- tempdir()
  f <- list.files(model)
  tdf <- list.files(td)
  unlink(tdf, recursive = TRUE, force = TRUE)
  file.copy(file.path(model, f), td, overwrite = TRUE)
  setwd(td)
  system(paste(ss_bin, opts))
  setwd(wd)
}
