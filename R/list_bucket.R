

s3 <- paws::s3()
bob <- s3$list_objects(Bucket = "test-coridata")

gimme_me_key <- function(x) x[["Key"]]
gimme_me_last_modified <- function(x) {x[["LastModified"]]}

df_temp <- data.frame(
    key = do.call(rbind, lapply(bob[["Contents"]], gimme_me_key)),
    last_modified = as.POSIXlt(do.call(rbind, lapply(bob[["Contents"]], gimme_me_last_modified)))
)

sapply(strsplit(df_temp$key, "/"), function(x) length(x))

dbo.call(rbind, lapply(bucket[["Contents"]]), function(x) x[["Key"]])
