test_that(
  "The accel_plot() returns a ggplot object.",
  {
    data(ukb_accel)
    p <- accel_plot(ukb_accel[1:100, ])
    expect_true(inherits(p, "gg"))
  }
)

test_that(
  "The accel_plot() errors when no time column.",
  {
    data(iris)
    expect_error(accel_plot(iris))
  }
)

test_that(
  "The accel_plot() is correct for time-series data.",
  {
    data(ukb_accel)
    p <- accel_plot(ukb_accel[1:100, ])
    vdiffr::expect_doppelganger("first-100-samples", p)
  }
)

test_that(
  "The accel_plot() errors when no time column.",
  {
    data(iris)
    colnames(iris) <- c("Sepal.Length", "Sepal.Width",
                        "Petal.Length", "Petal.Width", "freq")
    p <- accel_plot(iris)
    expect_true(inherits(p, "gg"))
  }
)
