#' Get the system file path to a SS3 model
#'
#' @param species Which model setup to choose. See the available model setups
#'   with \code{\link{list_models}}.
#' @param type One of \code{"om"} or \code{"em"} for operating model or
#'   estimating model.
#'
#' @export
#' @author Sean Anderson
#' @seealso \code{\link{list_models}}
#' @examples
#' ss3model("hake", "em")
#' ss3model("flatfish", "om")

ss3model <- function(species, type = c("om", "em")) {
  type <- match.arg(type)
  if (!any(species %in% list_models()))
    stop(paste(species, "isn't an available model setup. See the available",
      "model setups with list_models()."))
  system.file(file.path("models", species, type), package = "ss3models")
}

#' List all available model setups in the ss3models package
#'
#' @export
#' @author Sean Anderson
#' @seealso \code{\link{ss3model}}
#' @examples
#' list_models()

list_models <- function() {
  dir(system.file("models", package = "ss3models"))
}
