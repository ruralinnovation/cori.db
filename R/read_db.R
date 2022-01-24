#' Read a database table (convenience wrapper for DBI::dbReadTable and sf::st_read)
#'
#' @param con A database connection
#' @param table Optional name of a table to read
#' @param query An optional SQL query to execute against the database. Use to read subsets of large tables
#' @param spatial If TRUE return an SF spatial data frame
#'
#' @return A data.table or sf class dataframe
#' @export
#'
#' @importFrom sf st_read
#' @importFrom stringr str_extract_all
#' @importFrom DBI dbGetQuery
#' @importFrom data.table as.data.table
#'
read_db <- function(con, table = NULL, query = NULL, spatial = FALSE){

  stopifnot(is.logical(spatial))

  if (is.null(table) & is.null(query)){
    stop("You must provide either a table name or a valid database query")
  }

  if (is.null(query)){

    stopifnot(length(table) == 1)

    query <- sprintf('select * from "%s"', table)
  }

  if (is.null(table)){
    table <- unlist(stringr::str_extract_all(query, "(?<=from\\s)(\\w+)"))
  }

  if (spatial) {
    out <- sf::st_read(con, query = query)

  } else {

    out <- data.table::as.data.table(DBI::dbGetQuery(con, query))

  }

  pull_metadata(con, table)

  return(out)

}
