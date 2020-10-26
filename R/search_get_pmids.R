#' Run E-utilities search and save PMIDs
#'
#' Batch IDs to account for Eutils server limits
#' @param term Query for search
#' @param dir Directory for saving files. Default to project root (\code{here::here()})
#' @param file_name Root for file names. Default to NULL and dynamically set to esearch query.
#' @param output Save full esearch record (as "rds") and/or PMIDs (as "rda" and/or "txt". Default to all (\code{c("rda", "rds", "txt")})

#' @return Esearch object
#'
#' @examples
#' # Run search and don't save any output
#' records_search <- search_get_pmids(term = "aquilegia[TITLE]",
#'                                    dir = NULL, output = NULL)
#'
#'@export


search_get_pmids <- function(term,
                             file_name = NULL,
                             dir = here::here(),
                             output = c("rda", "rds", "txt")) {

  # Create directory if it doesn't exist
  if (!fs::dir_exists(dir)) {fs::dir_create(dir)}

  # Get number of records
  esearch <-
    rentrez::entrez_search(db = "pubmed",
                           term = term,
                           use_history = FALSE,
                           # rettype = "count", #Error in ans[[1]] : subscript out of bounds
                           retmax = 0
    )

  # Get records with all PMIDs and post history
  esearch <-
    rentrez::entrez_search(db = "pubmed",
                           term = esearch$QueryTranslation,
                           use_history = TRUE,
                           retmax = esearch$count
    )

  # Set file_name to query translation if not user-specified
  if(is.null(file_name)) {file_name <- esearch$QueryTranslation}

  # Log info about the search
  loggit::loggit("ESEARCH", echo = FALSE, custom_log_lvl = TRUE,
                 log_msg  = "Esearch posted to history server",
                 esearch_new = TRUE,
                 esearch_query = esearch$QueryTranslation,
                 esearch_count = esearch$count,
                 esearch_webenv = esearch$web_history$WebEnv
  )


  # Save esearch record as rds
  if ("rds" %in% output) {
    readr::write_rds(
      esearch,
      paste0(dir, "/", Sys.Date(), "_" , file_name, "_pmids.rds")
    )
  }

  # Save pmid's as rda
  # Note: save() doesn't work with esearch$ids, so assigned to pmids
  if ("rda" %in% output) {

    pmids <- esearch$ids

    save(
      pmids,
      file =
        paste0(dir, "/", Sys.Date(), "_" , file_name, "_pmids.rda")
    )
  }

  # Save pmid's as txt
  if ("txt" %in% output) {
    readr::write_lines(
      esearch$ids,
      paste0(dir, "/", Sys.Date(), "_" , file_name, "_pmids.txt")
    )
  }

  esearch

}
