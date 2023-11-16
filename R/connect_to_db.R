#' Connect to CORI/RISI Postgres DB
#'
#' @param schema A vector of schema names to add to the search path (e.g. 'sch_layer', sch_broadband', etc.)
#' @param host Database host, defaults to the host for the main MDA Potgres database.
#' @param dbname Database name to connect to. Defaults to main MDA Postgres database
#' @param port Port name to connect to. Defaults to port for main MDA Postgres database
#' @param config_name An optional name of a set of credentials in a config file. Must contain fields 'user' and 'password'. Alternatively, set the environment variables 'DB_USER' and 'DB_PWD' in R Studio.
#' @param config_file Path to the config file to use, if not using environment variables. Defaults to "../base/config.yml"
#'
#' @return A pqconnection object
#' @export
#'
connect_to_db <- function(schema,
                          host = "cori-risi-ad-postgresql.c6zaibvi9wyg.us-east-1.rds.amazonaws.com",
                          dbname = "data", port = 5432, config_name = NULL, config_file = "../base/config.yml") {

  if (!is.null(config_name)){

    conf  <- config::get(config_name, file = config_file)
    uname <- conf$user
    pwd   <- conf$password
    host <- ifelse(is.null(conf$host), host, conf$host)
    dbname <- ifelse(is.null(conf$dbname), dbname, conf$dbname)
    port <- ifelse(is.null(conf$port), port, conf$port)

  } else {

    uname <- Sys.getenv("DATABASE_USER_AD")
    pwd   <- Sys.getenv("DATABASE_PASSWORD_AD")

  }

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
