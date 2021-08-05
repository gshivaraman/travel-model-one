WorkbookStr <- function(sampleshare=0.5, pnrparkingcost=2.0, logrun=TRUE) {
  
  # The default value of pnrparking cost is USD 2.0 (2000 prices).  BART parking costs approximately USD 3 is 2021.  
  # $3 adjusted for inflation 2020 - 2000 gives approximately $2 in 2000 prices.  
  # Source for inflation data: https://www.bls.gov/data/inflation_calculator.htm
  
  library(tidyverse)
  library(openxlsx)
  library(crayon)
  
  # report start of process and time
  
  now1 <- Sys.time()
  cat(yellow(paste0("WorkbookStr run started at ", now1, "\n \n")))  
  
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
  
  dropr <- function(mydf,...) {
    
    my_return_name <- deparse(substitute(mydf))
    
    myinitialsize <- round(object.size(mydf)/1000000, digits = 3)
    cat(paste0("Size of ", my_return_name, " before removing variables: ", myinitialsize, " MB. \n"))
    
    names_to_drop <- c(...)
    mytext <- paste("The following variables will be dropped from ", my_return_name, ": ", sep = "")
    print(mytext)
    print(names_to_drop)
    mydf <- mydf[,!names(mydf) %in% names_to_drop]
    
    myfinalsize <- round(object.size(mydf)/1000000, digits = 3)
    cat(paste0("Size of ", my_return_name, " after removing variables: ", myfinalsize, " MB. \n"))
    ramsaved <- round(myinitialsize - myfinalsize, digits = 3)
    cat(paste0("RAM saved: ", ramsaved, " MB. \n"))
    
    return(mydf)
    
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
    mylogfilename <- paste0("WorkbookStr_", datestring,".txt")
    sink()
    sink(mylogfilename, split=TRUE)
    cat(yellow(paste0("A log of the output will be saved to ", mylogfilename, ". \n \n")))
    
  }  
  
  # Work --------------------------------------------------------------------
  
  mywd <- getwd()
  
  # For RStudio, these can be set in the .Rprofile
  TARGET_DIR   <- mywd  		# The location of the input files
  SAMPLESHARE  <- sampleshare # Sampling
  
  TARGET_DIR   <- gsub("\\\\","/",TARGET_DIR) # switch slashes around
  
  stopifnot(nchar(TARGET_DIR  )>0)
  stopifnot(nchar(SAMPLESHARE )>0)
  
  MAIN_DIR    <- file.path(TARGET_DIR,"main"           )
  RESULTS_DIR <- file.path(TARGET_DIR,"core_summaries")
  UPDATED_DIR <- file.path(TARGET_DIR,"updated_output")
  
  mydf1 <- SummariseStr(sampleshare=sampleshare, pnrparkingcost=pnrparkingcost, logrun=logrun, catvarslist = c("trip_mode"), sumvarslist=c("num_participants", "walktime", "wait", "IVT", "transfers", "fare", "othercost", "distance"))
  
  browser()
  
  sheetname1 <- "trip_mode"
  
  # create output workbook
  wb <- createWorkbook()
  
  # export the resulting tables to Excel
  
  
  sheetname <- sheetname1
  addWorksheet(wb, sheetname)
  writeData(wb, sheetname, mydf1)
  filename <- paste0("WorkbookStr_", datestring,".xlsx")
  saveWorkbook(wb, file = filename, overwrite = TRUE)
  
  # report and finish
  
  now2 <- Sys.time()
  cat(yellow(paste0("WorkbookStr run finished at ", now2, "\n \n")))
  elapsed_time <- now2 - now1
  print(elapsed_time)	
  
  if (logrun==TRUE) {
    sink()
    cat(yellow(paste0("A log of the output has been saved to ", mylogfilename, ". \n \n")))
  }	
  
  print(gc())
  
}
