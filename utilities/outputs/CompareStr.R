CompareStr <- function(workbook1, workbook2) {
  
  library(tidyverse)
  library(openxlsx)
  library(crayon)
  library(readxl)
  
  # regularize strings and create output workbook
  wb <- createWorkbook() 
  workbook1 <- gsub(".xlsx", "", workbook1)
  workbook2 <- gsub(".xlsx", "", workbook2)
  workbook1filename <- paste0(workbook1, ".xlsx")
  workbook2filename <- paste0(workbook2, ".xlsx")
  outputworkbookfilename <- paste(workbook1, "_vs_", workbook2, ".xlsx")
  outputworkbookfilename <- gsub(" ", "", outputworkbookfilename)
  
  # trip_mode
  
  trip_mode1 <- read_excel(workbook1filename, sheet = "trip_mode")
  trip_mode2 <- read_excel(workbook2filename, sheet = "trip_mode")
  
  trip_mode <- trip_mode1 %>% full_join(trip_mode2, by=c("trip_mode"), suffix=c("1", "2"))
  
  trip_mode <- trip_mode %>% 
    select("trip_mode", "trips1", "trips2",	"revenue1", "revenue2", "fare1", "fare2",	"num_participants1", "num_participants2", "walktime1", "walktime2", "wait1", "wait2", "IVT1", "IVT2", "transfers1", "transfers2", "othercost1", "othercost2", "distance1", "distance2", "dLocal1", "dLocal2", "dRegional1", "dRegional2", "dFree1", "dFree2", "dInterCity1", "dInterCity2", "ddist1", "ddist2", "dFareMat1", "dFareMat2") %>%
    arrange("trip_mode")
  
  # export the resulting table to Excel
  
  sheetname <- "trip_mode"
  addWorksheet(wb, sheetname)
  writeData(wb, sheetname, trip_mode)
  
  
  # other variables combined with trip_mode to define categories: 
  
  for (myvar in c("incQ", "timeCodeNum", "ptype", "home_taz")) {
    
    mysheetname <- paste0(myvar, "_trip_mode")
  
    mydf1 <- read_excel(workbook1filename, sheet = mysheetname)
    mydf2 <- read_excel(workbook2filename, sheet = mysheetname)
    
    mydf <- mydf1 %>% full_join(mydf2, by=c(all_of(myvar), "trip_mode"), suffix=c("1", "2"))
    
    mydf <- mydf %>% 
      select(all_of(myvar), "trip_mode", "trips1", "trips2",	"revenue1", "revenue2", "fare1", "fare2",	"num_participants1", "num_participants2", "walktime1", "walktime2", "wait1", "wait2", "IVT1", "IVT2", "transfers1", "transfers2", "othercost1", "othercost2", "distance1", "distance2", "dLocal1", "dLocal2", "dRegional1", "dRegional2", "dFree1", "dFree2", "dInterCity1", "dInterCity2", "ddist1", "ddist2", "dFareMat1", "dFareMat2") %>%
      arrange(all_of(myvar), "trip_mode")
    
    
    if(myvar == "incQ") {
      
      incQ_trip_mode <- mydf
      sheetname <- mysheetname
      addWorksheet(wb, mysheetname)
      writeData(wb, sheetname, incQ_trip_mode)
      
      
    } else if(myvar == "timeCodeNum") {
      
      timeCodeNum_trip_mode <- mydf
      sheetname <- mysheetname
      addWorksheet(wb, mysheetname)
      writeData(wb, sheetname, timeCodeNum_trip_mode)
      
    } else if(myvar == "ptype") {
      
      ptype_trip_mode <- mydf
      sheetname <- mysheetname
      addWorksheet(wb, mysheetname)
      writeData(wb, sheetname, ptype_trip_mode)
      
      
    } else if(myvar == "home_taz") {
      
      home_taz_trip_mode <- mydf
      sheetname <- mysheetname
      addWorksheet(wb, mysheetname)
      writeData(wb, sheetname, home_taz_trip_mode)      
      
    }
    
  }  
  
  # County OD outputs
  
  # trip_mode
  
  county_od_trip_mode1 <- read_excel(workbook1filename, sheet = "county_od_trip_mode")
  county_od_trip_mode2 <- read_excel(workbook2filename, sheet = "county_od_trip_mode")
  
  county_od_trip_mode <- county_od_trip_mode1 %>% full_join(county_od_trip_mode2, by=c("orig_county", "dest_county", "trip_mode"), suffix=c("1", "2"))
  
  county_od_trip_mode <- county_od_trip_mode %>% 
    select("orig_county", "dest_county", "trip_mode", "trips1", "trips2",	"revenue1", "revenue2", "fare1", "fare2",	"num_participants1", "num_participants2", "walktime1", "walktime2", "wait1", "wait2", "IVT1", "IVT2", "transfers1", "transfers2", "othercost1", "othercost2", "distance1", "distance2", "dLocal1", "dLocal2", "dRegional1", "dRegional2", "dFree1", "dFree2", "dInterCity1", "dInterCity2", "ddist1", "ddist2", "dFareMat1", "dFareMat2") %>%
    arrange("orig_county", "dest_county", "trip_mode")
  
  # export the resulting table to Excel
  
  sheetname <- "county_od_trip_mode"
  addWorksheet(wb, sheetname)
  writeData(wb, sheetname, county_od_trip_mode)

  # Save the workbook
  
  saveWorkbook(wb, file = outputworkbookfilename, overwrite = TRUE)
  
}

