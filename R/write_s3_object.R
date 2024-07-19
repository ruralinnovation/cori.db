#' write a data.frame into a csv in a s3 bucket
#'
#'@details it is using tempfile() shenanigans
#'
#' @param bucket_name string, a bucket name
#' @param data_frame an R object of class "data.frame", sf object are excluded
#' @param key string, object/file that you want to download
#' @param ... extra argument to pass on write.csv()
#'
#' @return return invisibly the response from AWS
#'
#' @export
#' @importFrom utils write.csv
#' 
#' @examples
#'
#' \dontrun{
#'  put_s3_object("test-coridata", cars, "cars.csv")
#' }
#'

write_s3_object <- function(bucket_name, data_frame, key, ...) {

  if (!is.data.frame(data_frame)) {
    stop(sprintf("%s need to be a data.frame",
                 deparse(substitute(data_frame))))
  }

  if (inherits(data_frame, "sf")) {
    stop(sprintf("%s is a sf object and writing to s3 have not been implemented",
                 deparse(substitute(data_frame))))
  }

  temp_file <- tempfile()
  on.exit(unlink(temp_file), add = TRUE)

  write.csv(data_frame, temp_file,  row.names = FALSE, ...)

  put_s3_object(bucket_name,
                object = temp_file, key = key)

}