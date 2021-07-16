#' Read SQL file
#'
#' @param filepath Path to .SQL or .TXT file to read
#'
#' @return A character vector of SQL queries
#' @export
#'
#' @importFrom stringr str_split
read_sql <- function(filepath){
  con <- file(filepath, "r")
  sql_string <- ""

  while (TRUE){
    line <- readLines(con, n = 1)

    if ( length(line) == 0 ){
      break
    }

    line <- gsub("\\t", " ", line)

    if(grepl("--",line) == TRUE){
      line <- paste(sub("--", "/*", line), "*/")
    }

    sql_string <- paste(sql_string, line)
  }

  close(con)
  res <- stringr::str_split(sql_string, pattern = ";")
  return(unlist(res))
}
