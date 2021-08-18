
library(tidyverse)
library(readxl)
library(openxlsx)
library(reshape2)
library(crayon)

setwd("G:/AMitrani/BAF_23791501")

source("JoinSkimsStr.R", encoding = "UTF-8")
source("WorkbookStr.R", encoding = "UTF-8")
source("SummariseStr.R", encoding = "UTF-8")

setwd("2015_TM152_IPA_16_T3")

JoinSkimsStr(fullrun=FALSE, iter=4, sampleshare=0.5, logrun=TRUE, baufares=FALSE, "walktime", "fare")

print(gc())

setwd("..")

setwd("2015_TM152_IPA_16_T3")

WorkbookStr(scenariocode="2015_TM152_IPA_16_T3")

#