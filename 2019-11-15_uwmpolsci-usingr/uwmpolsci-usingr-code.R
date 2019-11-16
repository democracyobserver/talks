##
##  Created by Nicholas R. Davis (nicholas@democracyobserver.org)
##  on 2019-11-04 08:08:54. Intended for distribution.
##
##########################################################
###################   Using R   ##########################
##########################################################

# if you want to explore the Rcmdr interface
require(car)
require(Rcmdr)
library(Rcmdr)

# after installing a new R distribution, find your old packages and reinstall
dir("/Library/Frameworks/R.framework/Versions/3.5/Resources/library") # discover
install_these <- dir("/Library/Frameworks/R.framework/Versions/3.5/Resources/library") # create object
install_these <- install_these[which(install_these != "democracyData")] # edit some out (here, a GitHub installed package)
install.packages(install.these) # install

# creating data
x <- c(1, 2, 3, 4)
char <- c("1", "2", "3", "4")
listy.mclistface <- list(1, 2, 3, 4)
# lists are the most flexible, fundamental data type
lists.of.lists <- list(list(1, 2, 3), list("a", "b"))
# missing in action: NA vs NULL
y <- c(1, 2, NA, 4)
y.2 <- y
y.2 <- NULL

# data frames are just lists
data(iris)
View(iris)

# merging data
fakedata <- rnorm(150) # draw 150 numbers from a gaussian distr
iris.2 <- cbind(iris, fakedata) # append as column
fakedata.2 <- as.data.frame(cbind(as.character(iris$Species), fakedata))
names(fakedata.2) <- c("Species", "fake_data") # helps to have smae name
iris.3 <- merge(iris, fakedata.2, by = "Species")

# load a CSV with Import
fhscores <- car::Import("/Users/nrdavis/Dropbox/political.science/data/Freedom House/fh_scores_2015.csv")
# load a Stata file
anes <- car::Import("/Users/nrdavis/Dropbox/political.science/data/ANES/anes_timeseries_2016.dta")
# load Stata file so that variable names can be used
require(readstata13)
anes.2 <- read.dta13("/Users/nrdavis/Dropbox/political.science/data/ANES/anes_timeseries_2016.dta")
# note the warnings about factor labels
warnings()
names(attributes(anes.2))
search.var.labels(anes.2, "party") # function from DAMisc

# programming in R

# for loops
for(i in 1:length(fakedata))fakedata[i] - mean(fakedata)
# wait, why no results?
for(i in 1:length(fakedata)){
  print(fakedata[i] - mean(fakedata))
  }
# conditionals
if( is.numeric(x) ) print("Sure, numeric")

# combine with loop
for(i in 1:length(fakedata)){
  if( fakedata[i] > 1 ) print("LORGE")
  else print("SMOL")
}
# wrap that conditional in a handy function
ifelse(iris$Species == "virginica", iris$Sepal.Length, NA)

# apply
apply(iris.2, 2, is.numeric)
# that is wrong... what happened?
sapply(iris.2, is.numeric)
# yes, correct! (apply is great, but stupid without clear instructions)

# aggregate
aggregate(iris$Sepal.Length, list(iris$Species), mean)

# create a function to make life easier (for comparativists, IR folks at least)
tscslag <- function(x, cs, ts){
  obs <- 1:length(x)
  lagobs <- match(paste(cs, ts-1, sep="::"), paste(cs, ts, sep="::"))
  lagx <- x[lagobs]
  lagx
}
fhscores$fh_lag <- tscslag(fhscores$fh_rev, fhscores$ccode, fhscores$year)
summary(fhscores$fh_lag)
View(fhscores)

# another user-created function from DAMisc (referenced above)
search.var.labels <- function(dat, str){
  if("var.labels" %in% names(attributes(dat))){
    vlat <- "var.labels"
  }
  if("variable.labels" %in% names(attributes(dat))){
    vlat <- "variable.labels"
  }
  ind <- grep(str, attr(dat, vlat), ignore.case=T)
  vldf <- data.frame(ind=ind, label = attr(dat, vlat)[ind])
  rownames(vldf) <- names(dat)[ind]
  vldf
}
