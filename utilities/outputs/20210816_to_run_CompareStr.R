
library(tidyverse)
library(openxlsx)
library(crayon)
library(readxl)

setwd("G:/AMitrani/BAF_23791501")

source('CompareStr.R')

setwd("G:/AMitrani/BAF_23791501/Output workbooks")

CompareStr(workbook1 = "WorkbookStr_2015_TM152_STR_S2_20210816161555amitrani.xlsx", workbook2 = "WorkbookStr_2015_TM152_STR_T14_20210816154639amitrani.xlsx", outputworkbook = "WorkbookStr_2015_TM152_STR_T14_20210816154639amitrani_vs_BAU.xlsx")

CompareStr(workbook1 = "WorkbookStr_2015_TM152_STR_S2_20210816161555amitrani.xlsx", workbook2 = "WorkbookStr_2015_TM152_STR_T8_20210816164726amitrani.xlsx", outputworkbook = "WorkbookStr_2015_TM152_STR_T8_20210816164726amitrani_vs_BAU.xlsx")

CompareStr(workbook1 = "WorkbookStr_2015_TM152_IPA_16_NB_20210817191457amitrani.xlsx", workbook2 = "WorkbookStr_2015_TM152_IPA_16_T3_20210817175955amitrani.xlsx", outputworkbook = "WorkbookStr_2015_TM152_IPA_16_T3_20210817175955amitrani_vs_BAU.xlsx")

#
