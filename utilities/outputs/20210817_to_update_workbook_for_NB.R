
library(tidyverse)
library(readxl)
library(openxlsx)
library(reshape2)
library(crayon)

setwd("G:/AMitrani/BAF_23791501")

source("WorkbookStr.R", encoding = "UTF-8")

myrunfoldername <- "2015_TM152_IPA_16_NB"

setwd(myrunfoldername)

WorkbookStr(scenariocode=myrunfoldername)

print(gc())

setwd("..")