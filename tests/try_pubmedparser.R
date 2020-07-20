library(dplyr)
library(xml2)
library(here)
library(devtools)
library(roxygen2)
library(pubmedparser)

my_dois <-
  c("10.3389/fpsyt.2018.00207",
    "10.1186/s40779-018-0166-5",
    "10.1186/s12959-018-0173-5",
    "10.1103/PhysRevD.97.096016",
    "10.1038/d41586-018-05113-0",
    "10.1186/s12888-019-2026-6",
    "10.1016/j.genhosppsych.2017.10.001",
    "10.1097/PSY.0000000000000332",
    "10.1111/jcpe.12441"
  )


article_set <-
  my_dois %>%
  batch_dois() %>%
  create_query_strings() %>%
  batch_fetch_pubmed_records()

write_pubmed_files(article_set, dir  =  here("tests"))

# PubmedArticleSet as xml_document
articleset <-
  read_xml(here("tests", "2020-07-20_pubmeddata_1.txt"))

# PubmedArticle (all) as xml_nodeset
articles <- articleset %>% xml_find_all("PubmedArticle")

# PubmedArticle (first) as node
# article <- articleset %>% xml_find_first("PubmedArticle")
article <- articles[[2]]

single_article <- parse_pubmed_article(article)
multi_article <- parse_pubmed_article_set(articleset)
single_article_databanks <- parse_databanks(article)
