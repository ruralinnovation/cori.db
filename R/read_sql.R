#' Read SQL file. Vectorized over filepath
#'
#' @param filepaths Path to .SQL or .TXT file to read. Can be a vector or list of files
#'
#' @return A character vector of SQL queries
#' @export
#'
#' @importFrom stringr str_split
#' @importFrom stringr str_squish

read_sql <- function(filepaths){
  unlist(vread_sql_file(filepaths))
}
