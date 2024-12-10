skip_if_no_renviron <- function() {
  renviron <- file.path(Sys.getenv("HOME"), ".Renviron")
  if (!file.exists(renviron)) {
    skip("No .Renviron")
  }
}

test_that("Check if we can write to staging", {
  skip_if_no_renviron()
  con <- connect_to_db("staging")
  DBI::dbWriteTable(con, "mtcars", mtcars, overwrite = TRUE)
  mtcars_DB <- DBI::dbGetQuery(con, "select * from mtcars")
  DBI::dbDisconnect(con)
  expect_equal(nrow(mtcars), nrow(mtcars_DB))
})

test_that("Check if we apend=false, overwrite=true error us", {
  skip_if_no_renviron()
  con <- connect_to_db("staging")
  DBI::dbDisconnect(con)
  expect_error(cori.db::write_db(con,
                                 "mtcars",
                                 mtcars,
                                 overwrite = FALSE))
})