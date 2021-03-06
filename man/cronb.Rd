% Generated by roxygen2 (4.1.0): do not edit by hand
% Please edit documentation in R/sjStatistics.R
\name{cronb}
\alias{cronb}
\title{Calculates Cronbach's Alpha for a matrix}
\usage{
cronb(df)
}
\arguments{
\item{df}{A data frame or matrix with more than 2 columns.}
}
\value{
The Cronbach's alpha value for \code{df}.
}
\description{
This function calculates the Cronbach's alpha value for each column
               of a data frame or matrix.
}
\note{
See examples from \code{\link{sjp.pca}} and \code{\link{sjt.pca}}.
}
\seealso{
\itemize{
           \item \code{\link{reliab_test}}
           \item \code{\link{sjt.itemanalysis}}
           \item \code{\link{sjp.pca}}
           \item \code{\link{sjt.pca}}
           }
}

