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

source("JoinSkimsStr.R", encoding = "UTF-8")

setwd("2015_TM152_STR_S2")

JoinSkimsStr(fullrun=FALSE, iter=4, sampleshare=0.5, logrun=TRUE, baufares=TRUE)

print(gc())

setwd("..")

setwd("2015_TM152_STR_T8")

JoinSkimsStr(fullrun=FALSE, iter=4, sampleshare=0.5, logrun=TRUE, baufares=FALSE, "fare")

print(gc())

setwd("..")

#


