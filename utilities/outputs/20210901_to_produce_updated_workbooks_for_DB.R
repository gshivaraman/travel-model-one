
library(tidyverse)
library(readxl)
library(openxlsx)
library(reshape2)
library(crayon)

setwd("G:/AMitrani/BAF_23791501")

source("WorkbookStr.R", encoding = "UTF-8")

myrunfoldername <- "2015_TM152_STR_T24"

setwd(myrunfoldername)

WorkbookStr(scenariocode=myrunfoldername)

print(gc())

setwd("..")

myrunfoldername <- "2015_TM152_STR_T14"

setwd(myrunfoldername)

WorkbookStr(scenariocode=myrunfoldername)

print(gc())

setwd("..")

myrunfoldername <- "2015_TM152_STR_S2"

setwd(myrunfoldername)

WorkbookStr(scenariocode=myrunfoldername)

print(gc())

setwd("..")