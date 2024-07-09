# TODO do an if on aws key if not present expect_error
# if no renviron expect error
# if Renvron but no aws ket expect error

test_that("list_s3 return a data frame", {
  expect_equal(is.data.frame(list_s3()), TRUE)
})
