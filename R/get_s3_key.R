#' get key/file hosted in s3 downloaded
#'
#' @return good question
#'
#' @export
#' @examples
#'
#' \dontrun{
#'  get_s3_key("test-coridata", "blabla.txt", "text.txt")
#' }
#'


get_s3_key <- function(bucket_name, key, file_path, ...) {

  s3 <- paws::s3()

  s3$download_file(
    Bucket = bucket_name,
    Key = key,
    Filename = file_path,
    ...
  )
}