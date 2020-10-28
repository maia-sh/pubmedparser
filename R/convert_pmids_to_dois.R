#' Convert PMIDs to DOIs
#'
#' The [NLM ID Converter](https://www.ncbi.nlm.nih.gov/pmc/pmctopmid/#converter) is restricted to records in the PMC corpus, as are tools built on its [API](https://www.ncbi.nlm.nih.gov/pmc/tools/id-converter-api/) such as [rcrossref::id_converter](https://docs.ropensci.org/rcrossref/reference/id_converter.html).
#'
#'
#' @param pmids Character vector of PMIDs.
#' @param batch_size Max number of DOIs to be fetched. Default = 100.
#' @return Tibble of character DOIs and numeric PMIDs
#'
#' @examples
#' my_pmids <- c("29904359", "29855634", "29848381", "29805157")
#'
#' \dontrun{
#' # Returns all available PMIDs (3 PMIDs)
#' convert_pmids_to_dois(my_pmids)
#'
#' # Returns number of PMIDs within \code{batch_size} (2 PMIDs)
#' convert_pmids_to_dois(my_pmids, batch_size = 3)
#' }
#'@export

convert_pmids_to_dois <- function(pmids, batch_size = 100) {

  esummary <- entrez_summary(db = "pubmed", id = pmids, retmax = batch_size)

  # Process single or multiple records
  if (any(class(esummary) %in% "esummary")) {

    extract_dois_pmids(esummary)

  } else if (any(class(esummary) %in% "esummary_list")) {

    map_dfr(esummary, extract_dois_pmids)
  }
}
