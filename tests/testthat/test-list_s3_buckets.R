
if (!has_aws_credentials()) {
 test_that("No .Renviron file", {
        expect_error(set_aws_credentials())
      } )
} else {
  test_that("Return a data frame", {
  expect_equal(is.data.frame(list_s3_buckets()), TRUE)
  })
}
