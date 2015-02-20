#' Generate standardized \code{starter.ss} and \code{forecast.ss} files
#' for SS3 model setups
#'
#' @param modelfolder Path to a folder containing SS3 models. Inside each model
#'   setup folder, there should be a folder named \code{om} and \code{em}. For
#'   example, \code{ss3models/inst/models} or
#'   \code{system.file("models", package = "ss3models")}.
#' @param forecast A logical if \code{forecast.ss} files should be standardized.
#' @param starter A logical if \code{starter.ss} files should be standardized.
#' @param verbose A logical for debugging.
#'
#' @seealso \code{\link{make_forecast}}, \code{\link{make_starter}}
#'
#' @author Kelli Faye Johnson
#' @examples
#' \dontrun{
#' m <- system.file("models", package = "ss3models")
#' create_templates(m, forecast = TRUE, starter = TRUE)
#' }
#' @export

create_templates <- function(modelfolder = ".", forecast = TRUE, starter = TRUE,
  verbose = FALSE) {
  wd.curr <- getwd()
  on.exit(setwd(wd.curr))
  setwd(modelfolder)
  # Determine which models are in the package
  modelnames <- dir()

  # Create a temporary directory to run the models in
  temp_path <- file.path(tempdir(), "starter")
  dir.create(temp_path, showWarnings = verbose)
  on.exit(unlink(temp_path, recursive = TRUE))

 # Do the work of making the files, running the models to get ss_new files
 # and copying those files back into their respective directories

  for (mod in seq_along(modelnames)) {
    om_fold <- file.path(modelnames[mod], "om")
    em_fold <- file.path(modelnames[mod], "em")

    if (forecast) {
      make_forecast(outfile = "forecast.ss", dir = om_fold)
      make_forecast(outfile = "forecast.ss", dir = em_fold)
      lastphase <- grep("phase", readLines(file.path(em_fold, "starter.ss")),
                        value = TRUE)
      lastphase <- as.numeric(strsplit(lastphase, "#")[[1]][1])
    }

    if (starter) {
      make_starter(outfile = "starter.ss", dir = om_fold, type = "om")
      # Copy the files to the temporary directory
      setwd(om_fold)
      file.copy(list.files(), temp_path)
      setwd(temp_path)
      system("ss3_24o_safe -noest", show.output.on.console = verbose)
      setwd(file.path(modelfolder, om_fold))
      file.copy(file.path(temp_path, "starter.ss_new"), "starter.ss",
                overwrite = TRUE)
      file.copy("starter.ss", file.path("..", "em", "starter.ss"),
                overwrite = TRUE)
      setwd(file.path("..", "em"))
      str.file <- readLines("starter.ss")
      str.file[grep("use init values in control", str.file)] <-
        gsub("^1", "0", grep("use init values in control", str.file, value = TRUE))
      str.file[grep("phase", str.file)] <-
        paste(lastphase, strsplit(grep("phase", str.file,
        value = TRUE), "#")[[1]][2], sep = " #")
      str.file[grep("max yr for sdreport", str.file)] <-
        paste("-2", strsplit(grep("max yr for sdreport", str.file,
        value = TRUE), "#")[[1]][2], sep = " #")
      writeLines(str.file, "starter.ss")
      setwd(modelfolder)
    }

  }

}
