context("OMs can be run through SS3")

test_that("OMs run", {
  skip_on_cran()

  f <- system.file("models", package = "ss3models")
  fs <- list.files(f)

  lapply(fs, function(x)
    check_model(file.path(f, x, "om")))
})
