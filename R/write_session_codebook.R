#' Writing session codebook to either an excel document, located in the working directory,
#' or googlesheet in your home drive.
#'
#' @param name Name of the output file. No file extension required!
#' @param out One of "excel" or "g_drive". Defines output file type.
#' The default being a .xlsx, explicitly defined as "excel",
#' or the user can define a googlesheet with "g_drive". Output file will be in snake_case.
#'
#' @export
#'
#' @importFrom googlesheets4 gs4_auth gs4_create
#' @importFrom writexl write_xlsx
write_session_codebook <- function(name, out = "excel"){

  name <- gsub("\\s+", "_", tolower(name))

  session_metadata <- load_session_metadata()

  out_location <- match.arg(out, choices = c("excel", "g_drive"))

  if(out_location == "excel"){
    writexl::write_xlsx(session_metadata, sprintf("%s.xlsx", name))
  } else {

    options(httr_oob_default = TRUE)
    googlesheets4::gs4_auth()

    googlesheets4::gs4_create(name = name, sheets = session_metadata)
  }
}
