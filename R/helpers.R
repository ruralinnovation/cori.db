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
