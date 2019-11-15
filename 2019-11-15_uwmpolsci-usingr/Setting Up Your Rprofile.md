# Setting Up Your Rprofile

First, locate your `.rprofile` in your user home directory or the default working directory for your R installation. Note that this file is typically hidden/invisible.

Here is some background information: https://www.r-bloggers.com/fun-with-rprofile-and-customizing-r-startup/

Here is what I put in mine:

```r
.libPaths(c("/Library/Frameworks/R.framework/Resources/library"))

## load libraries -- NOT RECOMENDED! (bad for replication)
# library("devtools")

## Don't ask me for my CRAN mirror every time
options(
    "repos" = c(CRAN = "https://cran.case.edu/"), ## Don't ask me for my CRAN mirror every time
    radian.auto_match = TRUE  # auto match brackets and quotes in radian
    )

## Create a new invisible environment for all the functions to go in so it doesn't clutter your workspace.
.env <- new.env()

# check if essential packages are installed
invisible(source("/Users/nrdavis/Dropbox/political.science/RDatafiles/functions/checkPackages.R", local = .env))
.env$checkPackages(c("devtools", "Rcpp", "rJava"), install.packs = TRUE, load.packs = FALSE)
invisible(interactive())

# custom functions; only include functions which can be sourced without exceptions
invisible(sapply(list.files("/Users/nrdavis/Dropbox/political.science/RDatafiles/functions/", pattern="*.R$", full.names=TRUE, ignore.case=TRUE), source, local = .env))

## shortcuts for directory information
.env$cd <- base::setwd
.env$pwd <- base::getwd
.env$lss <- base::dir
.env$exit <- base::q

## ht==headtail, i.e., show the first and last 10 items of an object
.env$ht <- function(d) rbind(head(d,10),tail(d,10))

## Open Finder to the current directory on mac
.env$macopen <- function(...) if(Sys.info()[1]=="Darwin") system("open .")

## shortcuts for other often-used commands
.env$listcnames <- function(df) cbind(colnames(df))

# handy operator function from Hmisc
.env$`%nin%` <- function (x, table){match(x, table, nomatch = 0) == 0}

## Attach all the variables above
attach(.env)

.First <- function(){
    # run package sync
    syncPacks()

    # list custom functions loaded
    print(paste0("Note, custom functions are available: ", paste(ls(envir = .env), collapse = ", ")))

    cd("/Users/nrdavis/Dropbox/political.science/RDatafiles")
    cat("\n .Rprofile load verified at", date(), "\n")
}

.Last <- function(){
    cat("\nGoodbye at ", date(), "\n")
    cd("/Users/nrdavis")
}
```