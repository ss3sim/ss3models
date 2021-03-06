% Generated by roxygen2 (4.1.0): do not edit by hand
% Please edit documentation in R/check_model.R
\name{check_model}
\alias{check_model}
\title{Check SS3 models}
\usage{
check_model(model, opts = "-nohess", ss_mode = c("safe", "optimized"),
  ss_binary = "ss3_24o")
}
\arguments{
  \item{model}{Path to a model to check}

  \item{opts}{Options to pass to SS3 on the command line}

  \item{ss_mode}{One of \code{"safe"} or \code{"optimized"}
  for which SS3 binary to run. See the ss3sim vignette for
  instructions.}

  \item{ss_binary}{Name of the SS3 binary minus
  \code{_safe} or \code{_opt}.  This binary should be in
  your system's path.}
}
\value{
A data frame of warnings produced from SS3.
}
\description{
Check SS3 models
}
\examples{
\dontrun{
check_model(ss3model("hake", "om"), opts = "-noest")
check_model(ss3model("hake", "em"), opts = "-nohess")
}
}

