#' Make a single README file
#'
#' Run this from within a model setup folder.
#'
#' @param path Folder path to the base of the package folder.
#'
#' @export
#' @importFrom rmarkdown render

make_readme <- function(path = ".") {
  render(paste0(path, "/README.Rmd"))
}

#' Make all README files
#'
#' Run this from the base package folder.
#'
#' @param path Folder path to the base package folder.
#'
#' @export
#' @importFrom rmarkdown render

make_readmes <- function(path = ".") {
  m <- list.files("inst")
  m <- m[-which(m == "cases")]
  for (i in m) {
    render(paste0(path, "/inst/", i, "/README.Rmd"))
  }
}
