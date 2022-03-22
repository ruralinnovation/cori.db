#' Read MDA ACS data from the database
#'
#' @param con A database connection
#' @param variables A vector of variables to pull
#' @param year The desired year of data. If not provided, function pulls latest available year
#' @param geography Desired geography, currently one of county or place (as of 1/7/21)
#' @param tidy If TRUE return data as a tidy dataframe. Otherwise, retrieve unmodified normalized data
#'
#' @return A data frame
#' @export
#'
#' @importFrom glue glue_sql
#' @importFrom DBI dbGetQuery
#' @importFrom data.table setDT dcast
#' @importFrom stats as.formula
#'
read_acs <- function(con, variables, year = NULL, geography = 'county', tidy = TRUE){

  # match geo arg
  geo <- match.arg(geography, c('county', 'place', 'state', 'us'))
  # get table name
  tbl <- sprintf("acs_5_yr_%s", geo)

  if (is.null(year)){ # if no yuear provided, get latest
    query <- glue::glue_sql("select * from acs.{`tbl`} where variable in ({variables*}) and year = (select max(year) from acs.{`tbl`});", .con = con)
  } else {
    query <- glue::glue_sql("select * from acs.{`tbl`} where variable in ({variables*}) and year in ({year*});", .con = con)
  }

  long_dta <- DBI::dbGetQuery(con, query)

  # if user doesn't ask for tidy data, exit early
  if (!tidy) return(long_dta)

  data.table::setDT(long_dta)

  geoid_var <- names(long_dta)[grepl("geoid", names(long_dta))]

  data.table::dcast(long_dta, stats::as.formula(paste0(geoid_var, ' + year ~ variable')), value.var = 'estimate')

}

