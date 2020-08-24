#' Check whether esearch still on server and if not re-search
#'
#' History kept on eutilities servers for less than an hour, so for large queries needs to be updated.
#' @param esearch Esearch object. Generally the output of \code{\link{search_get_pmids}}.
#'
#' @return Esearch object
#'
#' @examples
#'
#' records_search <- search_get_pmids(term = "aquilegia[TITLE]",
#'                                    dir = NULL, output = NULL)
#' records_search <- check_update_esearch(records_search)
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
  if (is_null(cnd$message)) {
    rlang::inform("Esearch still valid on history server")

    loggit::loggit("ESEARCH", echo = FALSE, custom_log_lvl = TRUE,
                   log_msg  = "Esearch still valid on history server",
                   esearch_new = FALSE,
                   esearch_query = esearch$QueryTranslation,
                   esearch_count = esearch$count,
                   esearch_webenv = esearch$web_history$WebEnv
    )


    # If error due to expired esearch or search with too many id's, log and re-search
    # if expired, rettype = "json" throws `error`: "No esummary records found in file"
    # if expired, rettype = "xml" throws `warning`: "Unable to obtain query #1"
    # if too many ids in retmax, rettype = "json" throws `error`: "Esummary includes error message: Too many UIDs in request. Maximum number of UIDs is 500 for JSON format output."
  } else if (cnd$message %in% c("No esummary records found in file",
                                "Unable to obtain query #1",
                                "Esummary includes error message: Too many UIDs in request. Maximum number of UIDs is 500 for JSON format output.")){

    rlang::inform("Esearch no longer valid on history server or too many ids for esummary. Re-posting esearch.")

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
