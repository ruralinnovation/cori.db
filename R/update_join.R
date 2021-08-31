#' Update a database table using an update join
#'
#' @param table_to_update Name of the table with the old values
#' @param table_to_update_from Name of the table with the new values
#' @param variable_update_map A list of characters corresponding to shared names of columns to update, or a named list of key value pairs in the form \code{list(variable_name_to_update = 'variable_name_to_update_from')}
#' @param key Key variable to join on or named list in the form \code{list(old_table_key = 'new_table_key')}
#' @param con A Postgres connection
#'
#' @export
#'
update_join <- function(table_to_update,
                        table_to_update_from,
                        variable_update_map,
                        key,
                        con
){
  stopifnot(length(key) == 1)

  if (is.null(names(variable_update_map))){

    # if no variable to update from is provided, we assume the variable to update and the variable to update from have the same name
    variables_to_update_from <- unlist(variable_update_map)
    variables_to_update      <- unlist(variable_update_map)

  } else {

    variables_to_update_from <- unlist(variable_update_map)
    variables_to_update      <- unlist(ifelse(names(variable_update_map) == '', variable_update_map, names(variable_update_map)))

  }

  if (is.null(names(key))){

    update_key <- unlist(key)
    update_from_key <- unlist(key)

  } else {

    update_key <- names(key)
    update_from_key <- unlist(key)

  }

  queries <- vglue_update_query(table_to_update,
                                table_to_update_from,
                                variable_to_update = variables_to_update,
                                variable_to_update_from = variables_to_update_from,
                                table_to_update_key = update_key,
                                table_to_update_from_key = update_from_key,
                                con)

  # query <- glue_sql("update {`table_to_update`} set {`variable_to_update`} = {`table_to_update_from`}.{`variable_to_update_from`} from {`table_to_update_from`} where {`table_to_update`}.{`key`} = {`new_tbl`}.{`key`};", .con = con)
  # DBI::dbClearResult(DBI::dbSendQuery(con, query))
  execute_on_postgres(con, queries)
}
