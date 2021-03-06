% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/extract_datatype.R
\name{extract_datatype}
\alias{extract_datatype}
\title{Extract specified datatype from PubMed xml into csv}
\usage{
extract_datatype(
  datatype,
  nodes,
  file_name = "pubmed",
  suffix = NULL,
  dir = here::here(),
  quiet = FALSE
)
}
\arguments{
\item{datatype}{Type of data to extract from xml for which there is a corresponding "pubmed_" function ("table", "abstract", "databanks", "authors", "mesh", "keywords", "pubtypes")}

\item{nodes}{Article node set}

\item{file_name}{Root for file names. Defaults to "pubmed".}

\item{suffix}{Suffix for file names. For example, record numbers. Defaults to NULL.}

\item{dir}{Directory for saving files. Defaults to project root (\code{here::here()})}

\item{quiet}{Whether to silence messages in console. Defaults to FALSE.}
}
\description{
Extract specified datatype from PubMed xml into csv
}
