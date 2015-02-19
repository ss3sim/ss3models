#' Get parameter values for SS3 model setups
#'
#' @param modelfolder Path to a folder containing SS3 models. Inside each model
#'   setup folder, there should be a folder named \code{om} and \code{em}. For
#'   example, \code{ss3models/inst/models} or
#'   \code{system.file("models", package = "ss3models")}.
#' @param write_csv Should the parameter value data frame be written to CSV file
#'   named \code{parlist.csv}?
#'
#' @return A CSV file named \code{parlist} if \code{write_csv = TRUE}. The
#'   parameter data frame is returned invisibly regardless.
#'
#' @author Kelli Faye Johnson
#' @examples
#' \dontrun{
#' m <- system.file("models", package = "ss3models")
#' p <- get_parvalues(m, write_csv = FALSE)
#' head(p)
#' }
#' @export
#' @importFrom r4ss SS_parlines

get_parvalues <- function(modelfolder = ".", write_csv = TRUE) {
  wd <- getwd()
  on.exit(setwd(wd))
  setwd(modelfolder)
  models <- dir()
  results <- list()

  for (mod in seq_along(models)) {
    ctl.in <- dir(file.path(models[mod], "om"), pattern = "ctl", full.names = TRUE)
    ctl.om <- SS_parlines(ctl.in)[, c("INIT", "Label")]
    ctl.in <- dir(file.path(models[mod], "em"), pattern = "ctl", full.names = TRUE)
    ctl.em <- SS_parlines(ctl.in)[,
      c("LO", "HI", "INIT", "PRIOR", "PR_type", "SD", "PHASE", "Label")]
    ctl.om$Label <- tolower(ctl.om$Label)
    ctl.em$Label <- tolower(ctl.em$Label)
    both <- merge(ctl.om, ctl.em, by = "Label", all = TRUE, suffixes = c(".om", ".em"),
      sort = TRUE)
    both <- both[, c(1, 3, 2, 5, 4, 9, 6:8)]
    both$model <- models[mod]
    results[[mod]] <- both
  }

  final <- do.call("rbind", results)
  setwd(wd)
  if (write_csv) {
    write.table(final, "parlist.csv", sep = ",", row.names = FALSE)
  }
  invisible(final)
}
