test_that("list_s3 return a data frame", {
  expect_equal(is.data.frame(list_s3()), TRUE)
})
