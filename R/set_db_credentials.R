#' Install database credentials in your .Renviron file
#'
#' @param username A valid Postgres username
#' @param password A valid Postgres password
#' @param install If TRUE, save credentials to .Renviron. Otherwise, set per session.
#'
#' @return Username and password, invisibly
#' @export
#'
#' @importFrom crayon green
#' @importFrom crayon red
#' @importFrom cli symbol
#'

set_db_credentials <- function(username, password, install = TRUE){
  stopifnot(is.logical(install))

  if (install) {

    home <- Sys.getenv("HOME")
    renv <- file.path(home, ".Renviron")

    if (!file.exists(renv)){

      file.create(renv)

    } else {
      # Backup original .Renviron before doing anything else here.
      file.copy(renv, file.path(home, ".Renviron_backup"))

      tv <- readLines(renv)

      if(any(grepl("DB_USER", tv))){

        ans <- utils::menu(c(paste(crayon::green(cli::symbol$tick), 'Yes'),
                             paste(crayon::red(cli::symbol$cross), 'No')),
                           title = "A DB_USER already exists. Do you want to overwrite it?")

        if (ans == 1){

          cat("Your original .Renviron will be backed up and stored in your R HOME directory if needed.")

          oldenv <- utils::read.table(renv, stringsAsFactors = FALSE)$V1
          newenv <- oldenv[!grepl("DB_USER|DB_PWD", oldenv)]

          utils::write.table(newenv, renv, quote = FALSE, sep = "\n",
                             col.names = FALSE, row.names = FALSE
          )

        } else {

          stop(cat(crayon::red(cli::symbol$cross), "Your DB_USER was not updated."), call. = FALSE)

        }
      }

    }

    userconcat <- sprintf("DB_USER='%s'", username)
    pwdconcat <- sprintf("DB_PWD='%s'", password)

    # Append API key to .Renviron file
    write(userconcat, renv, sep = "\n", append = TRUE)
    write(pwdconcat, renv, sep = "\n", append = TRUE)

    cat(crayon::green(cli::symbol$tick), 'Your username and password have been stored in your .Renviron and can be accessed by Sys.getenv("DB_USER") and Sys.getenv("DB_PWD"). \nTo use now, restart R or run `readRenviron("~/.Renviron")`')
    return(invisible(c(username, password)))

  } else {

    Sys.setenv(DB_USER = username)
    Sys.setenv(DB_PWD = password)

    cat(crayon::green(cli::symbol$tick), "DB_USER and DB_PWD set for current session. To install your usenrame and password for use in future sessions, run this function with `install = TRUE`.")
  }
}
