# test if aws credential are set

has_aws_credentials <- function() {

  home <- Sys.getenv("HOME")

  #### TODO: This is wrong...
  # renviron <- file.path(home, ".Renviron")
  ####  we should store credentials in the way that AWS recomends (using the aws cli) :
  ####  https://docs.aws.amazon.com/cli/latest/userguide/cli-authentication-user.html#cli-authentication-user-configure-wizard
  ####  ... minus the bit about the uber-complex configuration of SSO in AWS IAM Identity Center (later)

  #### ... instead check for the standard aws "credentials" file
  credentials <- file.path(paste0(home, "/.aws"), "credentials")

  # if (!file.exists(renviron)) {
  if (!file.exists(credentials)) {
    return(FALSE)
    # } else {
    #   if (nchar(Sys.getenv("AWS_ACCESS_KEY_ID")) == 0) return(FALSE)
    #   if (nchar(Sys.getenv("AWS_SECRET_ACCESS_KEY")) == 0) return(FALSE)
    #   if (nchar(Sys.getenv("AWS_DEFAULT_REGION")) == 0) return(FALSE)
  }

  return(TRUE)
}


# what is the type of content of an object

get_s3_content_type <- function(bucket_name, key) {

  s3 <- paws.storage::s3()

  head <- s3$head_object(
    Bucket = bucket_name,
    Key = key)

  return(head$ContentType)
}

can_i_write_in_that_bucket <- function(bucket_name) {
  # # v1 implementation should go against a list
  # # v2 could use a specific tag
  # # TODO: do it better, but for now....
  # curated_bucket <- c("cori-risi-apps", "fcc-raw-cori", "test-coridata")
  # bucket_name %in% curated_bucket
  return(TRUE)
}

is_key_already_here <- function(bucket_name, key) {
  df_key <- list_s3_objects(bucket_name = bucket_name)
  key_is_present <- key %in% df_key[["key"]]

  if (key_is_present) {
    message(paste0("Warning: ", bucket_name, " contains a previous version of ", key))
    return(key_is_present)
  } else {
    return (FALSE)
  }
}

get_s3_tags <- function(bucket_name) {
  s3 <- paws.storage::s3()

  s3$get_bucket_tagging(
    Bucket = bucket_name
  )
}