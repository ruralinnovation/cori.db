#' Copy a table from one schema to another within the same CORI/RISI Postgres DB instance
#' ... will fail if table already exists in to_schema:
#' ERROR:  relation "..." already exists
#'
#' @param from_schema schema name to copy the target table from
#' @param to_schema schema name to copy the target table to
#' @param table_name name of the table that will be copied
#' @param grant_select_roles vector of role names that will be granted permission to select table rows (e.g. c("read_only_access","r_team"))
#' @return the status of the copy transaction
#' @export
#'
copy_table_across_schemas <- function (from_schema, to_schema, table_name, grant_select_roles = c("read_only_access")) {

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

  result <- NULL

  query_to_copy_table_to_target <- paste0("INSERT into ", dest, "
                                              SELECT * FROM ", from, ";")

  result <- DBI::dbExecute(con,  query_to_copy_table_to_target)

  if (is.null(result) | result < 1) {
    stop(paste0("Statement failed to execute: ", query_to_copy_table_to_target), call. = FALSE)
  } else {
    tryCatch({
      message(paste0("Set access permissions on ", dest, " for..."))
      # Grant access to read_only_access group role (for testing):
      sapply(grant_select_roles, function (x) {
        message(x)
        DBI::dbExecute(con,
                       paste0("GRANT SELECT ON TABLE ", dest, " TO ", x, ";")
        )
      })
    }, error = function (e) {
      stop(paste0("Failed to set permissions on ", dest, "\n", e))
    })
  }

  return(invisible(result))
}
