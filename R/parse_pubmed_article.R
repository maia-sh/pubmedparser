#' Extract summary info about PubMed article
#'
#' Extract summary info about a single PubMed article. Extracts only elements which are singular and not more complex elements such as authors. See [MEDLINE PubMed XML Elements](https://www.nlm.nih.gov/bsd/licensee/elements_descriptions.html) for details on elements.
#'
#' @param pubmed_article Unparsed or parsed XML of class PubmedArticle. Generally called by \code{\link{parse_pubmed_article_set}} to parse articles within article set.
#' @return Dataframe of one row with summary information about article.
#' @export
#' @examples

#TODO: better to make sub-scopes or repeat path? better to make more specific path?
#TODO: create "extract" helper functions; decide between xml_find_all() and xml_child()
#TODO: decide whether to return as tibble or list...or user option (with tibble default)

parse_pubmed_article <- function(pubmed_article) {

  # Get MedlineCitation and PubmedData of PubmedArticle (first) as nodes
  medline_citation <- pubmed_article %>% xml_find_first("MedlineCitation")
  pubmed_data <- pubmed_article %>% xml_find_first("PubmedData")

  # Extract xml elements
  # Possible Additional:  <MedlineCitation VersionID =”Value”> and <MedlineCitation VersionDate =”Value”>, <PMID Version = "#">, more <Journal> elements, GrantList, SupplMeshList, CommentsCorrectionsList, MeshHeadingList (or specific mesh terms?), OtherID

  out <- list(
    title = medline_citation %>% xml_find_all(".//ArticleTitle") %>% xml_text(),
    owner = medline_citation %>% xml_attr("Owner"),
    status = medline_citation %>% xml_attr("Status"),
    pmid = medline_citation %>% xml_find_all("PMID") %>% xml_integer(),

    #TODO: better way to select element based on attribute? e.g., xml_attr()
    # pmid2 = pubmed_data %>% xml_find_all("ArticleIdList/ArticleId") %>% .[xml_attr(., "IdType") == "pubmed"] %>% xml_integer()
    # article_id_list = pubmed_data %>% xml_find_all("ArticleIdList/ArticleId")

    pmid2 = pubmed_data %>% xml_find_all("ArticleIdList/ArticleId[@IdType='pubmed']") %>% xml_integer(),
    doi = pubmed_data %>% xml_find_all("ArticleIdList/ArticleId[@IdType='doi']") %>% xml_text(),
    pmc = pubmed_data %>% xml_find_all("ArticleIdList/ArticleId[@IdType='pmc']") %>% xml_text(),

    journal_issn = medline_citation %>% xml_find_all(".//ISSN") %>% xml_text(),
    journal_issn_type = medline_citation %>% xml_find_all(".//ISSN") %>% xml_attr("IssnType"),
    pub_year = medline_citation %>% xml_find_all(".//PubDate/Year") %>% xml_integer(),
    pub_month = medline_citation %>% xml_find_all(".//PubDate/Month") %>% xml_text(),
    pub_day = medline_citation %>% xml_find_all(".//PubDate/Day") %>% xml_text(),
    epub_year = medline_citation %>% xml_find_all(".//ArticleDate/Year") %>% xml_integer(),
    epub_month = medline_citation %>% xml_find_all(".//ArticleDate/Month") %>% xml_text(),
    epub_day = medline_citation %>% xml_find_all(".//ArticleDate/Day") %>% xml_text(),
    pub_date_alt = medline_citation %>% xml_find_all(".//PubDate/MedlineDate") %>% xml_text(),
    journal_volume = medline_citation %>% xml_find_all(".//Volume") %>% xml_integer(),
    journal_issue = medline_citation %>% xml_find_all(".//Issue") %>% xml_integer(),
    journal_title = medline_citation %>% xml_find_all(".//Journal/Title") %>% xml_text(),
    journal_iso_abbr = medline_citation %>% xml_find_all(".//Journal/ISOAbbreviation") %>% xml_text(),
    journal_nlm_abbr = medline_citation %>% xml_find_all(".//MedlineJournalInfo/MedlineTA") %>% xml_text(),
    journal_nlm_id = medline_citation %>% xml_find_all(".//MedlineJournalInfo/NlmUniqueID") %>% xml_text(),

    #TODO:check whether could be multiple languages in separate xml
    lang = medline_citation %>% xml_find_all(".//Language") %>% xml_text()
  )


  # Replace missing elements with NA and convert to dataframe
  # out <-
  out %>%
    tidyr::replace_na() %>%
    dplyr::bind_cols()

  # out
}
