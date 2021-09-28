#' Create template field and table metadata documents
#'
#' The templates produced by this function match the format of the \code{metadata} schema
#' metadata tables. For new data sets, create templates, fill them out, then call either \code{write_db} providing
#' the completed templates as data frames or call \code{update_metadata} directly.
#'
#' @param data_tbl Optionally provide a data frame, which will populate the \code{column_name} column with the column names
#' @param source_meta_template If \code{TRUE}, output a template for source metadata. This is only necessary if the data are sourced from a currently undocumented data source
#' @param output_csv If \code{TRUE}, write field and table metadata templates to .CSV files in the working directory
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
#' @importFrom data.table data.table
#' @importFrom data.table fwrite
#'
create_metadata_tables <- function(data_tbl = NULL, source_meta_template = FALSE, output_csv = TRUE){

  stopifnot(is.logical(output_csv))

  if (is.null(data_tbl)){

    field_meta <- data.table::data.table(table_name = "",
                                         column_name = "",
                                         description = "",
                                         data_source = ""
    )

  } else {

    field_meta <- data.table::data.table(table_name = "",
                                         column_name = names(data_tbl),
                                         description = "",
                                         data_source = ""
    )

  }

  table_meta <- data.table::data.table(table_name = "",
                                       table_schema = "",
                                       table_description = "",
                                       last_update = as.character(Sys.Date())

  )

  source_meta <- data.table::data.table(data_source = "",
                                        table_name = "",
                                        table_schema = "",
                                        source_year = "",
                                        update_cadence = ""

  )

  out <- list(field_metadata = field_meta,
              table_metadata = table_meta
  )

  if (source_meta_template){
    out['source_meta'] <- source_meta
  }

  if (output_csv){
    tbl_name <- ifelse(is.null(data_tbl), "", paste0(deparse(substitute(data_tbl)), "_"))

    data.table::fwrite(field_meta, paste0(tbl_name, "field_metadata.csv"))
    data.table::fwrite(table_meta, paste0(tbl_name, "table_metadata.csv"))



    if (source_meta_template){
      data.table::fwrite(source_meta, paste0(tbl_name, "table_metadata.csv"))
    }

    return(invisible(out))

  }

  out

}
