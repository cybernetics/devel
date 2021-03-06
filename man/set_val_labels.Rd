% Generated by roxygen2 (4.1.0): do not edit by hand
% Please edit documentation in R/sjImportSPSS.R
\name{set_val_labels}
\alias{set_val_labels}
\title{Attach value labels to a variable or vector}
\usage{
set_val_labels(x, labels)
}
\arguments{
\item{x}{a variable (vector) or a data frame where labels should be attached. Replaces former value labels.}

\item{labels}{a character vector of labels that will be attached to \code{"x"} by setting
the \code{"value.labels"} attribute. The length of this character vector must equal
the value range of \code{"x"}, i.e. if \code{"x"} has values from 1 to 3,
\code{"labels"} should have a length of 3.
If \code{"x"} is a data frame, \code{labels} may also be a \code{\link{list}} of
character vectors. If \code{labels} is a list, it must have the same length as
number of columns of \code{x}. If \code{labels} is a vector and \code{x} is a data frame,
the \code{labels} will be applied to each column of \code{x}.}
}
\value{
\code{"x"} with attached value labels.
}
\description{
This function attaches character labels as \code{"value.labels"} attribute
               to a variable or vector \code{"x"}, resp. to all variables of a data frame
               if \code{"x"} is a \code{\link{data.frame}}. These value labels will be accessed
               by most of this package's functions, in order to automatically set values
               or legend labels.
}
\note{
With attached value and variable labels, most functions of this package
      automatically detect labels and uses them as axis, legend or title labels
      in plots (\code{sjp.}-functions) respectively as column or row headers
      in table outputs (\code{sjt.}-functions). Use \code{options(autoSetValueLabels = FALSE)}
      and \code{options(autoSetVariableLabels = FALSE)} to turn off automatic
      label detection.
}
\examples{
dummy <- sample(1:4, 40, replace=TRUE)
sjp.frq(dummy)

dummy <- set_val_labels(dummy, c("very low", "low", "mid", "hi"))
sjp.frq(dummy)
}
\seealso{
\itemize{
           \item \href{http://www.strengejacke.de/sjPlot/datainit/}{sjPlot manual: data initialization}
           \item \href{http://www.strengejacke.de/sjPlot/view_spss/}{sjPlot manual: inspecting (SPSS imported) data frames}
           \item \code{\link{read_spss}}
           \item \code{\link{get_var_labels}}
           \item \code{\link{to_label}}
           \item \code{\link{to_value}}
           \item \code{\link{get_val_labels}}
           }
}

