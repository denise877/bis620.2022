
test_that(
  "The spec_sig is correct for take_log = TRUE",
  {
    data(ukb_accel)
    p <- spec_sig(ukb_accel[1:100, ], take_log = TRUE)
    expect_true(inherits(p, "tbl"))
  }
)
