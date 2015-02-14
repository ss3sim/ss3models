#' Check SS3 models
#'
#' @param Path to the model
#' @param hess Should the hessian matrix be estimated?
#'
#' @export

check_model <- function(model, hess = FALSE) {
  wd <- getwd()
  on.exit(setwd(wd))
  td <- tempdir()
  f <- list.files(model)
  tdf <- list.files(td)
  unlink(tdf, recursive = TRUE, force = TRUE)
  file.copy(file.path(model, f), td, overwrite = TRUE)
  setwd(td)
  if (hess)
    system("ss3_24o_safe")
  else
    system("ss3_24o_safe -nohess")
  setwd(wd)
}
