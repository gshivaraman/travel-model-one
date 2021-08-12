CompareFaresStr <- function(mybaufolder = "NotDefined", mydsfolder = "NotDefinedEither", logrun=TRUE) {
  
  library(tidyverse)
  library(openxlsx)
  library(crayon)
  
  # Example of use:
  # CompareFaresStr(mybaufolder = "2015_TM152_STR_S2", mydsfolder = "2015_TM152_STR_T14")
  
  # report start of process and time
  
  now1 <- Sys.time()
  cat(yellow(paste0("CompareFaresStr run started at ", now1, "\n \n")))  
  
  # load utility functions
  
  datestampr <- function(dateonly = FALSE, houronly = FALSE, minuteonly = FALSE, myusername = FALSE) {
    
    #General info
    now <- Sys.time()
    year <- format(now, "%Y")
    month <- format(now, "%m")
    day <- format(now, "%d")
    hour <- format(now, "%H")
    minute <- format(now, "%M")
    second <- format(now, "%S")
    username <- Sys.getenv("USERNAME")
    
    
    if (nchar(day)==2) {
      
      day <- day
      
    } else {
      
      day <- paste0("0",day)
      
    }
    
    if (nchar(month)==2) {
      
      month <- month
      
    } else {
      
      month <- paste0("0",month)
      
    }
    
    if (myusername == TRUE) {
      
      if (dateonly == TRUE) {
        
        datestampr <- paste0(year,month,day,username)
        
      } else if (houronly == TRUE) {
        
        datestampr <- paste0(year,month,day,hour,username)
        
      } else if (minuteonly == TRUE) {
        
        datestampr <- paste0(year,month,day,hour,minute,username)
        
      } else {
        
        datestampr <- paste0(year,month,day,hour,minute,second,username)
        
      }
      
    } else {
      
      if (dateonly == TRUE) {
        
        datestampr <- paste0(year,month,day)
        
      } else if (houronly == TRUE) {
        
        datestampr <- paste0(year,month,day,hour)
        
      } else if (minuteonly == TRUE) {
        
        datestampr <- paste0(year,month,day,hour,minute)
        
      } else {
        
        datestampr <- paste0(year,month,day,hour,minute,second)
        
      }
      
    }
    
    return(datestampr)
    
  }
  

  keepr <- function(mydf,...) {
    
    my_return_name <- deparse(substitute(mydf))
    
    myinitialsize <- round(object.size(mydf)/1000000, digits = 3)
    cat(paste0("Size of ", my_return_name, " before removing variables: ", myinitialsize, " MB. \n"))
    
    names_to_keep <- c(...)
    mytext <- paste("The following variables will be kept from ", my_return_name, ": ", sep = "")
    print(mytext)
    print(names_to_keep)
    mydf <- mydf[,names(mydf) %in% names_to_keep]
    
    myfinalsize <- round(object.size(mydf)/1000000, digits = 3)
    cat(paste0("Size of ", my_return_name, " after removing variables: ", myfinalsize, " MB. \n"))
    ramsaved <- round(myinitialsize - myfinalsize, digits = 3)
    cat(paste0("RAM saved: ", ramsaved, " MB. \n"))
    
    return(mydf)
    
  }
  
  
  
  if (logrun==TRUE) {
    
    datestring <- datestampr(myusername=TRUE)
    mylogfilename <- paste0("CompareFaresStr_", mybaufolder, "_vs_", mydsfolder, "_", datestring,".txt")
    sink()
    sink(mylogfilename, split=TRUE)
    cat(yellow(paste0("A log of the output will be saved to ", mylogfilename, ". \n \n")))
    
  }  
  
  
  # Work
  
  setwd(mybaufolder)
  setwd("updated_output")

  mybaufilename <- "trips.rds"
  trips_bau <- readRDS(mybaufilename)
  nrow_trips_bau <- nrow(trips_bau)
  cat(yellow(paste0("In the folder ", mybaufolder, ", the file ", mybaufilename, " has ", nrow_trips_bau, " records. \n \n")))
  
  mydf_bau <- keepr(trips_bau, "hh_id", "person_id", "tour_id", "stop_id", "orig_taz", "dest_taz", "skims_mode", "fare")
  
  mydf_bau <- mydf_bau %>% 
    filter(skims_mode!="walk" & skims_mode!="bike" & skims_mode!="da" & skims_mode!="s2" & skims_mode!="s3" & skims_mode!="Taxi" & skims_mode!="TNCa" & skims_mode!="TNCs")
  
  nrow_transit_trips_bau <- nrow(mydf_bau)
  cat(yellow(paste0("The file ", mybaufilename, " has ", nrow_transit_trips_bau, " records of transit trips. \n \n")))
  
  setwd("../..")
  
  setwd(mydsfolder)
  setwd("updated_output")  
  
  mydsfilename <- "trips.rds"
  trips <- readRDS(mydsfilename)
  nrow_trips_ds <- nrow(trips)
  cat(yellow(paste0("In the folder ", mydsfolder, ", the file ", mydsfilename, " has ", nrow_trips_ds, " records. \n \n")))
  
  mydf_ds <- keepr(trips, "hh_id", "person_id", "tour_id", "stop_id", "orig_taz", "dest_taz", "skims_mode", "fare")
  
  mydf_ds <- mydf_ds %>% 
    filter(skims_mode!="walk" & skims_mode!="bike" & skims_mode!="da" & skims_mode!="s2" & skims_mode!="s3" & skims_mode!="Taxi" & skims_mode!="TNCa" & skims_mode!="TNCs")
  
  nrow_transit_trips_ds <- nrow(mydf_ds)
  cat(yellow(paste0("The file ", mydsfilename, " has ", nrow_transit_trips_ds, " records of transit trips. \n \n")))
  
  mydf_compare <- mydf_bau %>% full_join(mydf_ds, by=c("hh_id", "person_id", "tour_id", "stop_id", "orig_taz", "dest_taz", "skims_mode"), suffix=c("1", "2"))
  
  nrow_mydf_compare <- nrow(mydf_compare)
  cat(yellow(paste0("The table produced by the full join of the transit trips in  ", mybaufilename, " and ", mydsfilename, " has ", nrow_mydf_compare, " records. \n \n")))
  
  mydf_compare <- mydf_compare %>%
    mutate(fares_change_pcnt = (fare2/fare1) -1) %>%
    mutate(fares_change_diff = (fare2-fare1))
  
  mydf_compare_mm <- mydf_compare %>%
    filter(is.na(fare1) | is.na(fare2))
  
  mydf_compare_max1m <- head(mydf_compare, n=1000000)
  
  nrow_mydf_compare_mm <- nrow(mydf_compare_mm)
  cat(yellow(paste0("There are ", nrow_mydf_compare_mm, " mismatched records, transit trips which exist in one but not the other file. \n \n")))
  
  dataframelist <- c("mydf_bau", "mydf_ds", "mydf_compare", "mydf_compare_mm")
  nrows <- c(nrow_transit_trips_bau, nrow_transit_trips_ds, nrow_trips_compare, nrow_mydf_compare_mm)
  dataframe_nrows <- data.frame(dataframelist, nrows)
  
  check <- as.data.frame(table(mydf_compare$fares_change_pcnt))
  
  check <- check %>%
    rename(fares_change_pcnt = Var1)
  
  check
  
  setwd("../..")
  
  # create output workbook
  wb <- createWorkbook()
  
  # export the resulting tables to Excel

  sheetname <- "dataframe_nrows"
  addWorksheet(wb, sheetname)
  writeData(wb, sheetname, dataframe_nrows)
    
  sheetname <- "check"
  addWorksheet(wb, sheetname)
  writeData(wb, sheetname, check)
  
  sheetname <- "mydf_compare_max1m"
  addWorksheet(wb, sheetname)
  writeData(wb, sheetname, mydf_compare_max1m)
  
  sheetname <- "mydf_compare_mm"
  addWorksheet(wb, sheetname)
  writeData(wb, sheetname, mydf_compare_mm)  
  
  # Save the workbook
  
  filename <- paste0("CompareFaresStr_", mybaufolder, "_vs_", mydsfolder, "_", datestring, ".xlsx")
  saveWorkbook(wb, file = filename, overwrite = TRUE)  
  
  # report and finish
  
  now2 <- Sys.time()
  cat(yellow(paste0("CompareFaresStr run finished at ", now2, "\n \n")))
  elapsed_time <- now2 - now1
  print(elapsed_time)	
  
  if (logrun==TRUE) {
    sink()
    cat(yellow(paste0("A log of the output has been saved to ", mylogfilename, ". \n \n")))
  }	
  
  print(gc())
  
  
  
}

#
