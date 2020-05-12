#' Get PMIDs and full PubMed records
#'
#' Get PMIDs and full PubMed records.
#' NOTE: silently drop DOIs without PMIDs (i.e., DOIs *not* in PubMed)
#' NOTE: Output is unparsed XML saved as ".txt" files, so that user can choose to parse with `XML` or `xml2` packages.
#'
#' @param query_string Character vector of one or more PubMed query strings. Generally the output of \code{\link{create_query_strings}}.
#' @param batch_size Number of DOIs to include per batch. Default = 100.
#' @return Character vector of length number of batches (length \code{query_string}) of unparsed XML with root node "PubmedArticleSet"
#' @export
#' @examples
#'
#' # Fetch a single PubMed batch
#' my_query_single <- '"10.3389/fpsyt.2018.00207"[DOI] OR "10.1186/s40779-018-0166-5"[DOI] OR "10.1186/s12959-018-0173-5"[DOI] OR "10.1103/PhysRevD.97.096016"[DOI] OR "10.1038/d41586-018-05113-0"[DOI]'
#'
#' batch_fetch_pubmed_records(my_query_single)
#'
#' # Fetch a multiple PubMed batches
#' my_query_multi <- c('"\"10.3389/fpsyt.2018.00207\"[DOI] OR \"10.1186/s40779-018-0166-5\"[DOI] OR \"10.1186/s12959-018-0173-5\"[DOI]"', '"\"10.1103/PhysRevD.97.096016\"[DOI] OR \"10.1038/d41586-018-05113-0\"[DOI]"')
#'
#' batch_fetch_pubmed_records(my_query_multi, batch_size = 3)

# TODO: assign batch_size
# TODO: get intermediary output from esearch

batch_fetch_pubmed_records <- function(query_string, batch_size = 100) {
  purrr::map_chr(query_string, fetch_pubmed_records, batch_size)
}

fetch_pubmed_records <- function(query_string, batch_size = 100) {

  pmids <-
    rentrez::entrez_search(db = "pubmed", term = query_string,
                  retmax = batch_size, use_history = TRUE)

  pubmed_data <-
    rentrez::entrez_fetch(db = "pubmed", web_history = pmids$web_history,
                 rettype = "xml", parsed = FALSE, retstart = NULL, retmax = NULL)
}
