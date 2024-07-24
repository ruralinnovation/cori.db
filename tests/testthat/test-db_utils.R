if (!file.exists("~/.Renviron")) {
  test_that("No .Renviron file", {
    expect_error(schema_size_db())
  })
} else {
  test_that("should return a data.frame", {
    expect_true(is.data.frame(schema_size_db()))
  }
  )
}
