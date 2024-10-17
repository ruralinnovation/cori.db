#' put an a local file into an s3 bucket
#'
#' @param bucket_name string, a bucket name
#' @param key string, how will be named the key in s3 bucket
#' @param file_path string, file (path) that you want to upload
#' @param ... other arguments from paws's put_object()
#'
#' @return return invisibly the response from AWS
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#'  txt <- put_s3_object("test-coridata", "blabla.txt" ,"blabla.txt")
#' see what it returns
#' }
#'

put_s3_object <- function(bucket_name, key, file_path, ...) {

  if (! has_aws_credentials()) {
    stop("AWS credentials are missing, run set_aws_credentials()")
  }

  if (! can_i_write_in_that_bucket(bucket_name)) {
    stop(sprintf("%s is not on the list of curated bucket", bucket_name))
  }

  if (is_key_already_here(bucket_name, key)) {
    stop(sprintf("%s already exist in %s", key, bucket_name), call. = FALSE)
  }

  s3 <- paws.storage::s3()

  response <- s3$put_object(Body = file_path,
                            Bucket = bucket_name,
                            Key = key,
                            ...)

  return(invisible(response))
}
