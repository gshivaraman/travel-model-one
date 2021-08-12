
# to install Rcpp in project directory (if needed and unable to install in default directory)
mypaths <- .libPaths()
myotherpath <- "G:/AMitrani/BAF_23791501"
mypaths <- c(myotherpath, mypaths)
.libPaths(mypaths)
install.packages("Rcpp")

library(tidyverse)
library(openxlsx)
library(crayon)

setwd("G:/AMitrani/BAF_23791501")

CompareFaresStr(mybaufolder = "2015_TM152_STR_S2", mydsfolder = "2015_TM152_STR_T8")

CompareFaresStr(mybaufolder = "2015_TM152_STR_S2", mydsfolder = "2015_TM152_STR_T14")

CompareFaresStr(mybaufolder = "2015_TM152_IPA_16_NB", mydsfolder = "2015_TM152_IPA_16_T16")



#