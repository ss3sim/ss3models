#' Get parameter values for SS3 model setups
#'
#' @param modelfolder Path to a folder containing SS3 models. Inside each model
#'   setup folder, there should be a folder named \code{om} and \code{em}. For
#'   example, \code{ss3models/inst/models} or
#'   \code{system.file("models", package = "ss3models")}.
#' @param write_csv Should the parameter value data frame be written to CSV file
#'   named \code{outfile}
#' @param outfile A character value specifying a file name for the output if
#'   \code{write_csv = TRUE}. Must end in \code{.csv}.
#' @param ss_binary A character value specifying which version of SS3 to use.
#'
#' @return A CSV file named \code{outfile} if \code{write_csv = TRUE}. The
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
#' @importFrom r4ss SS_parlines SS_output

get_parvalues <- function(modelfolder = ".", write_csv = TRUE,
  outfile = "parlist.csv", ss_binary = "ss3_24o_opt") {
  wd <- getwd()
  on.exit(setwd(wd), add = TRUE)
  setwd(modelfolder)
  models <- list.dirs(full.names = FALSE, recursive = FALSE)
  results <- list()

  # Perform sanity check that all listed models are actually models
  test <- rep(TRUE, length(models))
  for (mod in seq_along(models)) {
    temp <- list.dirs(models[mod])
    temp <- temp[-which(temp == models[mod])]
    test[mod] <- all(file.path(models[mod], c("om", "em")) %in% temp)
  }
  models <- models[test]

  test <- strsplit(outfile, "\\.")[[1]][2]
  if (test != "csv") {
    stop("outfile must end in .csv")
  }

  temp_path <- file.path(tempdir(), "pars")
    dir.create(temp_path, showWarnings = FALSE)
  file.copy(".", temp_path, recursive = TRUE)
  setwd(temp_path)
  on.exit(unlink(temp_path, recursive = TRUE), add = TRUE)

  for (mod in seq_along(models)) {
    setwd(file.path(models[mod], "om"))
    system(paste(ss_binary, "-noest"), show.output.on.console = FALSE)
    # Read in the control.ss_new file because the model was run using
    # the .par file and the om.ctl file may not have the same INIT vals
    ctl.om <- SS_parlines("control.ss_new")[, c("Label", "INIT")]
    setwd("..")
    ctl.em <- SS_parlines(dir("em", pattern = "ctl", full.names = TRUE))
    ctl.em <- ctl.em[, -which(colnames(ctl.em) == "Linenum")]
    both <- merge(ctl.om, ctl.em, by = "Label", all = TRUE, suffixes = c(".om", ".em"),
      sort = TRUE)
    both$model <- models[mod]
    results[[mod]] <- both
    setwd("..")
  }

  final <- do.call("rbind", results)
  setwd(wd)
  if (write_csv) {
    write.table(final, outfile, sep = ",", row.names = FALSE)
  }
  invisible(final)
}
