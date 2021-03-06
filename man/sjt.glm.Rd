% Generated by roxygen2 (4.1.0): do not edit by hand
% Please edit documentation in R/sjTabOdds.R
\name{sjt.glm}
\alias{sjt.glm}
\title{Show (and compare) generalized linear models as HTML table}
\usage{
sjt.glm(..., file = NULL, labelPredictors = NULL,
  labelDependentVariables = NULL, stringPredictors = "Predictors",
  stringDependentVariables = "Dependent Variables",
  showHeaderStrings = FALSE, stringModel = "Model",
  stringIntercept = "(Intercept)", stringObservations = "Observations",
  stringOR = "OR", stringCI = "CI", stringSE = "std. Error",
  stringP = "p", digits.est = 2, digits.p = 3, digits.ci = 2,
  digits.se = 2, digits.summary = 3, exp.coef = TRUE,
  pvaluesAsNumbers = TRUE, boldpvalues = TRUE, showConfInt = TRUE,
  showStdError = FALSE, separateConfColumn = TRUE, newLineConf = TRUE,
  group.pred = TRUE, showAbbrHeadline = TRUE, showPseudoR = TRUE,
  showLogLik = FALSE, showAIC = FALSE, showChi2 = FALSE,
  showFamily = FALSE, cellSpacing = 0.2, cellGroupIndent = 0.6,
  encoding = NULL, CSS = NULL, useViewer = TRUE, no.output = FALSE,
  remove.spaces = TRUE)
}
\arguments{
\item{...}{One or more fitted \code{\link{glm}}-objects.}

\item{file}{The destination file, which will be in html-format. If no filepath is specified,
the file will be saved as temporary file and openend either in the RStudio View pane or
in the default web browser.}

\item{labelPredictors}{Labels of the predictor variables, provided as char vector.}

\item{labelDependentVariables}{Labels of the dependent variables of all fitted models
which have been used as first parameter(s), provided as char vector.}

\item{stringPredictors}{String constant used as headline for the predictor column.
Default is \code{"Predictors"}.}

\item{stringDependentVariables}{String constant used as headline for the
dependent variable columns. Default is \code{"Dependent Variables"}.}

\item{showHeaderStrings}{If \code{TRUE}, the header strings \code{stringPredictors}
and \code{stringDependentVariables} are shown. By default, they're hidden.}

\item{stringModel}{String constant used as headline for the model names in case no
labels for the dependent variables are provided (see labelDependentVariables).
Default is \code{"Model"}.}

\item{stringIntercept}{String constant used as headline for the Intercept row
default is \code{"Intercept"}.}

\item{stringObservations}{String constant used in the summary row for the count of observation
(cases). Default is \code{"Observations"}.}

\item{stringOR}{String used for the column heading of odds ratio values. Default is \code{"OR"}.}

\item{stringCI}{String used for the column heading of confidence interval values. Default is \code{"CI"}.}

\item{stringSE}{String used for the column heading of standard error values. Default is \code{"std. Error"}.}

\item{stringP}{String used for the column heading of p values. Default is \code{"p"}.}

\item{digits.est}{Amount of decimals for estimators.}

\item{digits.p}{Amount of decimals for p-values.}

\item{digits.ci}{Amount of decimals for confidence intervals.}

\item{digits.se}{Amount of decimals for standard error.}

\item{digits.summary}{Amount of decimals for values in model summary.}

\item{exp.coef}{If \code{TRUE} (default), regression coefficients and confidence intervals are exponentiated
(\code{\link{exp}(\link{coef}(fit))}. Use \code{FALSE} if you want the non-exponentiated coefficients
as they are provided by the \code{\link{summary}} function.}

\item{pvaluesAsNumbers}{If \code{TRUE}, p-values are shown as numbers. If \code{FALSE} (default),
p-values are indicated by asterisks.}

\item{boldpvalues}{If \code{TRUE} (default), significant p-values are shown bold faced.}

\item{showConfInt}{If \code{TRUE} (default), the confidence intervall is also printed to the table. Use
\code{FALSE} to omit the CI in the table.}

\item{showStdError}{If \code{TRUE}, the standard errors are also printed.
Default is \code{FALSE}.}

\item{separateConfColumn}{if \code{TRUE}, the CI values are shown in a separate table column.
Default is \code{FALSE}.}

\item{newLineConf}{If \code{TRUE} and \code{separateConfColumn} is \code{FALSE}, inserts a line break
between OR and CI values. If \code{FALSE}, CI values are printed in the same
line with OR values.}

\item{group.pred}{logical, if \code{TRUE} (default), automatically groups table rows with
factor levels of same factor, i.e. predictors of type \code{\link{factor}} will
be grouped, if the factor has more than two levels. Grouping means that a separate headline
row is inserted to the table just before the predictor values.}

\item{showAbbrHeadline}{If \code{TRUE} (default), the table data columns have a headline with
abbreviations for odds ratios, confidence interval and p-values.}

\item{showPseudoR}{If \code{TRUE} (default), the pseudo R2 values for each model are printed
in the model summary. R2cs is the Cox-Snell-pseudo R-square value, R2n is Nagelkerke's
pseudo R-square value.}

\item{showLogLik}{If \code{TRUE}, the Log-Likelihood for each model is printed
in the model summary. Default is \code{FALSE}.}

\item{showAIC}{If \code{TRUE}, the \code{\link{AIC}} value for each model is printed
in the model summary. Default is \code{FALSE}.}

\item{showChi2}{If \code{TRUE}, the chi-square value for each model is printed
in the model summary. Default is \code{FALSE}.}

\item{showFamily}{If \code{TRUE}, the family object and link function for each fitted model
are printed. Can be used in case you want to compare models with different link functions
and same predictors and response, to decide which model fits best. See \code{\link{family}}
for more details. It is recommended to inspect the model \code{\link{AIC}} (see \code{showAIC}) to get a
decision help for which model to choose.}

\item{cellSpacing}{The inner padding of table cells. By default, this value is 0.2 (measure is cm), which is
suitable for viewing the table. Decrease this value (0.05 to 0.1) if you want to import the table
into Office documents. This is a convenient parameter for the \code{CSS} parameter for changing
cell spacing, which would be: \code{CSS=list(css.thead="padding:0.2cm;", css.tzdata="padding:0.2cm;")}.}

\item{cellGroupIndent}{Indent for table rows with grouped factor predictors. Only applies
if \code{group.pred} is \code{TRUE}.}

\item{encoding}{The charset encoding used for variable and value labels. Default is \code{NULL}, so encoding
will be auto-detected depending on your platform (\code{"UTF-8"} for Unix and \code{"Windows-1252"} for
Windows OS). Change encoding if specific chars are not properly displayed (e.g.) German umlauts).}

\item{CSS}{A \code{\link{list}} with user-defined style-sheet-definitions, according to the
\href{http://www.w3.org/Style/CSS/}{official CSS syntax}. See return value \code{page.style} for details
of all style-sheet-classnames that are used in this function. Parameters for this list need:
\enumerate{
  \item the class-names with \code{"css."}-prefix as parameter name and
  \item each style-definition must end with a semicolon
}
You can add style information to the default styles by using a + (plus-sign) as
initial character for the parameter attributes. Examples:
\itemize{
  \item \code{css.table='border:2px solid red;'} for a solid 2-pixel table border in red.
  \item \code{css.summary='font-weight:bold;'} for a bold fontweight in the summary row.
  \item \code{css.lasttablerow='border-bottom: 1px dotted blue;'} for a blue dotted border of the last table row.
  \item \code{css.colnames='+color:green'} to add green color formatting to column names.
}
See further examples below and \href{http://www.strengejacke.de/sjPlot/sjtbasics}{sjPlot manual: sjt-basics}.}

\item{useViewer}{If \code{TRUE}, the function tries to show the HTML table in the IDE's viewer pane. If
\code{FALSE} or no viewer available, the HTML table is opened in a web browser.}

\item{no.output}{If \code{TRUE}, the html-output is neither opened in a browser nor shown in
the viewer pane and not even saved to file. This option is useful when the html output
should be used in \code{knitr} documents. The html output can be accessed via the return
value.}

\item{remove.spaces}{logical, if \code{TRUE}, leading spaces are removed from all lines in the final string
that contains the html-data. Use this, if you want to remove parantheses for html-tags. The html-source
may look less pretty, but it may help when exporting html-tables to office tools.}
}
\value{
Invisibly returns a \code{\link{structure}} with
         \itemize{
           \item the web page style sheet (\code{page.style}),
           \item the web page content (\code{page.content}),
           \item the complete html-output (\code{output.complete}) and
           \item the html-table with inline-css for use with knitr (\code{knitr})
           }
           for further use.
}
\description{
Shows (and compares multiple) generalized linear models (Odds Ratios)
               as HTML table, or saves them as file. The fitted glm's should have the same predictor variables and
               either
               \itemize{
               \item differ only in their response (dependent variable), to see the effect of a specific set of predictors on different responses, or
               \item all have the same reponse variables, but differ in their \code{\link{family}} objects and link function in order to see which model fits best to the data.
               }
               See parameter \code{showFamily} for details and section \code{examples}.
}
\note{
The HTML tables can either be saved as file and manually opened (specify parameter \code{file}) or
        they can be saved as temporary files and will be displayed in the RStudio Viewer pane (if working with RStudio)
        or opened with the default web browser. Displaying resp. opening a temporary file is the
        default behaviour (i.e. \code{file=NULL}).
}
\examples{
# prepare dummy variables for binary logistic regression
y1 <- ifelse(swiss$Fertility < median(swiss$Fertility), 0, 1)
y2 <- ifelse(swiss$Infant.Mortality < median(swiss$Infant.Mortality), 0, 1)
y3 <- ifelse(swiss$Agriculture < median(swiss$Agriculture), 0, 1)

# Now fit the models. Note that both models share the same predictors
# and only differ in their dependent variable (y1, y2 and y3)
fitOR1 <- glm(y1 ~ swiss$Education + swiss$Examination+swiss$Catholic,
              family = binomial(link = "logit"))
fitOR2 <- glm(y2 ~ swiss$Education + swiss$Examination+swiss$Catholic,
              family = binomial(link = "logit"))
fitOR3 <- glm(y3 ~ swiss$Education + swiss$Examination+swiss$Catholic,
              family = binomial(link = "logit"))

# open HTML-table in RStudio Viewer Pane or web browser
\dontrun{
sjt.glm(fitOR1,
        fitOR2,
        labelDependentVariables = c("Fertility",
                                    "Infant Mortality"),
        labelPredictors = c("Education",
                            "Examination",
                            "Catholic"))

# open HTML-table in RStudio Viewer Pane or web browser,
# table indicating p-values as stars
sjt.glm(fitOR1,
        fitOR2,
        labelDependentVariables = c("Fertility",
                                    "Infant Mortality"),
        labelPredictors = c("Education", "Examination", "Catholic"),
        pvaluesAsNumbers = FALSE)

# open HTML-table in RStudio Viewer Pane or web browser,
# integrate CI in OR column
sjt.glm(fitOR1, fitOR2, fitOR3,
        labelDependentVariables = c("Fertility",
                                    "Infant Mortality",
                                    "Agriculture"),
        labelPredictors = c("Education", "Examination", "Catholic"),
        separateConfColumn = FALSE)

# open HTML-table in RStudio Viewer Pane or web browser,
# indicating p-values as numbers and printing CI in a separate column
sjt.glm(fitOR1, fitOR2, fitOR3,
        labelDependentVariables = c("Fertility",
                                    "Infant Mortality",
                                    "Agriculture"),
        labelPredictors = c("Education", "Examination", "Catholic"))

# open HTML-table in RStudio Viewer Pane or web browser,
# indicating p-values as stars and integrate CI in OR column
sjt.glm(fitOR1, fitOR2, fitOR3,
        labelDependentVariables = c("Fertility",
                                    "Infant Mortality",
                                    "Agriculture"),
        labelPredictors = c("Education",
                            "Examination",
                            "Catholic"),
        pvaluesAsNumbers = FALSE,
        separateConfColumn = FALSE)

# ----------------------------------------------------------------
# User defined style sheet
# ----------------------------------------------------------------
sjt.glm(fitOR1, fitOR2, fitOR3,
        labelDependentVariables=c("Fertility", "Infant Mortality", "Agriculture"),
        labelPredictors=c("Education", "Examination", "Catholic"),
        CSS=list(css.table="border: 2px solid;",
                 css.tdata="border: 1px solid;",
                 css.depvarhead="color:#003399;"))

# ----------------------------------------------------------------
# Compare models with different link functions, but same
# predictors and response
# ----------------------------------------------------------------
# load efc sample data
data(efc)
# dichtomozize service usage by "service usage yes/no"
efc$services <- dicho(efc$tot_sc_e, "v", 0, asNum = TRUE)
# fit 3 models with different link-functions
fit1 <- glm(services ~ neg_c_7 + c161sex + e42dep, data=efc, family=binomial(link="logit"))
fit2 <- glm(services ~ neg_c_7 + c161sex + e42dep, data=efc, family=binomial(link="probit"))
fit3 <- glm(services ~ neg_c_7 + c161sex + e42dep, data=efc, family=poisson(link="log"))
# compare models
sjt.glm(fit1, fit2, fit3, showAIC=TRUE, showFamily=TRUE, showPseudoR=FALSE)}
}
\seealso{
\itemize{
           \item \code{\link{sjt.lm}}
           \item \code{\link{sjp.glm}}
           }
}

