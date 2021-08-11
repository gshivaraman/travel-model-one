

ProduceOutputsStr <- function(myrunfoldername="NotDefined", fullrun=TRUE, iter=4, sampleshare=0.5, logrun=TRUE) {
  
  # Example of use
  # ProduceOutputsStr(myrunfoldername="2015_TM152_STR_T14")

  library(tidyverse)
  library(readxl)
  library(openxlsx)
  library(reshape2)
  library(crayon)
  
  source("JoinSkimsStr.R", encoding = "UTF-8")
  
  setwd(myrunfoldername)
  
  JoinSkimsStr(fullrun=fullrun, iter=iter, sampleshare=sampleshare, logrun=logrun, "walktime", "wait", "IVT", "transfers", "boardfare", "faremat", "xfare", "othercost", "distance", "dFree", "dInterCity", "dLocal", "dRegional", "ddist", "dFareMat")
  
  print(gc())
  
  source('WorkbookStr.R')
  source('SummariseStr.R')
  
  WorkbookStr(scenariocode=myrunfoldername)
  
  print(gc())
  
  setwd("..")
  
  
}

