#' get object hosted in s3 downloaded
#'
#'@details If file_path is not provided it will the object in the curent directory
#'
#' @param bucket_name string, a bucket name
#' @param key string, object/file that you want to download
#' @param file_path string, a path where you want the file to be downloaded ("~/Documents/my_proj/"")
#' @param ... other arguments from paws's downloadfile
#'
#' @return return invisibly the path where the file has been downloaded
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#'  txt <- get_s3_object("test-coridata", "blabla.txt")
#'  txt
#' }
#'

get_s3_object <- function(bucket_name, key, file_path, ...) {

  if(! has_aws_credentials()) stop("AWS credentials are missing, run set_aws_credentials()")

  if (missing(file_path)) {
    where_to_write <- paste0(getwd(), "/", key)
  } else {
    dir_path <- dirname(file_path)
    if (!dir.exists(dir_path)) {
      dir.create(dir_path)
    }
    where_to_write <-  paste0(file_path)
  }

  s3 <- paws.storage::s3()

  s3$download_file(
    Bucket = bucket_name,
    Key = if (grepl("^/", key)) {
      key
    } else {
      paste0("/", key)
    },
    Filename = where_to_write,
    ...
  )
  message(sprintf("%s will be downloaded here: %s", key, where_to_write))

  return(invisible(where_to_write))
}