context("Model checking")

test_that("OMs run", {
  skip_on_cran()

  f <- system.file("models", package = "ss3models")
  models <- list.files(f)

  output <- lapply(models, function(x)
    check_model(file.path(f, x, "om"), opts = "-noest"))
})

# test_that("EMs run", {
#   skip_on_cran()
#
#   f <- system.file("models", package = "ss3models")
#   models <- list.files(f)
#
#   output <- lapply(models, function(x)
#     check_model(file.path(f, x, "em"), ss_mode = "opt"))
# })

test_that("OM .dat files pass ss3sim checks", {
  skip_on_cran()

  f <- system.file("models", package = "ss3models")
  models <- list.files(f)

  output <- lapply(models, function(x) {
    message(paste("Checking", x))
    d <- r4ss::SS_readdat(file.path(f, x, "om", "ss3.dat"), verbose = FALSE)
    ss3sim::check_data(d)
  })
})
