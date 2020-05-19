#' Extract summary info about PubMed article set
#'
#' Extract summary info about PubMed article set, containing one or more articles. Extracts only elements which are singular and not more complex elements such as authors. See [MEDLINE PubMed XML Elements](https://www.nlm.nih.gov/bsd/licensee/elements_descriptions.html) for details on elements.
#'
#' @param pubmed_article_set Unparsed or parsed XML of class PubmedArticleSet comprising one or more PubmedArticle. Generally the output of \code{\link{batch_fetch_pubmed_records}}
#' @return Dataframe of summary information about each article in set. One row per article.
#' @export
#' @examples

parse_pubmed_article_set <- function(pubmed_article_set) {

  # Parse xml
  if (typeof(pubmed_article_set) == "character") {
    pubmed_article_set <- read_xml(pubmed_article_set)
  }

  # PubmedArticle (all) as xml_nodeset
  articles <- pubmed_article_set %>% xml_find_all("PubmedArticle")

  # res <- articles %>% map(parse_pubmed_article)
  res <- articles %>% map_dfr(parse_pubmed_article)

  # res <- xpathApply(pubmed_article_set, "/PubmedArticleSet/*", parse_one_pubmed)
  # TODO: may need to change length() to nrows()
  if (length(res) == 1) {
    return(res[[1]])
  }
  # class(res) <- c("multi_pubmed_record", "list")
  # res <- dplyr::bind_rows(res)
  return(res)
}
