#' Fetch a batch of records
#'
#' Batch IDs to account for Eutils server limits
#' @param esearch Esearch object. Generally the output of \code{\link{search_get_pmids}} or \code{\link{check_update_esearch}}.
#' @param  batch_start Record batch should start with. Default to 1.
#'  @param  batch_size Maximum batch size. Defaults to 10000, which is eutilities' limit.
#'  @param save_file Whether batch should be saved as raw characters to file. Defaults to TRUE.
#'  @param dir Directory for saving files. Default to project root (\code{here::here()})
#'  @param file_name Root for file names. Default to NULL and dynamically set to esearch query.
#' @param quiet Whether to silence messages in console. Defaults to FALSE.
#' @param dir Directory for saving files. Default to project root (\code{here::here()})
#' @return Efetch object as raw characters
#'
#' @examples
#' # Run search and don't save any output
#' records_search <- search_get_pmids(term = "aquilegia[TITLE]",
#'                                    dir = NULL, output = NULL)
#' batch <- fetch_batch(records_search)
#'
#'@export

fetch_batch <- function(esearch, #or web_history?
                        batch_start = 1,
                        batch_size = 10000,
                        save_file = TRUE,
                        dir = here::here(),
                        file_name = NULL,
                        quiet = FALSE) {

  # Batch ends at batch max or query max, whichever is smaller
  batch_end <- min(batch_start + batch_size - 1, esearch$count)

  # Entrez fetch uses retstart = batch_start + 1, so decrease batch_start by 1
  # Documentation is wrong: https://dataguide.nlm.nih.gov/eutilities/utilities.html#efetch
  efetch <-
    rentrez::entrez_fetch(db = "pubmed",
                          web_history = esearch$web_history,
                          rettype = "xml",
                          parsed = FALSE,
                          retmax = batch_size,
                          retstart = batch_start - 1
    )

  if (save_file) {
    readr::write_file(efetch,
                      paste0(dir, "/",
                             Sys.Date(),"_",
                             esearch$QueryTranslation, "_",
                             format(batch_start, scientific = FALSE), "-",
                             format(batch_end, scientific = FALSE), ".txt"
                      )
    )
  }

  # Report batch info
  # If don't want to loggit, echo = FALSE
  if (!quiet){
    rlang::inform(
      # Can't report on n_batches, since function doesn't know
      # "Batch ", n_batch, " of ", n_batches, ": ",
      message = cat(
        "Fetched ", batch_end - batch_start + 1, " records ",
        "from ", batch_start, " through ", batch_end
      )
    )
  }

  # Log batch info
  loggit::loggit("EFETCH", echo = FALSE, custom_log_lvl = TRUE,
                 log_msg  = "Fetched records",
                 esearch_new = NA,
                 esearch_query = esearch$QueryTranslation,
                 esearch_count = esearch$count,
                 esearch_webenv = esearch$web_history$WebEnv,
                 efetch_n_records  = batch_end - batch_start + 1,
                 efetch_start = batch_start,
                 efetch_end = batch_end
  )

  efetch
}