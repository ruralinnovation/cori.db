#' Search for table names in Postgres information schema
#'
#' @param con A valid database connection
#' @param table_search_string A search string, defaults to a wildcard matching all table names. Searches using SQL 'like' so use percent sign for partial matching
#' @param schema Optional name of schema to search in
#'
#' @return Data.frame of search results, including table and schema names
#' @export
#'
search_db_tables <- function(con, table_search_string = "%", schema = NULL){

  if (!is.null(schema)){
    query <- glue::glue_sql("select table_schema, table_name from information_schema.tables
                            where table_name like {table_search_string} and table_schema = {schema}", .con = con)
  } else {
    query <- glue::glue_sql("select table_schema, table_name from information_schema.tables
                            where table_name like {table_search_string}", .con = con)
  }

  res <- DBI::dbGetQuery(con, query)

  return(res)

}
