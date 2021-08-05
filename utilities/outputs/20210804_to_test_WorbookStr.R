

library(tidyverse)
library(openxlsx)
library(crayon)

source('WorkbookStr.R')
source('SummariseStr.R')

setwd("2015_TM152_STR_T8")

WorkbookStr()

print(gc())

setwd("..")

WorkbookStr()