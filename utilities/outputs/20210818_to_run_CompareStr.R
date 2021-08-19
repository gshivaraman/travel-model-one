
library(tidyverse)
library(openxlsx)
library(crayon)
library(readxl)

setwd("G:/AMitrani/BAF_23791501")

source('CompareStr.R')

setwd("G:/AMitrani/BAF_23791501/Output workbooks")

# ETG base vs ETG tests

CompareStr(workbook1 = "WorkbookStr_2015_TM152_IPA_16_NB_20210818144759amitrani", workbook2 = "WorkbookStr_2015_TM152_IPA_16_T3_20210818153423amitrani")

CompareStr(workbook1 = "WorkbookStr_2015_TM152_IPA_16_NB_20210818144759amitrani", workbook2 = "WorkbookStr_2015_TM152_IPA_16_T16_20210818154552amitrani")

CompareStr(workbook1 = "WorkbookStr_2015_TM152_IPA_16_NB_20210818144759amitrani", workbook2 = "WorkbookStr_2015_TM152_IPA_16_T17_20210818155720amitrani")

# Steer base vs Steer tests

CompareStr(workbook1 = "WorkbookStr_2015_TM152_STR_S2_20210818160843amitrani", workbook2 = "WorkbookStr_2015_TM152_STR_T8_20210818162014amitrani")

CompareStr(workbook1 = "WorkbookStr_2015_TM152_STR_S2_20210818160843amitrani", workbook2 = "WorkbookStr_2015_TM152_STR_T14_20210818163147amitrani")

CompareStr(workbook1 = "WorkbookStr_2015_TM152_STR_S2_20210818160843amitrani", workbook2 = "WorkbookStr_2015_TM152_STR_T20_20210818164322amitrani")

# ETG base versus Steer base

CompareStr(workbook1 = "WorkbookStr_2015_TM152_IPA_16_NB_20210818144759amitrani", workbook2 = "WorkbookStr_2015_TM152_STR_S2_20210818160843amitrani")

#
