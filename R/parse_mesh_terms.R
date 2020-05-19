#' Extract info about MeSH terms from PubMed article
#'
#' Extract info about "largely non-MeSH subject terms (also referred to as Keywords)" from a single PubMed article. See [MEDLINE PubMed XML Elements](https://www.nlm.nih.gov/bsd/licensee/elements_descriptions.html) for details on elements. See [MEDLINE Elements: MeSH Terms](https://www.nlm.nih.gov/bsd/mms/medlineelements.html#mh) and [MeSH home page](http://www.nlm.nih.gov/mesh/meshhome.html) for details.
#'
#' @param pubmed_article pubmed_article Unparsed or parsed XML of class PubmedArticle. Generally called by \code{\link{parse_pubmed_article_set}} to parse articles within article set.
#' @return Dataframe of information about publication types
#' @export
#' @examples

parse_mesh_terms <- 1
