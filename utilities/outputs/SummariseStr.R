SummariseStr <- function(sampleshare=0.5, pnrparkingcost=2.0, logrun=FALSE) {

  
  library(tidyverse)
  library(openxlsx)
  library(crayon)
  
  # The default value of pnrparking cost is USD 2.0 (2000 prices).  BART parking costs approximately USD 3 is 2021.  
  # $3 adjusted for inflation 2020 - 2000 gives approximately $2 in 2000 prices.  
  # Source for inflation data: https://www.bls.gov/data/inflation_calculator.htm
  
  # report start of process and time
  
  now1 <- Sys.time()
  cat(yellow(paste0("SummariseStr run started at ", now1, "\n \n")))  
  
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
  
  
  StrLabeller <- function(mydf, ...) {
    
    # examples
    # mydf <- StrLabeller(mydf = mydf, myvar = "trip_mode")    
    
    vars_to_label <- c(...)
    
    for (myvar in vars_to_label) {
      
      myvarname <- substitute(myvar)
      
      if (myvarname=="trip_mode") {
        
        mydf$trip_mode <- factor(mydf$trip_mode, levels = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21), labels = c("Drive alone (single-occupant vehicles), not eligibile to use value toll facilities","Drive alone (single-occupant), eligible to use value toll facilities","Shared ride 2 (two-occupant vehicles), not eligibile to use value toll facilities","Shared ride 2 (two-occupant vehicles), eligible to use value toll facilities","Shared ride 3+ (three-or-more-occupant vehicles), not eligibile to use value toll facilities","Shared ride 3+ (three-of-more occupant vehicles), eligible to use value toll facilities","Walk the entire way (no transit, no bicycle)","Bicycle the entire way (no transit)","Walk to local bus","Walk to light rail or ferry","Walk to express bus","Walk to heavy rail","Walk to commuter rail","Drive to local bus","Drive to light rail or ferry","Drive to express bus","Drive to heavy rail","Drive to commuter rail","Taxi (added in Travel Model 1.5)","TNC (Transportation Network Company, or ride-hailing services) - Single party (added in Travel Model 1.5)","TNC - Shared e.g. sharing with strangers (added in Travel Model 1.5)"))
        
      }
      
    }
    
    return(mydf)
    
  }
  
  if (logrun==TRUE) {
    
    datestring <- datestampr(myusername=TRUE)
    mylogfilename <- paste0("SummariseStr_", datestring,".txt")
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
  
  
  # trips, revenue, and average fare by mode
  
  trips <- readRDS(file=file.path(UPDATED_DIR, "trips.rds"))
  
  # report the available variables
  cat(yellow(paste0("The following variables are available: \n \n")))  
  print(names(trips))
  cat((paste0("\n \n")))  
  
  # reduce the data in memory to the required variables
  
  mydf <- keepr(mydf = trips, "trip_mode", "num_participants", "walktime", "wait", "IVT", "transfers", "fare", "othercost", "distance")
  
  remove(trips)
  
  print(gc())
  
  # convert monetary variables from cents to dollars
  
  mydf <- mydf %>%
    mutate(fare=fare/100) %>% 
    mutate(othercost=othercost/100)
  
  # calculate the numbers of trips taking into account the sample share
  
  mydf <- mydf %>% 
    mutate(trips=num_participants/sampleshare)
  
  # should also add assumed cost per unit distance of auto access for PNR options, but the data to do it is not available at present.  
  
  # divide pnr parking cot by 2 to get it per direction for comparability with transit fares
  pnrparkingcostperdirection <- pnrparkingcost/2
  
  # add assumed PNR parking cost to other costs
  mydf <- mydf %>% 
    mutate(othercost=ifelse(trip_mode>=14 & trip_mode<=18, othercost + pnrparkingcostperdirection, othercost))
  
  # adjust other costs to be per person for consistency with transit costs
  mydf <- mydf %>% 
    mutate(othercost=othercost/num_participants)
  
  # weight the variables by trips so that they can be aggregated
  
  mydf <- mydf %>%   
    mutate(num_participants = trips*num_participants) %>%
    mutate(walkmins = trips * walktime) %>%
    mutate(waitmins = trips * wait) %>%
    mutate(ivtmins = trips * IVT) %>%
    mutate(transfers = trips * transfers) %>%
    mutate(revenue = trips * fare) %>%
    mutate(othercost = trips * othercost) %>%
    mutate(distance = trips * distance)
     
  # aggregate  
  
  trip_mode <- mydf %>% 
    group_by(trip_mode) %>%
    summarise(num_participants=sum(num_participants), trips=sum(trips), walkmins = sum(walkmins), waitmins = sum(waitmins), ivtmins = sum(ivtmins), transfers = sum(transfers), revenue=sum(revenue), othercost = sum(othercost), distance = sum(distance)) %>%
    ungroup()
  
  # average
  
  trip_mode <- trip_mode %>%
    mutate(num_participants = num_participants / trips) %>%
    mutate(walkmins = walkmins / trips) %>%
    mutate(waitmins = waitmins / trips) %>%
    mutate(ivtmins = ivtmins / trips) %>%
    mutate(transfers = transfers / trips) %>%
    mutate(fare = revenue / trips) %>%
    mutate(othercost = othercost / trips) %>%
    mutate(distance = distance / trips)
  
  # tidy up - put the columns in the desired order
  
  trip_mode <- trip_mode %>%
    select(trip_mode, num_participants, trips, revenue, fare, othercost, distance, walkmins, waitmins, ivtmins, transfers)
  
  # apply labels to the category variable
    
  trip_mode <- StrLabeller(trip_mode, "trip_mode")
  
  # export the resulting table to Excel
  
  wb <- createWorkbook()
  sheetname <- "trip_mode"
  addWorksheet(wb, sheetname)
  writeData(wb, sheetname, trip_mode)
  filename <- paste0("SummariseStr_", datestring,".xlsx")
  saveWorkbook(wb, file = filename, overwrite = TRUE)
  
  # report and finish
  
  now2 <- Sys.time()
  cat(yellow(paste0("SummariseStr run finished at ", now2, "\n \n")))
  elapsed_time <- now2 - now1
  print(elapsed_time)	
  
  if (logrun==TRUE) {
    sink()
    cat(yellow(paste0("A log of the output has been saved to ", mylogfilename, ". \n \n")))
  }	
  
  print(gc())

}






