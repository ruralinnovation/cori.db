#' Connect to CORI/RISI Postgres DB
#'
#' @param schema A vector of schema names to add to the search path (e.g. 'sch_layer', sch_broadband', etc.)
#' @param host Database host, defaults to the host for the main MDA Potgres database.
#' @param dbname Database name to connect to. Defaults to main MDA Postgres database
#' @param port Port name to connect to. Defaults to port for main MDA Postgres database
#' @return A pqconnection object
#' @export
#'
connect_to_db <- function(schema,
                          host = "cori-risi-ad-postgresql.c6zaibvi9wyg.us-east-1.rds.amazonaws.com",
                          dbname = "data", port = 5432) {

    uname <- Sys.getenv("DATABASE_USER_AD")
    pwd   <- Sys.getenv("DATABASE_PASSWORD_AD")

  con  <- DBI::dbConnect(

    RPostgres::Postgres(),
    user     = uname,
    password = pwd,
    dbname   = dbname,
    host     = host,
    port     = port,
    options  = sprintf('-c search_path=%s'
                       , paste0(c(schema, '"$user"', 'public', 'postgis', 'contrib')
                                , collapse = ","))
  )

  try(DBI::dbExecute(con, "set role mda_team;"))

  return(con)
}
