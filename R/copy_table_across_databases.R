#' Copy a table between two CORI/RISI Postgres DB instances
#'
#' @param schema_name schema name in from_db with target table that will be copied to same schema name in to_db
#' @param table_name name of the table that will be copied
#' @param from_db database name to copy the target table from
#' @param to_db database name to copy the target table to
#' @param grant_select_roles vector of role names that will be granted permission to select table rows (e.g. c("read_only_access","r_team"))
#' @return a data.frame of the copied table
#' @export
#'
copy_table_across_databases <- function (schema_name, table_name, from_db, to_db, grant_select_roles = c("read_only_access")) {
  df <- NULL

  dest <- paste0('"', schema_name, '"."', table_name, '"')
  df <- (function () {
    con <- connect_to_db(schema_name, dbname = from_db)
    on.exit(DBI::dbDisconnect(con), add = TRUE)
    return(cori.db::read_db(con, table = table_name))
  })()

  if (is.null(df)) {
    stop(paste0(table_name, " is NULL"), call. = FALSE)
  } else {
    con <- cori.db::connect_to_db(schema_name, dbname = to_db)
    on.exit(DBI::dbDisconnect(con), add = TRUE)

    message(paste0("Writing data frame to tableau db as ", dest))

    cori.db::write_db(con, table_name, df, overwrite = TRUE)
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

    df <- DBI::dbReadTable(con, table_name)
  }

  return(invisible(df))
}
