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

setwd("2015_TM152_STR_T8")

JoinSkimsStr(fullrun=TRUE, iter=4, sampleshare=0.5, logrun=TRUE, "walktime", "wait", "IVT", "transfers", "fare", "boardfare", "faremat", "xfare", "othercost", "distance", "dFree", "dInterCity", "dLocal", "dRegional", "ddist", "dFareMat")

print(gc())

setwd("..")

setwd("2015_TM152_IPA_16_NB")

JoinSkimsStr(fullrun=TRUE, iter=4, sampleshare=0.5, logrun=TRUE, "walktime", "wait", "IVT", "transfers", "fare", "boardfare", "faremat", "xfare", "othercost", "distance", "dFree", "dInterCity", "dLocal", "dRegional", "ddist", "dFareMat")

print(gc())

setwd("..")

setwd("2015_TM152_IPA_16_T16")

JoinSkimsStr(fullrun=TRUE, iter=4, sampleshare=0.5, logrun=TRUE, "walktime", "wait", "IVT", "transfers", "fare", "boardfare", "faremat", "xfare", "othercost", "distance", "dFree", "dInterCity", "dLocal", "dRegional", "ddist", "dFareMat")

print(gc())

setwd("..")

setwd("2015_TM152_STR_S2")

JoinSkimsStr(fullrun=TRUE, iter=4, sampleshare=0.5, logrun=TRUE, "walktime", "wait", "IVT", "transfers", "fare", "boardfare", "faremat", "xfare", "othercost", "distance", "dFree", "dInterCity", "dLocal", "dRegional", "ddist", "dFareMat")

print(gc())

setwd("..")

setwd("2015_TM152_STR_T14")

JoinSkimsStr(fullrun=TRUE, iter=4, sampleshare=0.5, logrun=TRUE, "walktime", "wait", "IVT", "transfers", "fare", "boardfare", "faremat", "xfare", "othercost", "distance", "dFree", "dInterCity", "dLocal", "dRegional", "ddist", "dFareMat")

print(gc())

setwd("..")



