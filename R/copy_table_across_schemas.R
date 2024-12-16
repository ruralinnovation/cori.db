
copy_table_across_schemas <- function (schema_name, table_name, to_schema) {
  result <- NULL

  dest <- paste(to_schema, table_name, sep = ".")
  from <- paste(schema_name, table_name, sep = ".")

  con <- cori.db::connect_to_db(to_schema)
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

  result <- DBI::dbExecute(con,  query_to_copy_table_to_target)

  return(invisible(result))
}
