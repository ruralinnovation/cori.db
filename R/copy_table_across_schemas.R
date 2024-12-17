#' Copy a table from one schema to another within the same CORI/RISI Postgres DB instance
#' ... will fail if table already exists in to_schema:
#' ERROR:  relation "..." already exists
#'
#' @param from_schema schema name to copy the target table from
#' @param to_schema schema name to copy the target table to
#' @param table_name name of the table that will be copied
#' @return the status of the copy transaction
#' @export
#'
copy_table_across_schemas <- function (from_schema, to_schema, table_name) {

  from <- paste(from_schema, table_name, sep = ".")
  dest <- paste(to_schema, table_name, sep = ".")

  con <- cori.db::connect_to_db(c(from_schema, to_schema))
  on.exit(DBI::dbDisconnect(con), add = TRUE)

  query_to_create_target <- paste0("CREATE table ", dest, " (like ", from , " including all);")

  tryCatch({
    DBI::dbExecute(con, query_to_create_target)
  }, error = function (e) {
    stop(paste0("Failed to create ", dest, "\n", e))
  })

  tryCatch({
    DBI::dbExecute(con, paste0("GRANT SELECT ON TABLE ", dest, " TO read_only_access;"))
  }, error = function (e) {
    stop(paste0("Failed to set permissions on ", dest, "\n", e))
  })

  query_to_copy_table_to_target <- paste0("INSERT into ", dest, "
                                              SELECT * FROM ", from, ";")

  return(invisible(DBI::dbExecute(con,  query_to_copy_table_to_target)))
}
