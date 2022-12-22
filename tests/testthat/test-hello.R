test_that(
  "The hello is functioning well with default input",
  {
    a <- hello()
    expect_identical("Hello!", a)
  }
)

test_that(
  "The hello is functioning well with invisible option",
  {
    a <- hello(invisible = TRUE)
    expect_identical("Hello!", a)
  }
)

test_that(
  "The hello is functioning well with customized input",
  {
    a <- hello(name = "BIS 620")
    expect_identical("Hello BIS 620!", a)
  }
)

test_that(
  "The hello is functioning well with customized input and invisible option",
  {
    a <- hello(name = "BIS 620", invisible = TRUE)
    expect_identical("Hello BIS 620!", a)
  }
)
