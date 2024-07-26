# test if aws credential are set

has_aws_credentials <- function() {

  home <- Sys.getenv("HOME")
  renviron <- file.path(home, ".Renviron")

  if (!file.exists(renviron)) {
    return(FALSE)
    } else {

      if (nchar(Sys.getenv("AWS_ACCESS_KEY_ID")) == 0) return(FALSE)
      if (nchar(Sys.getenv("AWS_SECRET_ACCESS_KEY")) == 0) return(FALSE)
      if (nchar(Sys.getenv("AWS_DEFAULT_REGION")) == 0) return(FALSE)
  }
  return(TRUE)
}


# what is the type of content of an object

get_s3_content_type <- function(bucket_name, key) {

  s3 <- paws::s3()

  head <- s3$head_object(
    Bucket = bucket_name,
    Key = key)

  return(head$ContentType)
}

can_i_write_in_that_bucket <- function(bucket_name) {
  # v1 implementation should go against a list
  # v2 could use a specific tag 
  curated_bucket <- c("test-coridata", "fcc-raw-cori")
  bucket_name %in% curated_bucket
}

is_key_already_here <- function(bucket_name, key) {
  df_key <- list_s3_objects(bucket_name = bucket_name)
  key %in% df_key[["key"]]
}

# caution an object without tag will return an error
# need an hnadler

# vendored from https://adv-r.hadley.nz/conditions.html#failure-value
b <- "test-coridata"

fail_with <- function(expr, value = NULL) {
  tryCatch(
    error = function(cnd) value,
    expr
  )
}

get_s3_tags <- function(bucket_name) {
  s3 <- paws::s3()

  s3$get_bucket_tagging(
    Bucket = bucket_name
  )
}