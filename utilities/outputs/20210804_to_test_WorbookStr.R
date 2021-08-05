

library(tidyverse)
library(openxlsx)
library(crayon)

setwd("G:/AMitrani/BAF_23791501")

source('WorkbookStr.R')
source('SummariseStr.R')

setwd("2015_TM152_IPA_16_NB")

WorkbookStr(scenariocode="2015_TM152_IPA_16_NB")

print(gc())

setwd("..")

setwd("2015_TM152_IPA_16_T16")

WorkbookStr(scenariocode="2015_TM152_IPA_16_T16")

print(gc())

setwd("..")

setwd("2015_TM152_STR_S2")

WorkbookStr(scenariocode="2015_TM152_STR_S2")

print(gc())

setwd("..")

setwd("2015_TM152_STR_T8")

WorkbookStr(scenariocode="2015_TM152_STR_T8")

print(gc())

setwd("..")

print(gc())

