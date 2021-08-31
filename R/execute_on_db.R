#' Send query to postgres for execution. Vectorized over 'query'
#'
#' @param con A database connection
#' @param query A query with no expected return value (e.g. create, drop, alter)
#'
#' @export
#' @importFrom DBI dbClearResult
#' @importFrom DBI dbSendQuery
execute_on_postgres <- function(con, query){
  vquery_db(con, query)
}
