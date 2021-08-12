
library(tidyverse)
library(openxlsx)
library(crayon)
library(readxl)

setwd("G:/AMitrani/BAF_23791501")

source('CompareStr.R')

setwd("G:/AMitrani/BAF_23791501/Output workbooks")

CompareStr(workbook1 = "WorkbookStr_2015_TM152_STR_S2_20210812160534amitrani.xlsx", workbook2 = "WorkbookStr_2015_TM152_STR_T8_20210812161425amitrani.xlsx", outputworkbook = "WorkbookStr_2015_TM152_STR_T8_20210812161425amitrani_vs_BAU.xlsx")






setwd("..")

