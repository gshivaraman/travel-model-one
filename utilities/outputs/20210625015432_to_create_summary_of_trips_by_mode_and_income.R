library(tidyverse)
library(readxl)
library(openxlsx)

trip_mode_name_transit <- read_excel("trip_mode_name_transit.xlsx",
  range = "A1:C22", col_types = c("numeric", "text", "numeric"))


myscenarioid <- "20210625015432"
mypathfile <- paste0("F:/23791501/outputs/", myscenarioid, "/OUTPUT/updated_output/trips.rdata")

load(mypathfile)

names(trips)

trip_summary <- trips %>%
  group_by(incQ, trip_mode) %>%
  summarise(trips = sum((1/sampleRate))) %>%
  ungroup()

trip_summary <- trip_summary %>%
  left_join(trip_mode_name_transit)

wb <- createWorkbook()
sheetname <- "income_mode_trips"
addWorksheet(wb, sheetname)
writeData(wb, sheetname, trip_summary)
filename <- paste0(myscenarioid, "_trip_summary", ".xlsx")
saveWorkbook(wb, file = filename, overwrite = TRUE)

#





