#' List every "keys" from a bucket
#' 
#' @param bucket_name string, example "test-coridata""
#'
#' @return a data frame with ...
#' @export
#'
#' @import paws
#' 
#' @examples
#'
#' \dontrun{
#' # do an example
#' }
#'

list_bucket <- function(bucket_name) {

  s3 <- paws::s3()

  first_page <- paws::paginate(s3$list_objects_v2(Bucket = bucket_name))

  if (! first_page[[1]][["IsTruncated"]]) {

    gimme_me_key <- function(x) x[["Key"]]
    gimme_me_last_modified <- function(x) {x[["LastModified"]]}

    df_temp <- data.frame(
        key = do.call(rbind, lapply(first_page[[1]][["Contents"]], gimme_me_key)),
        last_modified = as.POSIXlt(do.call(rbind, lapply(first_page[[1]][["Contents"]], gimme_me_last_modified)))
    )

    return(df_temp)
  } else {
    print("more than 1K keys")
  }
}