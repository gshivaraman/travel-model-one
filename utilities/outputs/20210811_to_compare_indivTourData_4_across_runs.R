
library(tidyverse)
library(openxlsx)
library(crayon)
library(readxl)

setwd("G:/AMitrani/BAF_23791501")

setwd("2015_TM152_IPA_16_NB")

setwd("main")

sheetname1 <- "2015_TM152_IPA_16_NB"
mydf1 <- read.csv("indivTourData_4.csv", nrows=1000)

setwd("../..")

setwd("2015_TM152_IPA_16_T16")

setwd("main")

sheetname2 <- "2015_TM152_IPA_16_T16"
mydf2 <- read.csv("indivTourData_4.csv", nrows=1000)

setwd("../..")

setwd("2015_TM152_STR_S2")

setwd("main")

sheetname3 <- "2015_TM152_STR_S2"
mydf3 <- read.csv("indivTourData_4.csv", nrows=1000)

setwd("../..")

setwd("2015_TM152_STR_T8")

setwd("main")

sheetname4 <- "2015_TM152_STR_T8"
mydf4 <- read.csv("indivTourData_4.csv", nrows=1000)

setwd("../..")

setwd("2015_TM152_STR_T14")

setwd("main")

sheetname5 <- "2015_TM152_STR_T14"
mydf5 <- read.csv("indivTourData_4.csv", nrows=1000)

setwd("../..")

# create output workbook
wb <- createWorkbook()

# export the resulting tables to Excel

sheetname <- sheetname1
addWorksheet(wb, sheetname)
writeData(wb, sheetname, mydf1)

sheetname <- sheetname2
addWorksheet(wb, sheetname)
writeData(wb, sheetname, mydf2)

sheetname <- sheetname3
addWorksheet(wb, sheetname)
writeData(wb, sheetname, mydf3)  

sheetname <- sheetname4
addWorksheet(wb, sheetname)
writeData(wb, sheetname, mydf4)   

sheetname <- sheetname5
addWorksheet(wb, sheetname)
writeData(wb, sheetname, mydf5)    

# Save the workbook

filename <- paste0("20210811_to_compare_indivTourData_4_across_runs.xlsx")
saveWorkbook(wb, file = filename, overwrite = TRUE)

#




