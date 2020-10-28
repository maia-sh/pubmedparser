#' Extract PMIDs and DOIs from E-Utils esummary
#'
#' The [NLM ID Converter](https://www.ncbi.nlm.nih.gov/pmc/pmctopmid/#converter) is restricted to records in the PMC corpus, as are tools built on its [API](https://www.ncbi.nlm.nih.gov/pmc/tools/id-converter-api/) such as [rcrossref::id_converter](https://docs.ropensci.org/rcrossref/reference/id_converter.html).
#'
#' [E-Utils esummary](https://dataguide.nlm.nih.gov/eutilities/utilities.html#esummary) includes articles identifiers.
#'
#' @param esummary esummary record. Generally the output of [rentrez::entrez_summary](https://docs.ropensci.org/rentrez/reference/entrez_summary.html).
#' @return One-row tibble of character DOI and numeric PMID associated with record.
#'
#' @examples
#' esummary <- rentrez::entrez_summary(db = "pubmed", id = "29848381")
#' \dontrun{
#' extract_dois_pmids(esummary)
#' }
#'
#'@export

extract_dois_pmids <- function(esummary) {

  esummary$articleids %>%
    # articleids %>%
    filter(idtype %in% c("pubmed", "doi")) %>%
    select(-idtypen) %>%
    pivot_wider(names_from = idtype, values_from = value) %>%
    mutate(pmid = as.numeric(pubmed)) %>%
    select(pmid, doi)
}
