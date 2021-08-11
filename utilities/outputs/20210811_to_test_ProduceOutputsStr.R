# to install Rcpp in project directory (if needed and unable to install in default directory)
mypaths <- .libPaths()
myotherpath <- "G:/AMitrani/BAF_23791501"
mypaths <- c(myotherpath, mypaths)
.libPaths(mypaths)
install.packages("Rcpp")

library(tidyverse)
library(readxl)
library(openxlsx)
library(reshape2)
library(crayon)

source("ProduceOutputsStr.R", encoding = "UTF-8")

ProduceOutputsStr(myrunfoldername="2015_TM152_STR_T14")


