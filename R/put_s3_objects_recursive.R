#' put files from a local directory into an S3 bucket
#'
#' @param bucket_name string, a bucket name
#' @param s3_key_prefix string, name of the prefix (directory path) used within the S3 bucket
#' @param  dir_path string, local directory path containing the files that you want to upload
#' @param ... other arguments to paws's put_object()
#'
#' @return return invisibly the response from AWS
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#'  txt <- put_s3_objects_recursive("test-coridata", "test/blabla.txt" ,"test")
#' }
#'

put_s3_objects_recursive <- function(bucket_name, s3_key_prefix, dir_path, ...) {

  if (! has_aws_credentials()) {
    stop("AWS credentials are missing, run set_aws_credentials()")
  }

  if (! can_i_write_in_that_bucket(bucket_name)) {
    stop(sprintf("%s is not on the list of curated bucket", bucket_name))
  }

  prefix_is_present <- is_prefix_already_present(bucket_name, s3_key_prefix)

  if ((!prefix_is_present)
    # If the key/prefix includes "dev/" or "test/" skip overwrite check
    || grepl("^dev", s3_key_prefix) || grepl("^test", s3_key_prefix)
  ) {

    message(paste0("aws s3 cp --recursive ", dir_path, " s3://", bucket_name, "/", s3_key_prefix))

    base::system2("aws", args = c("s3", "cp", "--recursive", dir_path, paste0("s3://", bucket_name, "/", s3_key_prefix)))

  } else if (prefix_is_present) {
    stop(sprintf("%s already exist in %s", s3_key_prefix, bucket_name), call. = FALSE)
  }

  return(NULL)
}
