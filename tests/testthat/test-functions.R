test_that(
  "The find_max_labs() is correct",
  {
    data(dl)
    p <- find_max_labs("Albumin")
    expect_true(p[1, 3] == 25)
  }
)

test_that(
  "The find_base_labs() is correct",
  {
    data(dl)
    p <- find_base_labs("Albumin")
    expect_true(p[1, 2] == 30)
  }
)

test_that(
  "The get_lab_std() is correct",
  {
    data(dl)
    p <- get_lab_std("Albumin")
    expect_true(p[1, 2] == -5)
  }
)

test_that(
  "The get_gender_interval() is correct",
  {
    data(dl)
    p <- get_gender_interval("Male", 0.975)
    expect_true(p[1] > 0)
  }
)

test_that(
  "The get_nras_interval() is correct",
  {
    data(dl)
    p <- get_nras_interval(1, 0.975)
    expect_true(p[1] > -100)
  }
)

test_that(
  "The get_kras_interval() is correct",
  {
    data(dl)
    p <- get_kras_interval(1, 0.975)
    expect_true(p[1] > -100)
  }
)

test_that(
  "The get_albumin_interval() is correct",
  {
    data(dl)
    p <- get_albumin_interval(0.975)
    expect_true(p[1] > -100)
  }
)

test_that(
  "The get_albumin_interval() is correct",
  {
    data(dl)
    p <- get_gender_albumin("Male", 0.975)
    expect_true(p[1] > -100)
  }
)

test_that(
  "The get_nras_albumin() is correct",
  {
    data(dl)
    p <- get_nras_albumin(1, 0.975)
    expect_true(p[1] > -100)
  }
)

test_that(
  "The get_kras_albumin() is correct",
  {
    data(dl)
    p <- get_kras_albumin(1, 0.975)
    expect_true(p[1] > -100)
  }
)
