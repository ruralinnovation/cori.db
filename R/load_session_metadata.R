#' Loads session metadata from temp directory
#'
#' @return Returns table, field, and source metadata in a named list.
#' @export
#' @importFrom dplyr bind_rows
#' @importFrom data.table fread
load_session_metadata <- function(){

  if(!dir.exists(paste(tempdir(),'session_metadata', sep = "/"))){
    stop('No session metadata.')
  }

  metadata_types <- c('table', 'field', 'source')

  session_metadata <- lapply(metadata_types, function(type){

    files <- list.files(paste(tempdir(), 'session_metadata',type, sep = "/"))
    file_paths <- paste(tempdir(), 'session_metadata',type, files, sep = "/")

    if(length(file_paths) == 0){
      no_metadata <- data.frame(meta = "Metadata unavailable")
      return(no_metadata)
    }

    res <- dplyr::bind_rows(lapply(file_paths, data.table::fread))

    return(res)
  })

  names(session_metadata) <- metadata_types

  class(session_metadata) <- append(class(session_metadata), "session_metadata")

  session_metadata

}
