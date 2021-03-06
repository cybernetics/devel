% Generated by roxygen2 (4.1.0): do not edit by hand
% Please edit documentation in R/sjStatistics.R
\name{mic}
\alias{mic}
\title{Computes a mean inter-item-correlation.}
\usage{
mic(data, corMethod = "pearson")
}
\arguments{
\item{data}{A correlation object, built with the R-\code{\link{cor}}-function, or a data frame
which correlations should be calculated.}

\item{corMethod}{Indicates the correlation computation method. May be one of
\code{"spearman"} (default), \code{"pearson"} or \code{"kendall"}.}
}
\value{
The value of the computed mean inter-item-correlation.
}
\description{
This function calculates a mean inter-item-correlation, i.e.
               a correlation matrix of \code{data} will be computed (unless
               \code{data} is already a \code{\link{cor}}-object) and the mean
               of all added item's correlation values is returned.
               Requires either a data frame or a computed \code{\link{cor}}-object.
}
\examples{
# -------------------------------
# Data from the EUROFAMCARE sample dataset
# -------------------------------
data(efc)
# recveive first item of COPE-index scale
start <- which(colnames(efc)=="c82cop1")
# recveive last item of COPE-index scale
end <- which(colnames(efc)=="c90cop9")
# create data frame with COPE-index scale
df <- as.data.frame(efc[,c(start:end)])

mic(df)
}
\seealso{
\itemize{
           \item \code{\link{cronb}}
           \item \code{\link{sjt.itemanalysis}}
           \item \code{\link{reliab_test}}
           \item \code{\link{sjp.pca}}
           \item \code{\link{sjt.pca}}
           }
}

