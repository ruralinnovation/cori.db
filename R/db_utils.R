#' Listing DB schema size
#'
#' @return a data frame with two colums schema_name and size of said schema
#' 
#' @param schema string should be set to public (it is by default)
#' @param ... argument to be passed to connect_to_db()
#' 
#' @export
#'
#' @examples
#'
#' \dontrun{
#'   schema_size_db()
#' }
#'

schema_size_db <- function(schema = "public", ...) {
  # TODO should change connect to db to avoid depn on schema
  con <- connect_to_db(schema, ...)
  on.exit(DBI::dbDisconnect(con))

  # vendored: https://stackoverflow.com/questions/4418403/list-of-schema-with-sizes-relative-and-absolute-in-a-postgresql-database
  query <- "SELECT schema_name, 
                    pg_size_pretty(sum(table_size)) as size
                FROM (
                SELECT pg_catalog.pg_namespace.nspname as schema_name,
                        pg_relation_size(pg_catalog.pg_class.oid) as table_size,
                        sum(pg_relation_size(pg_catalog.pg_class.oid)) over () as database_size
                FROM   pg_catalog.pg_class
                    JOIN pg_catalog.pg_namespace ON relnamespace = pg_catalog.pg_namespace.oid
                ) t
                GROUP BY schema_name, database_size
                ORDER by schema_name asc"

  DBI::dbGetQuery(con, query)
}