#' Create template field and table metadata documents
#'
#' The templates produced by this function match the format of the metadata schema
#' metadata tables. For new data sets, create templates, fill them out, then call either `write_db` providing
#' the completed templates as data frames or call `update_metadata` directly.
#'
#' @param data_tbl Optionally provide a data frame, which will populate the `column_name` column with the column names
#' @param source_meta_template If `TRUE`, output a template for source metadata. This is only necessary if the data are sourced from a currently undocumented data source
#' @param output_csv If `TRUE`, write field and table metadata templates to .CSV files in the working directory
#'
#' @return A named list with field and table metadata templates
#' @export
#'
#' @examples
#'
#' \dontrun{
#' create_metadata_tables(mtcars, output_csv = FALSE)
#' }
#'
#' @importFrom data.table as.data.table
#' @importFrom data.table fwrite
#' @importFrom crayon green
#' @importFrom cli symbol
#' @importFrom cori.utils get_params
#'
create_metadata_tables <- function(data_tbl = NULL, source_meta_template = FALSE, output_csv = TRUE){

  # nse check cleanup
  ncols <- nrows <- last_update <- column_name <- `:=` <- NULL

  stopifnot(is.logical(output_csv))

  pkg_params <- cori.utils::get_params('metadata', system.file("params", "package_params.yml", package = 'cori.db', mustWork = TRUE))

  field_meta <- data.table::as.data.table(data.frame(pkg_params$field_metadata))
  table_meta <- data.table::as.data.table(data.frame(pkg_params$table_metadata))
  source_meta <- data.table::as.data.table(data.frame(pkg_params$source_metadata))

  if (!is.null(data_tbl)){

    field_meta <- data.table::as.data.table(dplyr::add_row(field_meta, column_name = names(data_tbl)))
    field_meta <- field_meta[column_name != ""]

    table_meta[, last_update := as.character(Sys.Date())]
    table_meta[, ncols := ncol(data_tbl)]
    table_meta[, nrows := nrow(data_tbl)]

  }

  out <- list(field_metadata = field_meta,
              table_metadata = table_meta
  )

  if (source_meta_template){
    out[['source_meta']] <- source_meta
  }

  if (output_csv){
    tbl_name <- ifelse(is.null(data_tbl), "", paste0(deparse(substitute(data_tbl)), "_"))

    data.table::fwrite(field_meta, paste0(tbl_name, "field_metadata.csv"))
    data.table::fwrite(table_meta, paste0(tbl_name, "table_metadata.csv"))



    if (source_meta_template){
      data.table::fwrite(source_meta, paste0(tbl_name, "source_metadata.csv"))
    }

    cat(crayon::green(cli::symbol$tick), " Metadata .CSVs created\n", sep = "")

    return(invisible(out))

  }

  out

}
