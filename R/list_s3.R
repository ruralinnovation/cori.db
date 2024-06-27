#' Listing s3 bucket CORI draft
#'
#' @return a data frame with two colums bucket_name and creation_date 
#'
#' @export

list_s3 <- function() {

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

  if(! has_aws_credentials()) stop("AWS credentials are missing, run set_aws_credentials()")

  s3 <- paws::s3()
  list_s3  <- s3$list_buckets()
  bucket <- list_s3[["Buckets"]]
  s3_dat <- data.frame(bucket_name = sapply(bucket,
                                            function(x) x[["Name"]]),
                       creation_date = as.POSIXlt(
                            sapply(bucket,
                                    function(x) x[["CreationDate"]]
                                   )))
  return(s3_dat)
}
