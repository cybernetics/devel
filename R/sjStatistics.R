# bind global variables
if(getRversion() >= "2.15.1") utils::globalVariables(c("fit"))


#' @title Retrieve eta squared of fitted anova
#' @name eta_sq
#' @description Returns the eta squared value for 1-way-anovas.
#' 
#' @seealso \code{\link{sjp.aov1}}
#'         
#' @param ... A fitted one-way-anova model or a dependent and grouping variable (see examples).
#' @return The eta squared value.
#' 
#' @note Interpret eta^2 as for r2 or R2; a rule of thumb (Cohen):
#'         \itemize{
#'          \item .02 ~ small
#'          \item .13 ~ medium
#'          \item .26 ~ large
#'         }
#' 
#' @references \itemize{
#'               \item \href{http://stats.stackexchange.com/questions/78808/}{stack exchange 1}
#'               \item \href{http://stats.stackexchange.com/questions/15958/}{stack exchange 2}
#'               \item \href{http://en.wikiversity.org/wiki/Eta-squared}{Wikipedia: Eta-squared}
#'               \item Levine TR, Hullett CR (2002): Eta Squared, Partial Eta Squared, and Misreporting of Effect Size in Communication Research (\href{https://www.msu.edu/~levinet/eta\%20squared\%20hcr.pdf}{pdf})
#'             }
#' 
#' @examples
#' # load sample data
#' data(efc)
#' 
#' # fit linear model
#' fit <- aov(c12hour ~ as.factor(e42dep), data = efc)
#' 
#' # print eta sqaured
#' eta_sq(fit)
#' 
#' # grouping variable will be converted to factor autoamtically
#' eta_sq(efc$c12hour, efc$e42dep)
#' 
#' @export
eta_sq <- function(...) {
  # --------------------------------------------------------
  # retrieve list of parameters
  # --------------------------------------------------------
  input_list <- list(...)
  # --------------------------------------------------------
  # check if fitted anova
  # --------------------------------------------------------
  if (length(input_list) == 1 && any(class(input_list[[1]]) == "aov")) {
    # retrieve model
    fit <- input_list[[1]]
  }
  else if (length(input_list) == 2) {
    # retrieve variables
    depVar <- input_list[[1]]
    grpVar <- input_list[[2]]
    # convert to factor
    if (!is.factor(grpVar)) {
      grpVar <- as.factor(grpVar)
    }
    # fit anova
    fit  <- aov(depVar ~ grpVar)
  }
  # return eta squared
  return (summary.lm(fit)$r.squared)
  # return (1 - var(fit$residuals, na.rm = T) / var(fit$model[,1], na.rm = T))
}


#' @title Retrieve std. beta coefficients and ci of lm and mixed models
#' @name std_beta
#' @description Returns the standardized beta coefficients and confidence intervals 
#'                of a fitted linear (mixed) models, i.e. \code{fit} must either
#'                be of class \code{lm} or \code{lmerMod} (lme4-package).
#' 
#' @seealso \itemize{
#'            \item \code{\link{sjp.lm}}
#'            \item \code{\link{sjt.lm}}
#'            }
#'         
#' @param fit A fitted linear (mixed) model of class \code{lm} or \code{lmerMod} (lme4-package).
#' @param include.ci logical, if \code{TRUE}, a data frame with confidence intervals will be returned,
#'          when \code{fit} is of class \code{lm}. If \code{fit} is a \code{lmerMod} object (lme4-package),
#'          always returns standard error instead of confidence intervals (hence, this paramezer will
#'          be ignored when \code{fit} is a \code{lmerMod} object).
#' @return A vector with standardiized beta coefficients of the fitted linear model, or a data frame
#'           with standardized confidence intervals, if \code{include.ci = TRUE}.
#' 
#' @note "Standardized coefficients refer to how many standard deviations a dependent variable will change, 
#'         per standard deviation increase in the predictor variable. Standardization of the coefficient is 
#'         usually done to answer the question of which of the independent variables have a greater effect 
#'         on the dependent variable in a multiple regression analysis, when the variables are measured 
#'         in different units of measurement (for example, income measured in dollars and family size 
#'         measured in number of individuals)." (Source: Wikipedia)
#' 
#' @references \href{http://en.wikipedia.org/wiki/Standardized_coefficient}{Wikipedia: Standardized coefficient}
#' 
#' @examples
#' # fit linear model
#' fit <- lm(airquality$Ozone ~ airquality$Wind + airquality$Temp + airquality$Solar.R)
#' # print std. beta coefficients
#' std_beta(fit)
#' 
#' # print std. beta coefficients and ci
#' std_beta(fit, include.ci = TRUE)
#' 
#' @export
std_beta <- function(fit, include.ci = FALSE) {
  if (class(fit) == "lmerMod") {
    return (sjs.stdmm(fit))
  }
  else {
    b <- summary(fit)$coef[-1, 1]
    sx <- sapply(fit$model[-1], sd)
    sy <- sapply(fit$model[1], sd)
    beta <- b * sx/sy
    se <- summary(fit)$coefficients[-1, 2]
    beta.se <- se * sx/sy
    
    if (include.ci) {
      return (data.frame(beta = beta, ci.low = (beta - beta.se * 1.96), ci.hi = (beta + beta.se * 1.96)))
    }
    else {
      return(beta)
    }
  }
}


sjs.stdmm <- function(fit) {
  # code from Ben Bolker, see
  # http://stackoverflow.com/a/26206119/2094622
  # ------------------------
  # check if suggested package is available
  # ------------------------
  if (!requireNamespace("lme4", quietly = TRUE)) {
    stop("Package 'lme4' needed for this function to work. Please install it.", call. = FALSE)
  }
  sdy <- sd(lme4::getME(fit,"y"))
  sdx <- apply(lme4::getME(fit,"X"), 2, sd)
  sc <- lme4::fixef(fit)*sdx/sdy
  se.fixef <- coef(summary(fit))[,"Std. Error"]
  se <- se.fixef*sdx/sdy
  mydf <- data.frame(stdcoef=sc, stdse=se)
  rownames(mydf) <- names(lme4::fixef(fit))
  return(mydf)
}


#' @title Performs a Mann-Whitney-U-Test
#' @name mwu
#' @description This function performs a Mann-Whitney-U-Test (or \code{Wilcoxon rank sum test},
#'                see \code{\link{wilcox.test}} and \code{wilcox_test} (\code{coin}-package)) for the variable \code{var}, which is
#'                divided into groups indicated by \code{grp} (so the formula \code{var ~ grp}
#'                is used). If \code{grp} has more than two categories, a comparison between each 
#'                two groups is performed. \cr \cr 
#'                The function reports U, p and Z-values as well as effect size r 
#'                and group-rank-means.
#' 
#' @param var A numeric vector / variable, where the Mann-Whitney-U-Test should be applied to.
#' @param grp The grouping variable indicating the groups that should be used for comparison.
#' @param distribution indicates how the null distribution of the test statistic should be computed. Mey be one of
#'          \code{exact}, \code{approximate} or \code{asymptotic} (default).
#'          See \code{wilcox_test} (\code{coin}-package) for details.
#' @param weights defining integer valued weights for the observations. By default,
#'          this is \code{NULL}.
#' @return (Invisibly) returns a data frame with U, p and Z-values for each group-comparison
#'         as well as effect-size r.
#' 
#' @note This function calls the \code{wilcox_test} (from the coin package) with formula. If \code{grp}
#'         has more than two groups, additionally a Kruskal-Wallis-Test (see \code{\link{kruskal.test}})
#'         is performed. \cr \cr
#'         Interpretation of effect sizes:
#'         \itemize{
#'          \item small effect >= 0.1
#'          \item medium effect >= 0.3
#'          \item large effect >= 0.5
#'        }
#' 
#' @seealso \code{\link{chisq_gof}}, \code{\link{levene_test}}, 
#'          \code{\link{wilcox.test}}, \code{\link{ks.test}}, 
#'          \code{\link{kruskal.test}}, \code{\link{t.test}}, 
#'          \code{\link{chisq.test}} and \code{\link{fisher.test}}
#' 
#' @examples
#' \dontrun{
#' data(efc)
#' # Mann-Whitney-U-Tests for elder's age by elder's dependency.
#' mwu(efc$e17age, efc$e42dep)}
#' 
#' @export
mwu <- function(var, grp, distribution="asymptotic", weights=NULL) {
  # ------------------------
  # check if suggested package is available
  # ------------------------
  if (!requireNamespace("coin", quietly = TRUE)) {
    stop("Package 'coin' needed for this function to work. Please install it.", call. = FALSE)
  }
  if (min(grp, na.rm=TRUE)==0) {
    grp <- grp+1
  }
  cnt <- length(unique(na.omit(grp)))
  labels <- autoSetValueLabels(grp)
  message("Performing Mann-Whitney-U-Test...")
  message("---------------------------------")
  message("showing statistics between groups (x|y)")
  df <- data.frame()
  for (i in 1:cnt) {
    for (j in i:cnt) {
      if (i!=j) {
        # retrieve cases (rows) of subgroups
        xsub <- var[which(grp==i | grp==j)]
        ysub <- grp[which(grp==i | grp==j)]
        # only use rows with non-missings
        ysub <- ysub[which(!is.na(xsub))]
        # adjust weights, pick rows from subgroups (see above)
        if (!is.null(weights)) {
          wsub <- as.integer(na.omit(weights[which(!is.na(xsub))]))
        }
        xsub <- as.numeric(na.omit(xsub))
        ysub.n <- na.omit(ysub)
        ysub <- as.factor(ysub.n)
        if (is.null(weights)) {
          wt <- coin::wilcox_test(xsub ~ ysub, distribution=distribution)
        }
        else {
          wt <- coin::wilcox_test(xsub ~ ysub, distribution=distribution, weights=as.formula("~wsub"))
        }
        u <- as.numeric(coin::statistic(wt, type="linear"))
        z <- as.numeric(coin::statistic(wt, type="standardized"))
        p <- coin::pvalue(wt)
        r <- abs(z / sqrt(length(var)))
        w <- wilcox.test(xsub, ysub.n, paired = TRUE)$statistic
        rkm.i <- mean(rank(xsub)[which(ysub.n==i)], na.rm=TRUE)
        rkm.j <- mean(rank(xsub)[which(ysub.n==j)], na.rm=TRUE)
        if (is.null(labels)) {
          cat(sprintf("Groups (%i|%i), n = %i/%i:\n", i, j, length(xsub[which(ysub.n==i)]), length(xsub[which(ysub.n==j)])))
        }
        else {
          cat(sprintf("Groups %i = %s (n = %i) | %i = %s (n = %i):\n", i, labels[i], length(xsub[which(ysub.n==i)]), j, labels[j], length(xsub[which(ysub.n==j)])))
        }
        if (p < 0.001) {
          p  <- 0.001
          p.string <- "<"
        }
        else {
          p.string <- "="
        }
        cat(sprintf("  U = %.3f, W = %.3f, p %s %.3f, Z = %.3f\n  effect-size r = %.3f\n  rank-mean(%i) = %.2f\n  rank-mean(%i) = %.2f\n\n", u, w, p.string, p, z, r, i, rkm.i, j, rkm.j))
        df <- rbind(df, cbind(grp1=i, grp2=j, u=u, w=w, p=p, z=z, r=r, rank.mean.grp1=rkm.i, rank.mean.grp2=rkm.j))
      }
    }
  }
  # if we have more than 2 groups, also perfom kruskal-wallis-test
  if (cnt>2) {
    message("Performing Kruskal-Wallis-Test...")
    message("---------------------------------")
    kw <- kruskal.test(var, grp)
    cat(sprintf("chi-squared = %.3f\n", kw$statistic))
    cat(sprintf("df = %i\n", kw$parameter))
    if (kw$p.value < 0.001) {
      p  <- 0.001
      p.string <- "<"
    }
    else {
      p <- kw$p.value
      p.string <- "="
    }
    cat(sprintf("p %s %.3f\n", p.string, p))
  }
  invisible(df)
}


#' @title Performs a Chi-square goodness-of-fit-test
#' @name chisq_gof
#'
#' @param var a numeric vector / variable.
#' @param prob a vector of probabilities (indicating the population probabilities) of the same length 
#'          as \code{var}'s amount of categories / factor levels. Use \code{nrow(table(var))} to
#'          determine the amount of necessary values for \code{prob}.
#' @param weights a vector with weights, used to weight \code{var}.
#' @return (insisibly) returns the object of the computed \code{\link{chisq.test}}.
#' 
#' @note This function is a convenient function for \code{\link{chisq.test}}, performing goodness-of-fit test.
#' 
#' @seealso \code{\link{mwu}}, \code{\link{levene_test}}, \code{\link{wilcox.test}}, 
#'          \code{\link{ks.test}}, \code{\link{kruskal.test}}, \code{\link{t.test}}, 
#'          \code{\link{chisq.test}}, \code{\link{fisher.test}}, \code{\link{ks.test}}
#' 
#' @examples
#' data(efc)
#' # differing from population
#' chisq_gof(efc$e42dep, c(0.3,0.2,0.22,0.28))
#' # equal to population
#' chisq_gof(efc$e42dep, prop.table(table(efc$e42dep)))
#' 
#' @export
chisq_gof <- function(var, prob, weights=NULL) {
  # performs a Chi-square goodnes-of-fit-test
  if (!is.null(weights)) var <- weight(var, weights)
  dummy <- as.vector(table(var))
  chi2gof <- chisq.test(dummy, p=prob)
  print(chi2gof)
  invisible (chi2gof)
}


#' @title Calculates Cronbach's Alpha for a matrix
#' @name cronb
#' @description This function calculates the Cronbach's alpha value for each column
#'                of a data frame or matrix.
#'
#' @seealso \itemize{
#'            \item \code{\link{reliab_test}}
#'            \item \code{\link{sjt.itemanalysis}}
#'            \item \code{\link{sjp.pca}}
#'            \item \code{\link{sjt.pca}}
#'            }
#'
#' @param df A data frame or matrix with more than 2 columns.
#' @return The Cronbach's alpha value for \code{df}.
#' 
#' @note See examples from \code{\link{sjp.pca}} and \code{\link{sjt.pca}}.
#' 
#' @export
cronb <- function(df) { # df must be matrix or data.frame with more than 2 columns
  df <- na.omit(df)
  if (is.null(ncol(df)) || ncol(df)<2) {
    cat("\nToo less columns in this factor to calculate alpha value!\n")
    return(0)
  }
  return (dim(df)[2]/(dim(df)[2]-1)*(1-sum(apply(df,2,var))/var(rowSums(df))))
}    


#' @title Performs a reliability test on an item scale.
#' @name reliab_test
#' @description This function calculates the item discriminations (corrected item-total 
#'                correlations for each item of \code{df} with the remaining items) and
#'                the Cronbach's alpha for each item, if it was deleted from the 
#'                scale.
#'
#' @seealso \itemize{
#'            \item \code{\link{cronb}}
#'            \item \code{\link{sjt.itemanalysis}}
#'            \item \code{\link{mic}}
#'            \item \code{\link{sjp.pca}}
#'            \item \code{\link{sjt.pca}}
#'            \item \code{\link{sjt.df}}
#'            }
#'          
#' @param df A data frame with items (from a scale)
#' @param scaleItems If \code{TRUE}, the data frame's vectors will be scaled. Recommended,
#'          when the variables have different measures / scales.
#' @param digits Amount of digits for Cronbach's Alpha and correlation values in
#'          returned data frame.
#' @return A data frame with the corrected item-total correlations (item discrimination)
#'           and Cronbach's alpha (if item deleted) for each item of the scale, or
#'           \code{NULL} if data frame had too less columns.
#' 
#' @note This function is similar to a basic reliability test in SPSS. The correlations in
#'         the Item-Total-Statistic are a computed correlation of each item against the sum
#'         of the remaining items (which are thus treated as one item).
#' 
#' @examples
#' # -------------------------------
#' # Data from the EUROFAMCARE sample dataset
#' # -------------------------------
#' data(efc)
#' 
#' # retrieve variable and value labels
#' varlabs <- get_var_labels(efc)
#' 
#' # recveive first item of COPE-index scale
#' start <- which(colnames(efc) == "c82cop1")
#' # recveive last item of COPE-index scale
#' end <- which(colnames(efc) == "c90cop9")
#'  
#' # create data frame with COPE-index scale
#' df <- as.data.frame(efc[, c(start:end)])
#' colnames(df) <- varlabs[c(start:end)]
#' 
#' \dontrun{
#' sjt.df(reliab_test(df), 
#'        describe = FALSE,
#'        showCommentRow = TRUE, 
#'        commentString = sprintf("Cronbach's &alpha;=%.2f", 
#'                                cronb(df)))}
#' 
#' # ---------------------------------------
#' # Compute PCA on Cope-Index, and perform a
#' # reliability check on each extracted factor.
#' # ---------------------------------------
#' \dontrun{
#' factors <- sjt.pca(df)$factor.index
#' findex <- sort(unique(factors))
#' for (i in 1:length(findex)) {
#'  rel.df <- subset(df, select = which(factors == findex[i]))
#'  if (ncol(rel.df) >= 3) {
#'    sjt.df(reliab_test(rel.df),
#'           describe = FALSE,
#'           showCommentRow = TRUE,
#'           useViewer = FALSE,
#'           title = "Item-Total-Statistic",
#'           commentString = sprintf("Scale's overall Cronbach's &alpha;=%.2f", 
#'                                   cronb(rel.df)))
#'    }
#'  }}
#'  
#' @export
reliab_test <- function(df, scaleItems=FALSE, digits=3) {
  # -----------------------------------
  # remove missings, so correlation works
  # -----------------------------------
  df <- na.omit(df)
  # -----------------------------------
  # remember item (column) names for return value
  # return value gets column names of initial data frame
  # -----------------------------------
  df.names <- colnames(df)
  # -----------------------------------
  # check for minimum amount of columns
  # can't be less than 3, because the reliability
  # test checks for Cronbach's alpha if a specific
  # item is deleted. If data frame has only two columns
  # and one is deleted, Cronbach's alpha cannot be calculated.
  # -----------------------------------
  if (ncol(df)>2) {
    # -----------------------------------
    # Check whether items should be scaled. Needed,
    # when items have different measures / scales
    # -----------------------------------
    if (scaleItems) {
      df <- data.frame(scale(df, center=TRUE, scale=TRUE))
    }
    # -----------------------------------
    # init vars
    # -----------------------------------
    totalCorr <- c()
    cronbachDeleted <- c()
    # -----------------------------------
    # iterate all items
    # -----------------------------------
    for (i in 1:ncol(df)) {
      # -----------------------------------
      # create subset with all items except current one
      # (current item "deleted")
      # -----------------------------------
      sub.df <- subset(df, select=c(-i))
      # -----------------------------------
      # calculate cronbach-if-deleted
      # -----------------------------------
      cronbachDeleted <- c(cronbachDeleted, cronb(sub.df))
      # -----------------------------------
      # calculate corrected total-item correlation
      # -----------------------------------
      totalCorr <- c(totalCorr, cor(df[,i], apply(sub.df, 1, sum), use="pairwise.complete.obs"))
    }
    # -----------------------------------
    # create return value
    # -----------------------------------
    ret.df <- data.frame(cbind(round(cronbachDeleted,digits), round(totalCorr,digits)))
    # -----------------------------------
    # set names of data frame
    # -----------------------------------
    colnames(ret.df) <- c("Cronbach's &alpha; if item deleted", "Item discrimination")
    rownames(ret.df) <- df.names
  }
  else {
    warning("Data frame needs at least three columns for reliability-test!")
    ret.df <- NULL
  }
  # -----------------------------------
  return(ret.df)
}


#' @title Computes a mean inter-item-correlation.
#' @name mic
#' @description This function calculates a mean inter-item-correlation, i.e.
#'                a correlation matrix of \code{data} will be computed (unless
#'                \code{data} is already a \code{\link{cor}}-object) and the mean
#'                of all added item's correlation values is returned.
#'                Requires either a data frame or a computed \code{\link{cor}}-object.
#'
#' @seealso \itemize{
#'            \item \code{\link{cronb}}
#'            \item \code{\link{sjt.itemanalysis}}
#'            \item \code{\link{reliab_test}}
#'            \item \code{\link{sjp.pca}}
#'            \item \code{\link{sjt.pca}}
#'            }
#'          
#' @param data A correlation object, built with the R-\code{\link{cor}}-function, or a data frame
#'          which correlations should be calculated.
#' @param corMethod Indicates the correlation computation method. May be one of
#'          \code{"spearman"} (default), \code{"pearson"} or \code{"kendall"}.
#' @return The value of the computed mean inter-item-correlation.
#' 
#' @examples
#' # -------------------------------
#' # Data from the EUROFAMCARE sample dataset
#' # -------------------------------
#' data(efc)
#' # recveive first item of COPE-index scale
#' start <- which(colnames(efc)=="c82cop1")
#' # recveive last item of COPE-index scale
#' end <- which(colnames(efc)=="c90cop9")
#' # create data frame with COPE-index scale
#' df <- as.data.frame(efc[,c(start:end)])
#' 
#' mic(df)
#' @export
mic <- function(data, corMethod="pearson") {
  # -----------------------------------
  # Mean-interitem-corelation
  # -----------------------------------
  if (class(data)=="matrix") {
    corr <- data
  }
  else {
    data <- na.omit(data)
    corr <- cor(data, method=corMethod)
  }
  # -----------------------------------
  # Sum up all correlation values
  # -----------------------------------
  mic <- c()
  for (j in 1:(ncol(corr)-1)) {
    # first correlation is always "1" (self-correlation)
    for (i in (j+1):nrow(corr)) {
      # check four valid bound
      if (i<=nrow(corr) && j<=ncol(corr)) {
        # add up all subsequent values
        mic <- c(mic, corr[i,j])
      }
      else {
        mic <- c(mic, "NA")
      }
    }
  }
  return (mean(mic))
}


#' @title Compute expected and relative table values
#' @name table_values
#' @description This function calculates a table's cell, row and column percentages as
#'                well as expected values and returns all results as lists of tables.
#'
#' @seealso \code{\link{phi}} \cr
#'          \code{\link{cramer}}
#'
#' @param tab A simple \code{\link{table}} or \code{\link{ftable}} of which cell, row and column percentages 
#'          as well as expected values are calculated. Tables of class \code{\link{xtabs}} and other will
#'          be coerced to \code{\link{ftable}} objects.
#' @param digits The amount of digits for the table percentage values.
#' @return (invisibly) returns a list with four tables:
#'         \enumerate{
#'          \item \code{cell} a table with cell percentages of \code{tab}
#'          \item \code{row} a table with row percentages of \code{tab}
#'          \item \code{col} a table with column percentages of \code{tab}
#'          \item \code{expected} a table with expected values of \code{tab}
#'         }
#' 
#' @examples
#' tab <- table(sample(1:2, 30, TRUE), sample(1:3, 30, TRUE))
#' # show expected values
#' table_values(tab)$expected
#' # show cell percentages
#' table_values(tab)$cell
#' 
#' @export
table_values <- function(tab, digits=2) {
  if (class(tab)!="ftable") tab <- ftable(tab)
  tab.cell <- round(100*prop.table(tab),digits)
  tab.row <- round(100*prop.table(tab,1),digits)
  tab.col <- round(100*prop.table(tab,2),digits)
  tab.expected <- as.table(round(as.array(margin.table(tab,1)) %*% t(as.array(margin.table(tab,2))) / margin.table(tab)))
  # -------------------------------------
  # return results
  # -------------------------------------
  invisible (structure(class = "sjutablevalues",
                       list(cell = tab.cell,
                            row = tab.row,
                            col = tab.col,
                            expected = tab.expected)))
}


#' @title Phi value for a contingency table
#' @name phi
#' @description Compute Phi value for a contingency table.
#'
#' @seealso \code{\link{table_values}} \cr
#'          \code{\link{cramer}}
#'
#' @param tab A simple \code{\link{table}} or \code{\link{ftable}}. Tables of class 
#'          \code{\link{xtabs}} and other will be coerced to \code{\link{ftable}} objects.
#' @return The table's Phi value.
#' 
#' @examples
#' tab <- table(sample(1:2, 30, TRUE), sample(1:2, 30, TRUE))
#' phi(tab)
#' 
#' @export
phi <- function(tab) {
  if (class(tab)!="ftable") tab <- ftable(tab)
  tb <- summary(loglm(~1+2, tab))$tests
  phi_val <- sqrt(tb[2,1]/sum(tab))
  return (phi_val)
}


#' @title Cramer's V for a contingency table
#' @name cramer
#' @description Compute Cramer's V for a table with more than 2x2 fields.
#'
#' @seealso \code{\link{table_values}} \cr
#'          \code{\link{phi}}
#'
#' @param tab A simple \code{\link{table}} or \code{\link{ftable}}. Tables of class 
#'          \code{\link{xtabs}} and other will be coerced to \code{\link{ftable}} objects.
#' @return The table's Cramer's V.
#' 
#' @examples
#' tab <- table(sample(1:2, 30, TRUE), sample(1:3, 30, TRUE))
#' cramer(tab)
#' 
#' @export
cramer <- function(tab) {
  if (class(tab)!="ftable") tab <- ftable(tab)
  phi_val <- phi(tab)
  cramer <- sqrt(phi_val^2/min(dim(tab)-1))
  return (cramer)
}


#' @title Compute standard error for variables
#' @name std_e
#' @description Compute standard error for variables
#'
#' @param x a (numeric) vector / variable.
#' @return The standard error of variable \code{x}.
#' 
#' @examples
#' std_e(rnorm(n = 100, mean = 3))
#' 
#' @export
std_e <- function(x) sqrt(var(x, na.rm = TRUE) / length(na.omit(x)))

sjs.frqci <- function(x) {
  ft <- as.numeric(unname(table(x)))
  n <- sum(ft, na.rm = T)
  rel_frq <- as.numeric(ft/n)
  ci <- 1.96 * sqrt(rel_frq * (1 - rel_frq)/n)
  ci.u <- n * (rel_frq + ci)
  ci.l <- n * (rel_frq - ci)
  rel.ci.u <- rel_frq + ci
  rel.ci.l <- rel_frq - ci
  mydat.frq <- data.frame(frq = ft, lower.ci = ci.l, upper.ci = ci.u)
  mydat.rel <- data.frame(rel.frq = rel_frq, rel.lower.ci = rel.ci.l, rel.upper.ci = rel.ci.u)
  
  invisible (structure(class = "sjs.frqci",
                       list(mydat.frq = mydat.frq,
                            mydat.rel = mydat.rel)))
}