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

pull_metadata <- function(con, table){

  # table <-  paste(sprintf("'%s'", table), collapse = ", ")

  # cat(table, "\n")
  metadata_classes <- c('source', 'table', 'field')
  file_paths <- paste(tempdir(),'session_metadata', metadata_classes, paste0("%s",'.csv') ,sep ="/")
  names(file_paths) <- metadata_classes

  if(!dir.exists(paste(tempdir(),'session_metadata', sep ="/"))){ ## check if temp directory already exists
    dir.create(paste(tempdir(),'session_metadata', sep ="/"))

    for(class in metadata_classes){
      dir.create(paste(tempdir(),'session_metadata',class, sep ="/"))
    }

  }


  cat(glue::glue_sql('select * from metadata.table_metadata where table_name in ({table*})', .con = con), "\n")
  table_metadata <- DBI::dbGetQuery(con,glue::glue_sql('select * from metadata.table_metadata where table_name in ({table*})', .con = con))
  if(nrow(table_metadata) == 0){
    message("No table metadata exists in the database")
    return(NULL)
  }

  data.table::fwrite(table_metadata, file = sprintf(file_paths["table"], paste0(table, collapse = "")))

  ## write table metadata out to the temp dir
  field_metadata <- DBI::dbGetQuery(con, glue::glue_sql('select * from metadata.field_metadata where table_name in ({table*})', .con = con))

  if(nrow(field_metadata) > 0){

    source_metadata <- DBI::dbGetQuery(con, glue::glue_sql('select * from metadata.source_metadata where source_code in ({unique(field_metadata$source_code)*})', .con = con))
    data.table::fwrite(field_metadata, file = sprintf(file_paths["field"],  paste0(table, collapse = "")))

    if(nrow(source_metadata) > 0){

      data.table::fwrite(source_metadata, file = sprintf(file_paths["source"],  paste0(table, collapse = "")))

    }
  }
  message(paste("Metadata for", table,"has been stored in a temp directory\n"))
}
