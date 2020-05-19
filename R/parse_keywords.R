#' Extract info about keywords from PubMed article
#'
#' Extract info about "largely non-MeSH subject terms (also referred to as Keywords)" from a single PubMed article. See [MEDLINE PubMed XML Elements](https://www.nlm.nih.gov/bsd/licensee/elements_descriptions.html) for details on elements. See [MEDLINE Elements: Other Terms](https://www.nlm.nih.gov/bsd/mms/medlineelements.html#ot) for details.
#'
#' @param pubmed_article pubmed_article Unparsed or parsed XML of class PubmedArticle. Generally called by \code{\link{parse_pubmed_article_set}} to parse articles within article set.
#' @return Dataframe of information about publication types
#' @export
#' @examples

# OTHER TERMS
# https://www.nlm.nih.gov/bsd/mms/medlineelements.html#ot

parse_keywords <- 1
