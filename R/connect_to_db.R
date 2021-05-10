#' Connect to CORI/RISI Postgres DB
#'
#' @param schema A vector of schema names to add to the search path (e.g. 'sch_layer', sch_broadband', etc.)
#' @param config_name An optional name of a set of credentials in a config file. Must contatin fields 'user' and 'password'. Alternatively, set the environment variables 'DB_USER' and 'DB_PWD' in R Studio.
#' @param config_file Path to the config file to use, if not using environment variables. Defaults to "../base/config.yml"
#'
#' @return A pqconnection object
#' @export
#'
connect_to_db <- function(schema, config_name = NULL, config_file = "../base/config.yml"){

  if (!is.null(config_name)){

    conf  <- config::get(config_name, file = config_file)
    uname <- conf$user
    pwd   <- conf$password

  } else {

    uname <- Sys.getenv("DB_USER")
    pwd   <- Sys.getenv("DP_PWD")

  }


  con  <- DBI::dbConnect(

    RPostgres::Postgres(),
    user     = uname,
    password = pwd,
    dbname   = "data",
    host     = "cori-risi.c6zaibvi9wyg.us-east-1.rds.amazonaws.com",
    port     = 5432,
    options  = sprintf('-c search_path=%s', paste0(schema, collapse = ","))

  )

  return(con)
}
