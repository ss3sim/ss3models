#' Check SS3 models
#'
#' @param model Path to a model to check
#' @param opts Options to pass to SS3 on the command line
#' @param ss_mode One of \code{"safe"} or \code{"optimized"} for which SS3
#'   binary to run. See the ss3sim vignette for instructions.
#' @param ss_binary Name of the SS3 binary minus \code{_safe} or \code{_opt}.
#'   This binary should be in your system's path.
#'
#' @export
#' @return A data frame of warnings produced from SS3.
#' @examples
#' \dontrun{
#' check_model(ss3model("hake", "om"), opts = "-noest")
#' check_model(ss3model("hake", "em"), opts = "-nohess")
#' }

check_model <- function(model, opts = "-nohess",
  ss_mode = c("safe", "optimized"), ss_binary = "ss3_24o") {

  ss_mode <- match.arg(ss_mode)
  if(!ss_mode %in% c("safe", "optimized")) {
    warning(paste("ss_mode must be one of safe or optimized.",
      "Defaulting to safe mode"))
    ss_mode <- "safe"
  }
  if(ss_mode == "optimized") ss_mode <- "opt"
  ss_bin <- paste0(ss_binary, "_", ss_mode)

  wd <- getwd()
  on.exit(setwd(wd))
  td <- tempdir()
  f <- list.files(model)
  tdf <- list.files(td)
  unlink(tdf, recursive = TRUE, force = TRUE)
  file.copy(file.path(model, f), td, overwrite = TRUE)
  setwd(td)
  system(paste(ss_bin, opts))
  warns <- readLines("warning.sso")[-c(1:2)]
  warns <- warns[warns != ""]
  warns <- data.frame("model" = model, "warnings" = warns,
    stringsAsFactors = FALSE)
  setwd(wd)
  warns
}
