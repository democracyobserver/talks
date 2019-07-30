##--------------------------------------------------------------##
##                  Script for Lecture 5:                       ##
##              Introduction to the Tidyverse                   ##
##                        Nick Davis                            ##
##   Introduction to the R Statistical Computing Environment    ##
##                          ICPSR                               ##
##                          2019                                ##
##--------------------------------------------------------------##

# NOTE: the contents of this file correspond to the slides (also
#       available) but have some more detailed function calls. 
#
#       I have tried to provide comments throughout both files
#       so that it is clear what I have done.


## --- SECTION: Setting up (Entering the Tidyverse)

# install.packages 
install.packages("tidyverse")

# load everything
library("tidyverse")
# Note that there are two identified conflicts. 

# if you want to access the base version of the function,
#   you need to "point" R at the correct namespace
# stats::filter(...)

# or, you can just load what you need
library(magrittr, tibble)

## --- SECTION: magrittr (Piping hot code)

# create an object to demonstrate piping
x <- rnorm(100)
# this is normally how we would call the function mean(x)
mean(x)
# which we can do like this instead with a pipe
x %>% mean(.)

# Note that you can use multiple pipes, passing the left side
#   through to the right, as long as the next function can take
#   the output from the current one. For instance:
x %>% abs(.) %>% mean(.)
# this takes the mean of the absolute value of 'x'
x %>% mean(.) %>% sd(.)
# this fails, as it cannot take the standard deviation of the
#   *value* of the mean of 'x'

# assign Prestige data to object
prestige.data <- carData::Prestige
# use pipe to return brief overview after removing NA values
prestige.data %>% na.omit(.) %>% car::brief(.)


## --- SECTION: tibble (Tidy data frames)

# coerce Prestige data loaded earlier to tibble and print
(prestige.data <- prestige.data %>% as_tibble)
# oh no! where are our row names?
row.names(prestige.data)
# we might want that information, so create a new column in 
#   the tibble called "occupation"
prestige.data$occupation <- row.names(carData::Prestige)
prestige.data
# remember that the tidyverse is "opinionated" --> here is
#   an example:
row.names(prestige.data) <- prestige.data$occupation
# note the warning; it lets you make the assignment, but
#   it is unwilling to support such behavior and does not
#   show you those row names!
prestige.data
# however, they are there:
row.names(prestige.data)
# the tidy developers don't want you to name rows (this has
#   to do with maintaining integrity/flexibility of data)
#   and as such they have built their functions to discourage
#   such choices...

# identify the class(es) of a tibble
prestige.data %>% class(.)
# you can demonstrate coercing to data.frame like this:
prestige.data %>% as.data.frame %>% class
# but to actually do it, you need an assignment:
prestige.data <- prestige.data %>% as.data.frame 

# since we need it as a tibble for the following examples,
#   back it goes... 
prestige.data <- prestige.data %>% as_tibble

# using the Prestige tibble in a linear model declaration
prestige.data %>% 
  lm(prestige ~ income + education + women, data=.) %>%
  summary


## --- SECTION: dplyr (Tidy data management)

# we can get a table of column means for our numeric variables
#   for which 'type' is *not* NA
prestige.data %>% 
  filter(!is.na(type)) %>%
  summarise_at(vars(education, income, women, prestige), mean)


# ADDED: there was a question about whether one could add other
#   functions here; I said that you need to be careful in *how*
#   you do so. Here is an example which works:
prestige.data %>% 
  filter(!is.na(type)) %>%
  summarise_at(
    vars(education, income, women, prestige), 
    funs(n_distinct, mean, sd, min, max))


# we can also get the mean values for those variables, but 
#   calculated for each non-NA level of 'type'
prestige.data %>% 
  filter(!is.na(type)) %>%
  group_by(type) %>%
  summarise_at(vars(education, income, women, prestige), mean)

# we can calculate a new column, educ_deviation, which will be
#   equal to the number of standard deviations of from the mean
#   for each observation of education
prestige.data %>% 
  mutate(., educ_deviation = 
           (education - mean(education) ) / sd(education) ) %>%
  select_at(., vars(education, educ_deviation) ) %>% 
  summary
# note that without assignment we have not actually modified 
#   our data:
prestige.data
# do it again, but with assignment this time:
prestige.data <- prestige.data %>% 
  mutate(., educ_deviation = 
           (education - mean(education) ) / sd(education) )
# note that I omit the summary; we don't want the summary to be 
#   assigned to the object where our data lives! 

