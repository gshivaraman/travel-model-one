tripsummary <- function(myscenarioid) {
  
  # Version 1 01 by Alex Mitrani, updated on 28 June 2021.  At present this function takes the timestamp of the desired scenario as input and produces a workbook with a summary of trips by mode and income group.  
  # Version 1 02 by Alex Mitrani, updated on 5 July 2021.  Added "test" (myscenarioid) to the output table.  
  
  # Example of use:
  # tripsummary(myscenarioid = "20210627171152")

  library(tidyverse)
  library(readxl)
  library(openxlsx)
  
  trip_mode_name_transit <- read_excel("trip_mode_name_transit.xlsx",
    range = "A1:C22", col_types = c("numeric", "text", "numeric"))
  
  mywd <- getwd()
  
  mypathfile <- paste0(mywd, "/", myscenarioid, "/OUTPUT/updated_output/trips.rdata")
  
  load(mypathfile)
  
  names(trips)
  
  trip_summary <- trips %>%
    group_by(incQ, trip_mode) %>%
    summarise(trips = sum((1/sampleRate))) %>%
    ungroup()
  
  trip_summary <- trip_summary %>%
    left_join(trip_mode_name_transit)
  
  trip_summary <- trip_summary %>%
    mutate(test = myscenarioid) %>%
    relocate(test)

  wb <- createWorkbook()
  sheetname <- "income_mode_trips"
  addWorksheet(wb, sheetname)
  writeData(wb, sheetname, trip_summary)
  filename <- paste0(myscenarioid, "_trip_summary", ".xlsx")
  saveWorkbook(wb, file = filename, overwrite = TRUE)
  
}

#





