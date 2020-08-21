#' Convert DOIs to PMIDs
#'
#' The [NLM ID Converter](https://www.ncbi.nlm.nih.gov/pmc/pmctopmid/#converter) is restricted to records in the PMC corpus, as are tools built on its [API](https://www.ncbi.nlm.nih.gov/pmc/tools/id-converter-api/) such as [rcrossref::id_converter](https://docs.ropensci.org/rcrossref/reference/id_converter.html).
#'
#' This function returns all PMIDs found for a given list of DOIs. It does **not** return the matching DOI. In order to maintain the PMID-DOI link, convert the output of this function back into a PMID using \code{\link{convert_pmid_to_doi}}.
#'
#'
#' @param dois Character vector of DOIs.
#' @param batch_size Max number of PMIDs to be fetched. Default = 100.
#' @return Numeric vector of PMIDs
#'
#' @examples
#' my_dois <- c("10.3389/fpsyt.2018.00207", "10.1186/s40779-018-0166-5", "10.1186/s12959-018-0173-5", "10.1103/PhysRevD.97.096016", "10.1038/d41586-018-05113-0")
#'
#' # Returns all available PMIDs (3 PMIDs)
#' convert_dois_to_pmids(my_dois)
#'
#' # Returns number of PMIDs within \code{batch_size} (2 PMIDs)
#' convert_dois_to_pmids(my_dois, batch_size = 3)
#'
#'@export

convert_dois_to_pmids <- function(dois, batch_size = 100) {

  query_string <- create_query_strings(dois)

  records <- rentrez::entrez_search(db = "pubmed",
                                    term = query_string,
                                    retmax = batch_size,
                                    use_history = TRUE
  )

  as.numeric(records$ids)
}
