test_that(
  "The spectral_signature() errors when no time or freq column.",
  {
    data(iris)
    expect_error(spectral_signature(iris))
  }
)

test_that(
  "The spectral_signature() returns a table object.",
  {
    data(ukb_accel)
    p <- spectral_signature(ukb_accel)
    expect_true(inherits(p, "tbl"))
  }
)

test_that(
  "The spectral_signature() returns expected variables.",
  {
    data(ukb_accel)
    p <- spectral_signature(ukb_accel)
    expect_named(p, c("X", "Y", "Z", "freq"))

  }
)

test_that(
  "The spectral_signature() returns expected variables after taking log.",
  {
    data(ukb_accel)
    p <- spectral_signature(ukb_accel, take_log = TRUE)
    expect_named(p, c("X", "Y", "Z", "freq"))

  }
)
