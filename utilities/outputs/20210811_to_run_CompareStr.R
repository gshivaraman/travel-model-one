
library(tidyverse)
library(openxlsx)
library(crayon)
library(readxl)

setwd("G:/AMitrani/BAF_23791501")

source('CompareStr.R')

setwd("G:/AMitrani/BAF_23791501/Output workbooks")

CompareStr(workbook1 = "WorkbookStr_2015_TM152_IPA_16_NB_20210811142139amitrani.xlsx", workbook2 = "WorkbookStr_2015_TM152_IPA_16_T16_20210811143011amitrani.xlsx", outputworkbook = "WorkbookStr_2015_TM152_IPA_16_T16_20210811143011amitrani_vs_BAU.xlsx")

CompareStr(workbook1 = "WorkbookStr_2015_TM152_STR_S2_20210811143845amitrani.xlsx", workbook2 = "WorkbookStr_2015_TM152_STR_T8_20210811144721amitrani.xlsx", outputworkbook = "WorkbookStr_2015_TM152_STR_T8_20210811144721amitrani_vs_BAU.xlsx")

CompareStr(workbook1 = "WorkbookStr_2015_TM152_STR_S2_20210811143845amitrani.xlsx", workbook2 = "WorkbookStr_2015_TM152_STR_T14_20210811152331amitrani.xlsx", outputworkbook = "WorkbookStr_2015_TM152_STR_T14_20210811152331amitrani_vs_BAU.xlsx")

CompareStr(workbook1 = "WorkbookStr_2015_TM152_STR_S2_20210811143845amitrani.xlsx", workbook2 = "WorkbookStr_2015_TM152_IPA_16_NB_20210811142139amitrani.xlsx", outputworkbook = "WorkbookStr_2015_TM152_STR_S2_20210805003423amitrani_vs_ETG_BAU.xlsx")





setwd("..")

