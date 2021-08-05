SummariseStr <- function(sampleshare=0.5, pnrparkingcost=2.0, logrun=FALSE, catvarslist=c("orig_taz", "dest_taz", "home_taz", "trip_mode", "incQ", "timeCode", "ptype"), sumvarslist=c("num_participants", "walktime", "wait", "IVT", "transfers", "fare", "othercost", "distance", "dFree", "dInterCity", "dLocal", "dRegional", "ddist", "dFareMat")) {

  
  library(tidyverse)
  library(openxlsx)
  library(crayon)
  
  # Example of use
  # SummariseStr(sampleshare=0.5, pnrparkingcost=2.0, logrun=TRUE, catvarslist = c("trip_mode"), sumvarslist=c("num_participants", "walktime", "wait", "IVT", "transfers", "fare", "othercost", "distance"))
  
  
  # The default value of pnrparking cost is USD 2.0 (2000 prices).  BART parking costs approximately USD 3 is 2021.  
  # $3 adjusted for inflation 2020 - 2000 gives approximately $2 in 2000 prices.  
  # Source for inflation data: https://www.bls.gov/data/inflation_calculator.htm
  

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
  
  # define list of variables
  myvarlist <- c(catvarslist, sumvarslist)
  
  # reduce the data in memory to the required variables
  
  
  
  # mydf <- keepr(mydf = trips, "num_participants", "walktime", "wait", "IVT", "transfers", "fare", "othercost", "distance")
  mydf <- keepr(mydf = trips, myvarlist)
  
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
  
  # weight the variables to be summarised by trips so that they can be aggregated
  
  mydf <- mydf %>% 
    mutate(across(sumvarslist, ~ .x*trips))

  # aggregate  
  
  mysumvarslist <- c(c("trips"), sumvarslist)
  
  mydf <- mydf %>% 
    group_by(catvarslist) %>%
    summarise(across=mysumvarslist, sum) %>%
    ungroup()
  
  # average
  
  mydf <- mydf %>%
    mutate(across(sumvarslist),  ~ .x/trips)
  
  # tidy up - put the columns in the desired order
  
  myvarslist <- c(catvarslist, mysumvarslist)
  
  mydf <- mydf %>%
    select(myvarslist)
  
  # apply labels to the category variables
  
  for(myvar in catvarslist) {
  
    mydf <- StrLabeller(mydf, myvar)
  
  }

  return(mydf)
  
  print(gc())

}






