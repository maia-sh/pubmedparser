#' Check whether esearch still on server and if not re-search
#'
#' History kept on eutilities servers for less than an hour, so for large queries needs to be updated.
#' @param esearch Esearch object. Generally the output of \code{\link{search_get_pmids}}.
#'
#' @return Esearch object
#'
#' @examples
#' \dontrun{
#' records_search <- search_get_pmids(term = "aquilegia[TITLE]",
#'                                    dir = NULL, output = NULL)
#' records_search <- check_update_esearch(records_search)
#' }
#'@export

check_update_esearch <- function(esearch){

  # Check whether esummary produces error
  cnd <-
    rlang::catch_cnd(
      rentrez::entrez_summary(db = "pubmed",
                              web_history = esearch$web_history,
                              retmax = 0)
    )


  # If no message, esearch is valid
  # If too many ids in retmax for esummary, but esearch still valid, rettype = "json" throws `error`: "Esummary includes error message: Too many UIDs in request. Maximum number of UIDs is 500 for JSON format output."
  if (is_null(cnd$message) ||
      cnd$message == "Esummary includes error message: Too many UIDs in request. Maximum number of UIDs is 500 for JSON format output.") {

    rlang::inform("Esearch still valid on history server.")

    loggit::loggit("ESEARCH", echo = FALSE, custom_log_lvl = TRUE,
                   log_msg  = "Esearch still valid on history server",
                   esearch_new = FALSE,
                   esearch_query = esearch$QueryTranslation,
                   esearch_count = esearch$count,
                   esearch_webenv = esearch$web_history$WebEnv
    )


    # If error due to expired esearch, log and re-search
    # rettype = "json" throws `error`: "No esummary records found in file"
    # rettype = "xml" throws `warning`: "Unable to obtain query #1"
  } else if (cnd$message %in% c("No esummary records found in file",
                                "Unable to obtain query #1")){

    rlang::inform("Esearch no longer valid on history server. Re-posting esearch.")

    esearch <-
      rentrez::entrez_search(db = "pubmed",
                             term = esearch$QueryTranslation,
                             use_history = TRUE,
                             retmax = 0
      )

    # Could also throw error if esearch$count differs, e.g., because new records added, but not able to fix, so just log

    # Log info about the search...could also save each search, but silly since not useful later
    loggit::loggit("ESEARCH", echo = FALSE, custom_log_lvl = TRUE,
                   log_msg  = cnd$message,
                   esearch_new = TRUE,
                   esearch_query = esearch$QueryTranslation,
                   esearch_count = esearch$count,
                   esearch_webenv = esearch$web_history$WebEnv
    )

    # TODO: Add error to re-search: Esummary includes error message: Too many UIDs in request. Maximum number of UIDs is 500 for JSON format output.
    # For any other error or warning, throw error
  } else {

    rlang::abort(message = cnd$message)

  }

  esearch
}
