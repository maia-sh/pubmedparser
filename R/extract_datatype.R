#' Extract specified datatype from PubMed xml into csv
#'
#' @param datatype Type of data to extract from xml for which there is a corresponding "pubmed_" function ("table", "abstract", "databanks", "authors", "mesh", "keywords", "pubtypes")
#' @param nodes Article node set
#' @param file_name Root for file names. Default to "pubmed".
#' @param suffix Suffice for file names. For example, record numbers. Default to null.
#' @param dir Directory for saving files. Default to project root (\code{here::here()})
#' @param quiet Whether to silence messages in console. Defaults to FALSE.
#' @export

extract_datatype <- function(datatype,
                             nodes,
                             file_name = "pubmed",
                             suffix = NULL,
                             dir = here::here(),
                             quiet = FALSE) {

  if (!datatype %in% c("table", "abstract", "databanks", "authors", "mesh", "keywords", "pubtypes")){
    rlang::abort(
      message = 'Invalid datatype. Must be from: "table", "abstract", "databanks", "authors", "mesh", "keywords", "pubtypes"'
    )

    loggit::loggit("PARSE_XML_ERROR", echo = FALSE, custom_log_lvl = TRUE,
                   log_msg  = cat(datatype, " invalid")
    )
  }

  readr::write_csv(
    rlang::exec(paste0("pubmed_", datatype), nodes),
    paste0(dir, "/",
           Sys.Date(),"_",
           file_name, "_",
           datatype,
           if (!is.null(suffix)) paste0("_", suffix),
           ".csv"
    )
  )

  # Report batch info
  # If don't want to loggit, echo = FALSE
  if (!quiet){
    rlang::inform(
      # Can't report on n_batches, since function doesn't know
      # "Batch ", n_batch, " of ", n_batches, ": ",
      message = cat(
        "Parse xml: ", datatype
        # "Fetched ", batch_end - batch_start + 1, " records ",
        # "from ", batch_start, " through ", batch_end
      )
    )
  }

  # Log batch info
  loggit::loggit("PARSE_XML", echo = FALSE, custom_log_lvl = TRUE,
                 log_msg  = datatype#,
                 # esearch_new = NA,
                 # esearch_query = esearch$QueryTranslation,
                 # esearch_count = esearch$count,
                 # esearch_webenv = esearch$web_history$WebEnv,
                 # efetch_n_records  = batch_end - batch_start + 1,
                 # efetch_start = batch_start,
                 # efetch_end = batch_end
  )
}
