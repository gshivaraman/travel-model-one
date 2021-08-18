
library(tidyverse)
library(openxlsx)
library(crayon)
library(readxl)

setwd("G:/AMitrani/BAF_23791501")

source('CompareStr.R')

setwd("G:/AMitrani/BAF_23791501/Output workbooks")

CompareStr(workbook1 = "WorkbookStr_2015_TM152_IPA_16_NB_20210817191457amitrani.xlsx", workbook2 = "WorkbookStr_2015_TM152_IPA_16_T16_20210817231416amitrani.xlsx", outputworkbook = "WorkbookStr_2015_TM152_IPA_16_T16_20210817231416amitrani_vs_BAU.xlsx")

CompareStr(workbook1 = "WorkbookStr_2015_TM152_IPA_16_NB_20210817191457amitrani.xlsx", workbook2 = "WorkbookStr_2015_TM152_IPA_16_T17_20210818003136amitrani.xlsx", outputworkbook = "WorkbookStr_2015_TM152_IPA_16_T17_20210818003136amitrani_vs_BAU.xlsx")

#
