


library(tidyverse)
library(readxl)
library(openxlsx)
library(reshape2)
library(crayon)

source("JoinSkimsStr.R", encoding = "UTF-8")
source("SummariseStr.R", encoding = "UTF-8")
source("WorkbookStr.R", encoding = "UTF-8")

setwd("G:/AMitrani/BAF_23791501")

myrunfoldername <- "2015_TM152_STR_T14"

setwd(myrunfoldername)

JoinSkimsStr(fullrun=FALSE, iter=4, sampleshare=0.5, logrun=TRUE, baufares=FALSE, "fare")

print(gc())

WorkbookStr(scenariocode=myrunfoldername)

print(gc())

setwd("..")

myrunfoldername <- "2015_TM152_STR_S2"

setwd(myrunfoldername)

WorkbookStr(scenariocode=myrunfoldername)

print(gc())

setwd("..")





#
