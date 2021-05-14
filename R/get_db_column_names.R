#' Get column names for a table from the information schema
#'
#' @param con A valid database connection
#' @param table_name The name of the table to get column names for
#'
#' @return A data.frame of search results, including schema name, table name, and column names
#' @export
#'
get_db_column_names <- function(con, table_name){

  query <- glue::glue_sql("select table_schema, table_name, column_name from information_schema.columns
                          where table_name = {table_name}", .con = con)

  res   <- DBI::dbGetQuery(con, query)

  return(res)

}
