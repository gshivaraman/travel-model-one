

library(tidyverse)
library(openxlsx)
library(crayon)

setwd("G:/AMitrani/BAF_23791501")

source('WorkbookStr.R')
source('SummariseStr.R')

setwd("2015_TM152_STR_T8")

WorkbookStr()

print(gc())

setwd("..")

WorkbookStr()