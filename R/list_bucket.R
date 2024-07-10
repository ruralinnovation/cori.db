#' List every "keys" from a bucket
#'  
#' load credentials into the current environment.
#' This actions will overwrite any values currently
#' stored in AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY.
#'
#' @param Bucket string, example "test-coridata""
#'
#' @return a data frame with ...
#' @export
#'
#' @import paws
#' 
#' @examples
#'
#' \dontrun{
#' 
#' }
#'

list_bucket <- function(bucket_name) {

    s3 <- paws::s3()
    
    bob <- s3$list_objects(Bucket = bucket_name)

    gimme_me_key <- function(x) x[["Key"]]
    gimme_me_last_modified <- function(x) {x[["LastModified"]]}

    df_temp <- data.frame(
        key = do.call(rbind, lapply(bob[["Contents"]], gimme_me_key)),
        last_modified = as.POSIXlt(do.call(rbind, lapply(bob[["Contents"]], gimme_me_last_modified)))
    )

    sapply(strsplit(df_temp$key, "/"), function(x) length(x))

    dbo.call(rbind, lapply(bucket[["Contents"]]), function(x) x[["Key"]])
}