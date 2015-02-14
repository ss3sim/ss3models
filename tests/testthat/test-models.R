context("OMs can be run through SS3")

test_that("OMs run", {
  skip_on_cran()

  f <- system.file("models", package = "ss3models")
  models <- list.files(f)

  lapply(models, function(x)
    check_model(file.path(f, x, "om"), opts = "-noest"))
})

test_that("EMs run", {
  skip_on_cran()

  f <- system.file("models", package = "ss3models")
  models <- list.files(f)

  lapply(models, function(x)
    check_model(file.path(f, x, "em"), ss_mode = "opt"))
})
