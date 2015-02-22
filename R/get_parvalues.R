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
  on.exit(setwd(wd))
  setwd(modelfolder)
  models <- dir()
  results <- list()

  test <- strsplit(outfile, "\\.")[[1]][2]
  if (test != "csv") {
    stop("outfile must end in .csv")
  }

  temp_path <- file.path(tempdir(), "pars")
    dir.create(temp_path, showWarnings = FALSE)
  file.copy(".", temp_path, recursive = TRUE)
  setwd(temp_path)
  on.exit(unlink(temp_path, recursive = TRUE))

  for (mod in seq_along(models)) {
    setwd(file.path(models[mod], "om"))
    system(paste(ss_binary, "-noest"), show.output.on.console = FALSE)
    ctl.om <- suppressWarnings(SS_output(getwd(), covar = FALSE,
      verbose = FALSE, ncols = 300, printstats = FALSE))
    ctl.om <- ctl.om$parameters[, c("Label", "Value", "Init")]
    ctl.om <- ctl.om[-grep("^F_fleet_", ctl.om$Label), ]
    ctl.om <- ctl.om[-grep("RecrDev_", ctl.om$Label), ]
    setwd("..")
    ctl.in <- dir("em", pattern = "ctl", full.names = TRUE)
    ctl.em <- SS_parlines(ctl.in)[,
      c("LO", "HI", "INIT", "PRIOR", "PR_type", "SD", "PHASE", "Label")]
    ctl.om$Label <- tolower(ctl.om$Label)
    ctl.em$Label <- tolower(ctl.em$Label)
    both <- merge(ctl.om, ctl.em, by = "Label", all = TRUE, suffixes = c(".om", ".em"),
      sort = TRUE)
    both <- setNames(both[, c(1, 4, 3, 2, 6, 5, 7:10)],
      c("Label", "LO", "clt.om", "INIT.om", "INIT.em", "HI",
        "PRIOR", "PR_type", "SD", "PHASE.em"))
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
