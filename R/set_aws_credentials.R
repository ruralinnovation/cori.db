#' Install aws credentials in your .Renviron file and
#' load credentials into the current environment.
#' This actions will overwrite any values currently
#' stored in AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY.
#'
#' @param keyID A valid Key ID
#' @param accesKey A valid Access key
#' @param region A valid AWS region (default set )
#' @param install If TRUE, save credentials to .Renviron. Otherwise, set per session.
#'
#' @return keyID, accesKey and region, invisibly
#' @export
#'
#' @importFrom crayon green
#' @importFrom crayon red
#' @importFrom cli symbol
#'

set_aws_credentials <- function(keyID, accesKey,
                                region = "us-east-1",
                                install = TRUE) {
  stopifnot(is.logical(install))

  if (install) {

    home <- Sys.getenv("HOME")
    renviron <- file.path(home, ".Renviron")

    if (!file.exists(renviron)){

      file.create(renviron)

    } else {
      # Backup original .Renviron before doing anything else here.
      file.copy(renviron, file.path(home, ".Renviron_backup"))

      tv <- readLines(renviron)

      if(any(grepl("AWS_ACCESS_KEY_ID", tv))) {

        ans <- utils::menu(c(paste(crayon::green(cli::symbol$tick), "Yes"),
                             paste(crayon::red(cli::symbol$cross), "No")),
                           title = paste("A AWS_ACCESS_KEY_ID",
                                         "already exists.",
                                         "Do you want to overwrite it?"))

        if (ans == 1) {

          cat("Your original .Renviron will be backed up and stored in your R HOME directory if needed.")

          oldenv <- utils::read.table(renviron, stringsAsFactors = FALSE)$V1
          newenv <- oldenv[!grepl("AWS_ACCESS_KEY_ID|AWS_SECRET_ACCESS_KEY", oldenv)]

          utils::write.table(newenv, renviron, quote = FALSE, sep = "\n",
                             col.names = FALSE, row.names = FALSE
          )

        } else {

          stop(cat(crayon::red(cli::symbol$cross), "Your AWS_ACCESS_KEY_ID was not updated."), call. = FALSE)

        }
      }

    }

    userconcat <- sprintf("AWS_ACCESS_KEY_ID='%s'", keyID)
    pwdconcat <- sprintf("AWS_SECRET_ACCESS_KEY='%s'", accesKey)
    regionconcat <- sprintf("AWS_DEFAULT_REGION='%s'", region)

    # Append API key to .Renviron file
    write(userconcat, renviron, sep = "\n", append = TRUE)
    write(pwdconcat, renviron, sep = "\n", append = TRUE)
    write(regionconcat, renviron, sep = "\n", append = TRUE)

    Sys.setenv(AWS_ACCESS_KEY_ID = keyID)
    Sys.setenv(AWS_SECRET_ACCESS_KEY = accesKey)

    cat(crayon::green(cli::symbol$tick),
        paste("Your AWS key ID  and secret key",
              "have been stored in your .Renviron",
              'and can be accessed by Sys.getenv("AWS_ACCESS_KEY_ID")',
              'and Sys.getenv("AWS_SECRET_ACCESS_KEY").',
              '\nTo use now, restart R or run `readRenviron("~/.Renviron")`'))
    return(invisible(c(keyID, accesKey)))

  } else {

    Sys.setenv(AWS_ACCESS_KEY_ID = keyID)
    Sys.setenv(AWS_SECRET_ACCESS_KEY = accesKey)

    cat(crayon::green(cli::symbol$tick),
        paste("AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY",
              "set for current session.",
              "To install your key ID and secret key",
              "for use in future sessions,",
              " run this function with `install = TRUE`."))
  }
}