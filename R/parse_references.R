#' Extract info about references from PubMed article
#'
#' Extract info about references from a single PubMed article. See [MEDLINE PubMed XML Elements](https://www.nlm.nih.gov/bsd/licensee/elements_descriptions.html) for details on elements.
#'
#' @param pubmed_article pubmed_article Unparsed or parsed XML of class PubmedArticle. Generally called by \code{\link{parse_pubmed_article_set}} to parse articles within article set.
#' @return Dataframe of information about references.
#' @export

parse_references <- 1
