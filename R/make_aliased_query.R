#' Create a quoted SQL query with column aliasing from named list
#'
#' @param named_list A named list
#' @param source_table The name of the table to select from
#' @param command What to do with the aliased query (e.g. 'create table foo as'). Defaults to 'select'.
#' @param con A database connection for glue::glue_sql()
#'
#' @return SQL query string
#' @export
#'
#' @importFrom glue glue_sql
#' @importFrom purrr map2
make_aliased_query <- function(named_list, source_table, command = "select", con){
  query <- sprintf("%s %s from %s;",
                   command,
                   paste0(map2(named_list, names(named_list), ~{
                     glue_sql("{`.x`} as {`.y`}", .con = con)
                   }), collapse = ", "),
                   source_table
  )

  return(query)

}
