#' Check SS3 models
#'
#' @export

check_models <- function(model) {
  wd <- getwd()
  on.exit(setwd(wd))
  td <- tempdir()
  file.copy(model, td)
  setwd(td)
  system("ss3_24o_safe")
  setwd(wd)
}
