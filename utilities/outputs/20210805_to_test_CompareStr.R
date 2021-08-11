
library(tidyverse)
library(openxlsx)
library(crayon)
library(readxl)

setwd("G:/AMitrani/BAF_23791501")

source('CompareStr.R')

setwd("G:/AMitrani/BAF_23791501/Output workbooks")

CompareStr(workbook1 = "WorkbookStr_2015_TM152_IPA_16_NB_20210805001702amitrani.xlsx", workbook2 = "WorkbookStr_2015_TM152_IPA_16_T16_20210805002550amitrani.xlsx", outputworkbook = "WorkbookStr_2015_TM152_IPA_16_T16_20210805002550amitrani_vs_BAU.xlsx")

CompareStr(workbook1 = "WorkbookStr_2015_TM152_STR_S2_20210805003423amitrani.xlsx", workbook2 = "WorkbookStr_2015_TM152_STR_T8_20210805004256amitrani.xlsx", outputworkbook = "WorkbookStr_2015_TM152_STR_T8_20210805004256amitrani_vs_BAU.xlsx")

CompareStr(workbook1 = "WorkbookStr_2015_TM152_STR_S2_20210805003423amitrani.xlsx", workbook2 = "WorkbookStr_2015_TM152_IPA_16_NB_20210805001702amitrani.xlsx", outputworkbook = "WorkbookStr_2015_TM152_STR_S2_20210805003423amitrani_vs_ETG_BAU.xlsx")

CompareStr(workbook1 = "WorkbookStr_2015_TM152_STR_S2_20210805003423amitrani.xlsx", workbook2 = "WorkbookStr_2015_TM152_STR_T14_20210811105734amitrani.xlsx", outputworkbook = "WorkbookStr_2015_TM152_STR_T14_20210811105734amitrani_vs_BAU.xlsx")

setwd("..")

