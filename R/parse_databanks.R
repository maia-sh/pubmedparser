#' Extract info about databanks from PubMed article
#'
#' Extract info about databanks from a single PubMed article. See [MEDLINE PubMed XML Elements](https://www.nlm.nih.gov/bsd/licensee/elements_descriptions.html) for details on elements. See [MEDLINE Databank Sources] (https://www.nlm.nih.gov/bsd/medline_databank_source.html) for details on databanks.
#'
#' @param pubmed_article pubmed_article Unparsed or parsed XML of class PubmedArticle. Generally called by \code{\link{parse_pubmed_article_set}} to parse articles within article set.
#' @return Dataframe of information about databanks. One row per databank.
#' @export
#' @examples

#TODO: use list columns where too many for individual columns (e.g., other_ids)
# https://tidyr.tidyverse.org/articles/nest.html
# https://r4ds.had.co.nz/many-models.html
# https://cran.r-project.org/web/packages/jstor/vignettes/Introduction.html

parse_databanks <- function(pubmed_article) {

  # Get nodes
  medline_citation <- pubmed_article %>% xml_find_first("MedlineCitation")
  pubmed_data <- pubmed_article %>% xml_find_first("PubmedData")
  databanks <- medline_citation %>% xml_find_all(".//DataBank")

  # Extract xml elements

  # Additional info
  metadata <- list(
    pmid = medline_citation %>% xml_find_all("PMID") %>% xml_integer(),
    doi = pubmed_data %>% xml_find_all("ArticleIdList/ArticleId[@IdType='doi']") %>% xml_text(),
    # Whether databank list is complete
    nlm_complete_db = medline_citation %>% xml_find_all(".//DataBankList") %>% xml_attr("CompleteYN")
  )

  # Databank infoq
  db_name <- databanks %>% xml_find_all(".//DataBankName") %>% xml_text()
  db_accession_n <- databanks %>% xml_find_all(".//AccessionNumber") %>% xml_text()
  named_accession_n <- rlang::set_names(db_accession_n, nm = db_name)

  # TIBBLE
  out <- c(metadata, named_accession_n)

  out %>%
    tidyr::replace_na() %>%
    dplyr::bind_cols()

  # named_accession_n %>% bind_rows() %>% bind_cols(pmid = medline_citation %>% xml_find_all("PMID") %>% xml_integer())

  # db_list <- list(
  #   db_name = databanks %>% xml_find_all(".//DataBankName") %>% xml_text(),
  #   db_accession_n = databanks %>% xml_find_all(".//AccessionNumber") %>% xml_text()
  # )

  # LIST
  # out <- c(metadata, db_list)
  # out <- c(metadata, db_name = db_name, db_accession_n = db_accession_n)
  # out <- list(
  #   pmid = medline_citation %>% xml_find_all("PMID") %>% xml_integer(),
  #   doi = pubmed_data %>% xml_find_all("ArticleIdList/ArticleId[@IdType='doi']") %>% xml_text(),
  #   # Whether databank list is complete
  #   nlm_complete_db = medline_citation %>% xml_find_all(".//DataBankList") %>% xml_attr("CompleteYN"),
  #
  #   db_name = databanks %>% xml_find_all(".//DataBankName") %>% xml_text(),
  #   db_accession_n = databanks %>% xml_find_all(".//AccessionNumber") %>% xml_text()
  # )
}

# dbn <- extract_parts(databanks, ".//DataBankName")
# extract_parts <- function(contribs, xpath) {
#   contribs %>%
#     map(xml_find_first, xpath) %>%
#     map(xml_text) %>%
#     map_if(is_empty, ~NA_character_) %>%
#     flatten_chr()
# }
