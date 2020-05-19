#' Extract info about publication types from PubMed article
#'
#' Extract info about publication types from a single PubMed article. See [MEDLINE PubMed XML Elements](https://www.nlm.nih.gov/bsd/licensee/elements_descriptions.html) for details on elements. See [PubMed Help: Publication Types](https://www.ncbi.nlm.nih.gov/books/NBK3827/table/pubmedhelp.T.publication_types/) and [2020 MeSH Pubtypes](https://www.nlm.nih.gov/mesh/pubtypes.html) for details.
#'
#' @param pubmed_article pubmed_article Unparsed or parsed XML of class PubmedArticle. Generally called by \code{\link{parse_pubmed_article_set}} to parse articles within article set.
#' @return Dataframe of information about publication types
#' @export
#' @examples

# publication type df: ui, mesh_term

# xml_find_all(pubmed_data_xml, "//PublicationType")

parse_publication_types <- 1
