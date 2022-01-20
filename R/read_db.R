#' Read a database table (convenience wrapper for DBI::dbReadTable and sf::st_read)
#'
#' @param con A database connection
#' @param table The name of the table to read
#' @param spatial If TRUE return a spatial data frame
#'
#' @return A data.table or sf class dataframe
#' @export
#'
read_db <- function(con, table, spatial = FALSE){

  stopifnot(is.logical(spatial))

  if (spatial) {
    out <- sf::st_read(con, table)

  } else {
   
    out <- data.table::as.data.table(DBI::dbReadTable(con, table))
     
  }
  
  pull_metadata(con, table)
  
  return(out)

}
