#' Update a database table using an update join
#'
#' @param old_tbl Name of the table with the old values
#' @param new_tbl Name of the table with the new values
#' @param key Key variable to join on
#' @param con A Postgres connection
#' @param variable_to_update The variable to update in old_tbl
#' @param variable_to_update_from The variable in new_tbl to use to update the values in old_tbl
#'
#' @export
#'
update_join <- function(old_tbl,
                        new_tbl,
                        variable_to_update,
                        variable_to_update_from = NULL,
                        key,
                        con
){

  if (is.null(variable_to_update_from)){
    # if no variable to update from is provided, we assume the variable to update and the variable to update from have the same name
    variable_to_update_from <- variable_to_update
  }

  query <- glue_sql("update {`old_tbl`} set {`variable_to_update`} = {`new_tbl`}.{`variable_to_update_from`} from {`new_tbl`} where {`old_tbl`}.{`key`} = {`new_tbl`}.{`key`};", .con = con)
  DBI::dbClearResult(DBI::dbSendQuery(con, query))
}
