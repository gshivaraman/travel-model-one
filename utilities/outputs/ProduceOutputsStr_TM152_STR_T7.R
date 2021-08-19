

ProduceOutputsStr <- function(myrunfoldername="NotDefined", fullrun=TRUE, iter=4, sampleshare=0.5, logrun=TRUE, baufares=FALSE) {
  
  # Example of use
  # ProduceOutputsStr(myrunfoldername="2015_TM152_STR_T14")

  library(tidyverse)
  library(readxl)
  library(openxlsx)
  library(reshape2)
  library(crayon)
  
  source("JoinSkimsStr.R", encoding = "UTF-8")
  source("WorkbookStr_TM152_STR_T7.R", encoding = "UTF-8")
  
  setwd(myrunfoldername)
  
  JoinSkimsStr(fullrun=fullrun, iter=iter, sampleshare=sampleshare, logrun=logrun, baufares=baufares, "walktime", "wait", "IVT", "transfers", "fare", "boardfare", "faremat", "xfare", "othercost", "distance", "ddist")
  
  print(gc())
  
  WorkbookStr_TM152_STR_T7(scenariocode=myrunfoldername)
  
  print(gc())
  
  setwd("..")
  
  
}

