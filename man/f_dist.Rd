% Generated by roxygen2 (4.1.0): do not edit by hand
% Please edit documentation in R/sjPlotDist.R
\name{f_dist}
\alias{f_dist}
\title{Plot F distributions}
\usage{
f_dist(f = NULL, deg.f1 = NULL, deg.f2 = NULL, p = NULL, xmax = NULL,
  geom.colors = NULL, geom.alpha = 0.7)
}
\arguments{
\item{f}{numeric, optional. If specified, an F distribution with \code{deg.f1} and \code{deg.f2} degrees
of freedom is plotted and a shaded area at \code{f} value position is plotted that
indicates whether or not the specified value is significant or not.
If both \code{f} and \code{p} are not specified, a distribution without shaded
area is plotted.}

\item{deg.f1}{numeric. The first degrees of freedom for the F distribution. Needs to
be specified.}

\item{deg.f2}{numeric. The second degrees of freedom for the F distribution. Needs to
be specified.}

\item{p}{numeric, optional. If specified, a F distribution with \code{deg.f1} and \code{deg.f2} degrees
of freedom is plotted and a shaded area at the position where the specified p-level
starts is plotted. If both \code{f} and \code{p} are not specified, a distribution
without shaded area is plotted.}

\item{xmax}{numeric, optional. Specifies the maximum x-axis-value. If not specified, the x-axis
ranges to a value where a p-level of 0.00001 is reached.}

\item{geom.colors}{User defined color palette for shaded areas. If specified, must either be vector with color values
of same length as groups defined in \code{x}, or a specific color palette code (see below).
\itemize{
  \item If not specified, the qualitative \code{"Paired"} color brewer palette will be used.
  \item If \code{"gs"}, a greyscale will be used.
  \item If \code{geom.colors} is any valid color brewer palette name, the related \href{http://colorbrewer2.org}{color brewer} palette will be used. Use \code{display.brewer.all()} from the \code{RColorBrewer} package to view all available palette names.
}
Else specify your own color values as vector (e.g. \code{geom.colors=c("#f00000", "#00ff00")}).}

\item{geom.alpha}{specified the alpha-level of the shaded area. Default is 0.7, range between 0 to 1.}
}
\description{
This function plots a simple F distribution or an F distribution
               with shaded areas that indicate at which F value a significant p-level
               is reached.
}
\examples{
# a simple F distribution for 6 and 45 degrees of freedom
f_dist(deg.f1 = 6, deg.f2 = 45)

# F distribution for 6 and 45 degrees of freedom,
# and a shaded area starting at F value of two.
# F-values equal or greater than 2.31 are "significant"
f_dist(f = 2, deg.f1 = 6, deg.f2 = 45)

# F distribution for 6 and 45 degrees of freedom,
# and a shaded area starting at a p-level of 0.2
# (F-Value about 1.5).
f_dist(p = 0.2, deg.f1 = 6, deg.f2 = 45)
}

