#' Originally from:
#'   https://stackoverflow.com/questions/44853322/how-to-read-the-contents-of-an-sql-file-into-an-r-script-to-run-a-query#answer-44886192
#'
#'   "I've had trouble with reading sql files myself, and have found that often times the syntax gets broken if there
#'   are any single line comments in the sql. Since in R you store the sql statement as a single line string, if there
#'   are any double dashes in the sql it will essentially comment out any code after the double dash.
#'
#'   This is a function that I typically use whenever I am reading in a .sql file to be used in R."
#'
#' @param filepath path to a SQL script (.sql extension)
#'
#' @return A string vector of SQL statements extracted from the script
#' @export
#'
get_sql <- function (filepath){
  con <- file(filepath, "r")
  sql.seperator <- ";"
  sql.string <- ""
  sql.statements <- character(0)

  while (TRUE){
    line <- readLines(con, n = 1)

    if ( length(line) == 0 ){
      break
    }

    line <- gsub("\\t", " ", line)

    if(grepl("--",line) == TRUE){
      line <- paste(sub("--","/*",line),"*/")
    }

    sql.string <- paste(sql.string, line)

    # message(sql.string)

    if (grepl(sql.seperator, sql.string)) {
      message(paste("Statement: ", sql.string))
      sql.statements <- c(sql.statements, sql.string)
      sql.string <- ""
    }
  }

  close(con)
  return(sql.statements)
}
