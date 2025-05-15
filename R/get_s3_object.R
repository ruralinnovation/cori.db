#' Download an object that is hosted on S3
#'
#'@details If file_path is not provided, the object will be saved in the current directory
#'
#' @param bucket_name string, a bucket name
#' @param key string, object/file that you want to download (e.g, county_data.csv)
#' @param file_path string, a path where you want the file to be downloaded ("~/Documents/my_proj/")
#' @param key_path string, path to your key in the s3 bucket (e.g., "raw/" if you want raw/county_data.csv)
#' @param ... other arguments from paws's downloadfile
#'
#' @return return invisibly the path where the file has been downloaded
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#'  txt <- get_s3_object("test-coridata", "county_data.csv", "proj_data/", key_path = "raw/")
#'  txt
#' }
#'

get_s3_object <- function(bucket_name, key, file_path, key_path = "", ...) {

  if(! has_aws_credentials()) stop("AWS credentials are missing, run set_aws_credentials()")

  # Set download path as current directory if no file_path given
  if (missing(file_path)) {
    where_to_write <- file.path(getwd(), key)
  } else {
    # Ensures no duplicate slashes
    file_path_clean <- paste0(sub("/$", "", file_path), "/", sub("^/", "", key))
    if (dir.exists(file_path) || grepl("/$", file_path)) {
      dir_path <- file_path
      where_to_write <- file_path_clean
    } else {
      dir_path <- dirname(file_path_clean)
      where_to_write <- file_path
    }

    if (!dir.exists(dir_path)) {
      dir.create(dir_path, recursive = TRUE)
    }
  }

  s3 <- paws.storage::s3()

  # Remove duplicate leading slashes
  s3_key_path <- paste0(sub("/$", "", key_path), "/", sub("^/", "", key))
  # Remove leading slashes
  s3_key_clean <- sub("^/", "", s3_key_path)

  s3$download_file(
    Bucket = bucket_name,
    Key = s3_key_clean,
    Filename = where_to_write,
    ...
  )

  message(sprintf("Downloaded '%s' to: %s", s3_key_clean, where_to_write))
  return(invisible(where_to_write))
}
