
copy_table_across_databases <- function (schema_name, table_name, from_db, to_db, grant_select_roles) {
  df <- NULL

  # grant_select_roles <- c(
  #   "read_only_access",
  #   "r_team"
  # )

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
    # DBI::dbWriteTable(con, table_name, df, overwrite = TRUE)
    cori.db::write_db(con, table_name, df, overwrite = TRUE)  # TODO: this should take optional
    #       args to set roles/permissions
    tryCatch({
      message(paste0("Set access permissions on ", dest))
      # Grant access to read_only_access group role (for testing):
      sapply(grant_select_roles, function (x) {
        DBI::dbExecute(con,
                       paste0("GRANT SELECT ON TABLE ", dest, " TO ", x, ";")
        )
      })
      # DBI::dbExecute(con, paste0("GRANT SELECT ON TABLE ", dest, " TO read_only_access;"))
      # # Grant access to r_team role:
      # DBI::dbExecute(con, paste0("GRANT SELECT ON TABLE ", dest, " TO r_team;"))
    }, error = function (e) {
      stop(paste0("Failed to set permissions on ", dest, "\n", e))
    })

    # df <- cori.db::read_db(con, table = table_name) # <= Error: ...
    df <- DBI::dbReadTable(con, table_name)
  }

  return(invisible(df))
}
