query_db <- function(con, query){
  DBI::dbClearResult(DBI::dbSendQuery(con, query))
}

vquery_db <- Vectorize(query_db, vectorize.args = 'query')

glue_update_query <- function(table_to_update,
                              table_to_update_from,
                              variable_to_update,
                              variable_to_update_from,
                              table_to_update_key,
                              table_to_update_from_key,
                              con
){
  query <- glue_sql("update {`table_to_update`} set {`variable_to_update`} = {`table_to_update_from`}.{`variable_to_update_from`}
                    from {`table_to_update_from`} where {`table_to_update`}.{`table_to_update_key`} = {`table_to_update_from`}.{`table_to_update_from_key`};", .con = con)
  query
}

vglue_update_query <- Vectorize(glue_update_query, vectorize.args = c('variable_to_update', 'variable_to_update_from'))


read_sql_file <- function(filepath){
  con <- file(filepath, "r")
  sql_string <- ""

  while (TRUE){
    line <- readLines(con, n = 1)

    if ( length(line) == 0 ){
      break
    }

    if(grepl("--", line)){
      line <- ""
      # next
    }

    line <- gsub("\\t", " ", line)


    sql_string <- paste(sql_string, line)
  }

  close(con)
  res <- stringr::str_split(sql_string, pattern = ";")
  res <- stringr::str_squish(unlist(res))
  return(res[res != ""])
}

vread_sql_file <- Vectorize(read_sql_file, vectorize.args = "filepath")


stop_quietly <- function(...) {
  opt <- options(show.error.messages = FALSE)
  on.exit(options(opt))
  cat(paste(..., collapse = " "))
  stop()
}
