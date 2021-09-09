
library(tidyverse)
library(openxlsx)
library(crayon)
library(readxl)

setwd("G:/AMitrani/BAF_23791501")

source('CompareStr.R')

setwd("G:/AMitrani/BAF_23791501/Output workbooks")

# ETG base vs ETG tests

CompareStr(workbook1 = "WorkbookStr_2015_TM152_IPA_16_NB_20210818144759amitrani.xlsx", workbook2 = "WorkbookStr_2015_TM152_IPA_16_T3_20210818153423amitrani.xlsx")

CompareStr(workbook1 = "WorkbookStr_2015_TM152_IPA_16_NB_20210818144759amitrani.xlsx", workbook2 = "WorkbookStr_2015_TM152_IPA_16_T16_20210818154552amitrani.xlsx")

CompareStr(workbook1 = "WorkbookStr_2015_TM152_IPA_16_NB_20210818144759amitrani.xlsx", workbook2 = "WorkbookStr_2015_TM152_IPA_16_T17_20210818155720amitrani.xlsx")

# MTC base vs MTC tests

CompareStr(workbook1 = "WorkbookStr_2015_TM152_MTC_T26_20210830201723amitrani.xlsx", workbook2 = "WorkbookStr_2015_TM152_MTC_T27_20210830202437amitrani.xlsx")

CompareStr(workbook1 = "WorkbookStr_2015_TM152_MTC_T26_20210830201723amitrani.xlsx", workbook2 = "WorkbookStr_2015_TM152_MTC_T28_20210830203150amitrani.xlsx")

CompareStr(workbook1 = "WorkbookStr_2015_TM152_MTC_T26_20210830201723amitrani.xlsx", workbook2 = "WorkbookStr_2015_TM152_MTC_T30_20210901144143amitrani.xlsx")

# MTC base vs MTC tests, including the incQ-mode-hometaz sheet

CompareStr(workbook1 = "WorkbookStr_2015_TM152_MTC_T26_20210902103141amitrani.xlsx", workbook2 = "WorkbookStr_2015_TM152_MTC_T31_20210902094336amitrani.xlsx")

CompareStr(workbook1 = "WorkbookStr_2015_TM152_MTC_T26_20210902103141amitrani.xlsx", workbook2 = "WorkbookStr_2015_TM152_MTC_T33_20210902095157amitrani.xlsx")

CompareStr(workbook1 = "WorkbookStr_2015_TM152_MTC_T26_20210902103141amitrani.xlsx", workbook2 = "WorkbookStr_2015_TM152_MTC_T35_20210903094537amitrani.xlsx")

CompareStr(workbook1 = "WorkbookStr_2015_TM152_MTC_T26_20210902103141amitrani.xlsx", workbook2 = "WorkbookStr_2015_TM152_MTC_T36_20210902172820amitrani.xlsx")

CompareStr(workbook1 = "WorkbookStr_2015_TM152_MTC_T26_20210902103141amitrani.xlsx", workbook2 = "WorkbookStr_2015_TM152_MTC_T37_20210909112758amitrani.xlsx")

CompareStr(workbook1 = "WorkbookStr_2015_TM152_MTC_T26_20210902103141amitrani.xlsx", workbook2 = "WorkbookStr_2015_TM152_MTC_T38_20210908084551amitrani.xlsx")

CompareStr(workbook1 = "WorkbookStr_2015_TM152_MTC_T26_20210902103141amitrani.xlsx", workbook2 = "WorkbookStr_2015_TM152_MTC_T39_20210908090555amitrani.xlsx")

CompareStr(workbook1 = "WorkbookStr_2015_TM152_MTC_T26_20210902103141amitrani.xlsx", workbook2 = "WorkbookStr_2015_TM152_MTC_T41_20210909114142amitrani.xlsx")

CompareStr(workbook1 = "WorkbookStr_2015_TM152_MTC_T26_20210902103141amitrani.xlsx", workbook2 = "WorkbookStr_2015_TM152_MTC_T42_20210909114913amitrani.xlsx")

# Steer base vs Steer tests

CompareStr(workbook1 = "WorkbookStr_2015_TM152_STR_S2_20210818160843amitrani.xlsx", workbook2 = "WorkbookStr_2015_TM152_STR_T8_20210818162014amitrani.xlsx")

CompareStr(workbook1 = "WorkbookStr_2015_TM152_STR_S2_20210818160843amitrani.xlsx", workbook2 = "WorkbookStr_2015_TM152_STR_T14_20210818163147amitrani.xlsx")

CompareStr(workbook1 = "WorkbookStr_2015_TM152_STR_S2_20210818160843amitrani.xlsx", workbook2 = "WorkbookStr_2015_TM152_STR_T20_20210818164322amitrani.xlsx")

CompareStr(workbook1 = "WorkbookStr_2015_TM152_STR_S2_20210818160843amitrani.xlsx", workbook2 = "WorkbookStr_2015_TM152_STR_T15_20210819172255amitrani.xlsx")

CompareStr_TM152_STR_T7(workbook1 = "WorkbookStr_2015_TM152_STR_S2_20210818160843amitrani.xlsx", workbook2 = "WorkbookStr_WorkbookStr_TM152_STR_T7_20210823114018amitrani.xlsx")

CompareStr(workbook1 = "WorkbookStr_2015_TM152_STR_S2_20210818160843amitrani.xlsx", workbook2 = "WorkbookStr_2015_TM152_STR_T21_20210823144658amitrani.xlsx")

CompareStr(workbook1 = "WorkbookStr_2015_TM152_STR_S2_20210818160843amitrani.xlsx", workbook2 = "WorkbookStr_2015_TM152_STR_T23_20210825114332amitrani.xlsx")

CompareStr(workbook1 = "WorkbookStr_2015_TM152_STR_S2_20210818160843amitrani.xlsx", workbook2 = "WorkbookStr_2015_TM152_STR_T24_20210830103758amitrani.xlsx")

CompareStr(workbook1 = "WorkbookStr_2015_TM152_STR_S2_20210818160843amitrani.xlsx", workbook2 = "WorkbookStr_2015_TM152_STR_T25_20210831124830amitrani.xlsx")

# Steer base vs Steer tests, including the incQ-mode-hometaz sheet

CompareStr(workbook1 = "WorkbookStr_2015_TM152_STR_S2_20210901155603amitrani.xlsx", workbook2 = "WorkbookStr_2015_TM152_STR_T14_20210901153825amitrani.xlsx")

CompareStr(workbook1 = "WorkbookStr_2015_TM152_STR_S2_20210901155603amitrani.xlsx", workbook2 = "WorkbookStr_2015_TM152_STR_T24_20210901151604amitrani.xlsx")

CompareStr(workbook1 = "WorkbookStr_2015_TM152_STR_S2_20210901155603amitrani.xlsx", workbook2 = "WorkbookStr_2015_TM152_STR_T32_20210902111640amitrani.xlsx")

CompareStr(workbook1 = "WorkbookStr_2015_TM152_STR_S2_20210901155603amitrani.xlsx", workbook2 = "WorkbookStr_2015_TM152_STR_T29_20210907154944amitrani.xlsx")

# ETG base versus Steer base

CompareStr(workbook1 = "WorkbookStr_2015_TM152_IPA_16_NB_20210818144759amitrani.xlsx", workbook2 = "WorkbookStr_2015_TM152_STR_S2_20210818160843amitrani.xlsx")

# MTC base versus Steer base

CompareStr(workbook1 = "WorkbookStr_2015_TM152_MTC_T26_20210830201723amitrani.xlsx", workbook2 = "WorkbookStr_2015_TM152_STR_S2_20210818160843amitrani.xlsx")

#
