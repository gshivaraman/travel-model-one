CoreSummariesStr <- function(myscenarioid) {

  # Version 1 01 by Alex Mitrani, based on CoreSummaries.R by MTC staff, updated on 21 July 2021.  This function takes time and cost variables from the CSV files corresponding to the detailed skims and joins them on to the trips .rdata file.  
  
  # Example of use:
  # CoreSummariesStr(myscenarioid = "20210627171152")


	# Core Summaries

	# Overhead
	## Initialization: Set the workspace and load needed libraries
	.libPaths(Sys.getenv("R_LIB"))

	library(tidyverse)
	library(readxl)
	library(openxlsx)
	
	mywd <- getwd()
	mypathfile <- paste0(mywd, "/", myscenarioid, "/OUTPUT/updated_output/trips.rdata")
	
	# Overhead
	## Lookups

	# For time periods, see https://github.com/BayAreaMetro/modeling-website/wiki/TimePeriods
	# For counties, see https://github.com/BayAreaMetro/modeling-website/wiki/TazData
	# For walk_subzones, see https://github.com/BayAreaMetro/modeling-website/wiki/Household

	######### time periods
	LOOKUP_TIMEPERIOD    <- data.frame(timeCodeNum=c(1,2,3,4,5),
									   timeperiod_label=c("Early AM","AM Peak","Midday","PM Peak","Evening"),
									   timeperiod_abbrev=c("EA","AM","MD","PM","EV"))
	# no factors -- joins don't work
	LOOKUP_TIMEPERIOD$timeCodeNum       <- as.integer(LOOKUP_TIMEPERIOD$timeCodeNum)
	LOOKUP_TIMEPERIOD$timeperiod_label  <- as.character(LOOKUP_TIMEPERIOD$timeperiod_label)
	LOOKUP_TIMEPERIOD$timeperiod_abbrev <- as.character(LOOKUP_TIMEPERIOD$timeperiod_abbrev)

	
	
	## Load main data file
  
	load(mypathfile)
  
	names(trips)
	
	## Set means-based cost factors
	MBT_Q1_factor <- 1.0
	MBT_Q2_factor <- 1.0
	MBF_Q1_factor <- 1.0
	MBF_Q2_factor <- 1.0
	
	

	## Function to add Cost to Tours or Trips

	# Function `add_cost`: attaches the cost skims for the given time period abbreviation `this_timeperiod`
	# to the given tours data.frame (note: this can be the trips data frame). Joining is done on the columns
	# `orig_taz`, `dest_taz`, and `timeCode`.

	# The function fills in values to the column `cost` and `cost_fail` for the given time
	# period based on the column `costMode`.

	# Pass `reverse_od` as TRUE to do return trip; this uses the dest taz as the origin and the origin
	# taz as the dest, and it uses wTrnD cost rather than dTrnW.

	# Tallies failed costs (expected cost but -999 found) in the field cost_fail

	add_cost <- function(this_timeperiod, input_trips_or_tours, reverse_od = FALSE) {

	  # separate the relevant and irrelevant tours/trips
	  relevant <- input_trips_or_tours %>%
		filter(timeCode == this_timeperiod)

	  irrelevant <- input_trips_or_tours %>%
		filter(timeCode != this_timeperiod)

	  # read in the relevant skim
	  skim_file <- file.path(TARGET_DIR,"database",paste0("CostSkimsDatabase",this_timeperiod,".csv"))
	  costSkims <- read.table(file = skim_file, header=TRUE, sep=",")

	  # standardize column names, reversing if needed
	  if (reverse_od) {
		costSkims <- costSkims %>%
		  rename(orig_taz = dest, dest_taz = orig)
	  } else {
		  costSkims <- costSkims %>%
			rename(orig_taz = orig, dest_taz = dest)
	  }

	  # Left join tours to the skims
	  relevant <- left_join(relevant, costSkims, by=c("orig_taz","dest_taz"))

	  # assign cost value if we can to new column cost2
	  relevant <- relevant %>%
		mutate(cost2 = (costMode == 1) * da +
				 (costMode == 2 & incQ == 1) * daToll * MBT_Q1_factor + (costMode == 2 & incQ == 2) * daToll * MBT_Q2_factor + (costMode == 2 & incQ >= 3) * daToll +
				 (costMode == 3) * s2 +
				 (costMode == 4 & incQ == 1) * s2Toll * MBT_Q1_factor + (costMode == 4 & incQ == 2) * s2Toll * MBT_Q2_factor + (costMode == 4 & incQ >= 3) * s2Toll +
				 (costMode == 5) * s3 +
				 (costMode == 6 & incQ == 1) * s3Toll* MBT_Q1_factor + (costMode == 6 & incQ == 2) * s3Toll* MBT_Q2_factor + (costMode == 6 & incQ >= 3) * s3Toll +
				 (costMode == 7) * 0.0 +
				 (costMode == 8) * 0.0 +
				 (costMode == 9 & incQ == 1) * wTrnW * MBF_Q1_factor + (costMode == 9 & incQ == 2) * wTrnW * MBF_Q2_factor + (costMode == 9 & incQ >= 3) * wTrnW +
				 (costMode == 10 & incQ == 1) * (1 - reverse_od) * dTrnW * MBF_Q1_factor + (costMode == 10 & incQ == 2) * (1 - reverse_od) * dTrnW * MBF_Q2_factor + (costMode == 10 & incQ >= 3) * (1 - reverse_od) * dTrnW +
				 (costMode == 10 & incQ == 1) * (reverse_od) * wTrnD * MBF_Q1_factor + (costMode == 10 & incQ == 2) * (reverse_od) * wTrnD * MBF_Q2_factor + (costMode == 10 & incQ >= 3) * (reverse_od) * wTrnD +
				 (costMode == 11 & incQ == 1) * wTrnD * MBF_Q1_factor + (costMode == 11 & incQ == 2) * wTrnD * MBF_Q2_factor + (costMode == 11 & incQ >= 3) * wTrnD)


	  # re-code missing as zero and set a failure indicator
	  relevant <- relevant %>%
		mutate(cost2 = ifelse(cost2 < -990, 0, cost2)) %>%
		mutate(cost_fail2 = ifelse(cost2 < -990 ,1 ,0))

	  print(paste("For",
				  this_timeperiod,
				  "assigned",
				  prettyNum(sum(!is.na(relevant$cost2)),big.mark=","),
				  "costs, with",
				  prettyNum(sum(!is.na(relevant$cost2)&(relevant$cost2>0)),big.mark=","),
				  "nonzero values"))

	  # re-code na as zero
	  relevant$cost2[is.na(relevant$cost2)]           <- 0
	  relevant$cost_fail2[is.na(relevant$cost_fail2)] <- 0

	  # set the cost variable
	  relevant <- relevant %>%
		mutate(cost = cost + cost2) %>%
		mutate(cost_fail = cost_fail + cost_fail2)

	  print(paste("  -> total nonzero costs:",
				  prettyNum(sum(relevant$cost!=0),big.mark=",")))

	  # clean-up
	  relevant <- relevant %>%
		select(-da, -daToll, -s2, -s2Toll, -s3, -s3Toll, -wTrnW, -dTrnW, -wTrnD, -cost2, -cost_fail2)

	  return_list <- rbind(relevant, irrelevant)

	  return(return_list)

	}

	## Function to add Distance to Tours or Trips

	# Function `add_distance`: attaches the distance skims the given time period abbreviation `this_timeperiod`
	# to the given tours data frame (note: this can be the trips data frame). Joining is done on the columns
	# `orig_taz`, `dest_taz`, and `timeCode`. The function fills in values to the column `distance` for the given
	# time period based on the column `distance_mode`.

	add_distance <- function(this_timeperiod, input_trips_or_tours) {

	  # separate the relevant and irrelevant tours/trips
	  relevant <- input_trips_or_tours %>%
		filter(timeCode == this_timeperiod)

	  irrelevant <- input_trips_or_tours %>%
		filter(timeCode != this_timeperiod)

	  # Read the relevant skim table
	  skim_file <- file.path(TARGET_DIR,"database",paste0("DistanceSkimsDatabase",this_timeperiod,".csv"))
	  distSkims <- read.table(file = skim_file, header=TRUE, sep=",")

	  # rename columns for join
	  distSkims <- distSkims %>%
		rename(orig_taz = orig, dest_taz = dest)

	  # Left join tours to the skims
	  relevant <- left_join(relevant, distSkims, by=c("orig_taz","dest_taz"))

	  # Assign distance value
	  relevant <- relevant %>%
		mutate(distance2 = 0.0)

	  relevant <- relevant %>%
		mutate(distance2 = (distance_mode == 1) * da +
				 (distance_mode == 2) * daToll +
				 (distance_mode == 3) * s2     +
				 (distance_mode == 4) * s2Toll +
				 (distance_mode == 5) * s3     +
				 (distance_mode == 6) * s3Toll +
				 (distance_mode == 7) * walk   +
				 (distance_mode == 8) * bike   +
				 (distance_mode >= 9) * pmin(da, daToll))


	  relevant <- relevant %>%
		mutate(distance2 = ifelse(distance2 < -990.0, 0, distance2))

	  print(paste("For",
				  this_timeperiod,
				  "assigned",
				  prettyNum(sum(!is.na(relevant$distance2)),big.mark=","),
				  "distances, with",
				  prettyNum(sum(!is.na(relevant$distance2)&(relevant$distance2>0)),big.mark=","),
				  "nonzero values"))

	  relevant$distance2[is.na(relevant$distance2)] <- 0

	  relevant <- relevant %>%
		mutate(distance = distance + distance2)

	  print(paste("  -> total nonzero distances:",prettyNum(sum(relevant$distance!=0),big.mark=",")))

	  relevant <- relevant %>%
		select(-da, -daToll, -s2, -s2Toll, -s3, -s3Toll, -walk, -bike, -distance2)

	  return_list <- rbind(relevant, irrelevant)

	  return(return_list)
	}

	## Function to add Time to Tours or Trips

	# Function `add_time`: attaches the time skims for the given time period `this_timeperiod`
	# to the given tours data.frame (note: this can be the trips data frame).  Joining is done on the
	# columns `orig_taz`, `dest_taz`, and `timeCode`.
	#
	# Fills in values to the column `time` for the given time period based on the column `costMode`.
	#
	# Pass `reverse_od` as TRUE to do return trip; this uses the dest taz as the origin and the origin
	# taz as the dest, and it uses wTrnD time rather than dTrnW.
	#
	# Tallies failed times (expected time but -999 found) in the field `time_fail`.

	add_time <- function(this_timeperiod, input_trips_or_tours, reverse_od=FALSE) {

	  # separate the relevant and irrelevant tours/trips
	  relevant <- input_trips_or_tours %>%
		filter(timeCode == this_timeperiod)

	  irrelevant <- input_trips_or_tours %>%
		filter(timeCode != this_timeperiod)

	  # read in the relevant skim
	  skim_file <- file.path(TARGET_DIR,"database", paste0("TimeSkimsDatabase", this_timeperiod,".csv"))
	  timeSkims   <- read.table(file = skim_file, header = TRUE, sep = ",")

	  # standardize column names, reversing if needed
	  if (reverse_od) {
		timeSkims <- timeSkims %>%
		  rename(orig_taz = dest, dest_taz = orig)
	  } else {
		timeSkims <- timeSkims %>%
		  rename(orig_taz = orig, dest_taz = dest)
	  }


	  # join the skims and relevant trips/tours
	  relevant <- left_join(relevant, timeSkims, by=c("orig_taz","dest_taz"))

	  # assign the new time
	  relevant <- relevant %>%
		mutate(time2 = (costMode == 1) * da +
				 (costMode == 2) * daToll +
				 (costMode == 3) * s2 +
				 (costMode == 4) * s2Toll +
				 (costMode == 5) * s3 +
				 (costMode == 6) * s3Toll +
				 (costMode == 7) * walk +
				 (costMode == 8) * bike +
				 (costMode == 9) * wTrnW +
				 (costMode == 10) * (1 - reverse_od) * dTrnW +
				 (costMode == 10) * (reverse_od) * wTrnD)

	  # re-code missing as zero and set a failure indicator
	  relevant <- relevant %>%
		mutate(time2 = ifelse(time2 < -990, 0, time2)) %>%
		mutate(time_fail2 = ifelse(time2 < -990 ,1 ,0))

	  print(paste("For",
				  this_timeperiod,
				  "assigned",
				  prettyNum(sum(!is.na(relevant$time2)),big.mark=","),
				  "times, with",
				  prettyNum(sum(!is.na(relevant$time2)&(relevant$time2>0)),big.mark=","),
				  "nonzero values"))

	  # re-code na as zero
	  relevant$time2[is.na(relevant$time2)] <- 0
	  relevant$time2[is.na(relevant$time_fail2)] <- 0

	  # set the time variable
	  relevant <- relevant %>%
		mutate(time = time + time2) %>%
		mutate(time_fail = time_fail + time_fail2)

	  print(paste("  -> total nonzero times:",prettyNum(sum(relevant$time!=0),big.mark=",")))

	  relevant <- relevant %>%
		select(-da, -daToll, -s2, -s2Toll, -s3, -s3Toll, -walk, -bike, -wTrnW, -dTrnW, -wTrnD, -time2, -time_fail2)

	  return_list <- rbind(relevant, irrelevant)

	  return(return_list)
	}


	## Function to add Active travel time to tours

	# Function `add_active`: attaches the active skims of the given time period `this_timeperiod`
	# to the given trip data.frame (joining on the columns `orig_taz`, `dest_taz`, and `timeCode`).
	#
	# Fills in values to the column `active` for the given time period.

	add_active <- function(this_timeperiod, input_trips_or_tours) {

	  # separate the relevant and irrelevant tours/trips
	  relevant <- input_trips_or_tours %>%
		filter(timeCode == this_timeperiod)

	  irrelevant <- input_trips_or_tours %>%
		filter(timeCode != this_timeperiod)

	  # read in the relevant skim
	  skim_file <- file.path(TARGET_DIR,"database", paste0("ActiveTimeSkimsDatabase", this_timeperiod,".csv"))
	  activeSkims <- read.table(file = skim_file,header=TRUE, sep=",")

	  # standarize column names
	  activeSkims <- activeSkims %>%
		rename(orig_taz = orig, dest_taz = dest)

	  # left join the skims
	  relevant <- left_join(relevant, activeSkims, by=c("orig_taz","dest_taz"))

	  # assign active2
	  relevant <- relevant %>%
		mutate(active2 = (amode == 1) * walk +
				 (amode == 2) * bike +
				 (amode == 3) * wTrnW +
				 (amode == 4) * dTrnW +
				 (amode == 5) * wTrnD)

	  relevant <- relevant %>%
		mutate(active2 = ifelse(active2 < -990.0, 0, active2))

	  print(paste("For",
				  this_timeperiod,
				  "assigned",
				  prettyNum(sum(!is.na(relevant$active2)),big.mark=","),
				  "active times, with",
				  prettyNum(sum(!is.na(relevant$active2)&(relevant$active2>0)),big.mark=","),
				  "nonzero values"))

	  relevant$active2[is.na(relevant$active2)] <- 0

	  relevant <- relevant %>%
		mutate(active = active + active2)

	  print(paste("  -> total nonzero active times:",
				  prettyNum(sum(relevant$active!=0),big.mark=",")))

	  relevant <- relevant %>%
		select(-walk, -bike, -wTrnW, -dTrnW, -wTrnD, -active2)

	  return_list <- rbind(relevant, irrelevant)

	  return(return_list)
	}


	## Add Trip Distance to Trips

	# Use `add_distance` to add trip distance to trips.
	trips <- mutate(trips,
					distance=0.0,
					distance_mode=trip_mode) # use trip_mode for distance

	for (timeperiod in LOOKUP_TIMEPERIOD$timeperiod_abbrev) {
	  trips <- add_distance(timeperiod, trips)
	}
	trips <- tbl_df(trips)
	trips <- select(trips, -distance_mode)

	num_tours       <- nrow(tours)
	num_tours_dist  <- nrow( distinct(tours, hh_id, tour_participants, tour_id))
	print(paste("num_tours",      prettyNum(num_tours,big.mark=",")))
	print(paste("num_tours_dist", prettyNum(num_tours_dist,big.mark=",")))

	## Add Tour Duration to Trips
	print(paste("Before adding tour duration to trips -- have",prettyNum(nrow(trips),big.mark=","),"rows"))
	# this will only work for individual tours since person_id is set
	trips <- left_join(trips, select(tours, hh_id, tour_participants, tour_id, duration), by=c("hh_id", "tour_participants", "tour_id")) %>% 
	  rename(tour_duration=duration)
	print(paste("After adding tour duration to trips -- have",prettyNum(nrow(trips),big.mark=","),"rows"))

	## Add Active Travel time to Trips

	print("Adding active mode to trips")
	# code the Active Mode
	trips <- trips %>%
	  mutate(amode = 0) %>%
	  mutate(amode = ifelse(trip_mode == 7, 1, amode)) %>%
	  mutate(amode = ifelse(trip_mode == 8, 2, amode)) %>%
	  mutate(amode = ifelse((trip_mode >= 9) & (trip_mode <= 13), 3, amode)) %>%
	  mutate(amode = ifelse((trip_mode >= 14) & (trip_mode <= 18) & (orig_purpose == 'Home'), 4, amode)) %>%
	  mutate(amode = ifelse((trip_mode >= 14) & (trip_mode <= 18) & (dest_purpose == 'Home'), 5, amode)) %>%
	  mutate(wlk_trip = ifelse(amode == 1, 1, 0)) %>%
	  mutate(bik_trip = ifelse(amode == 2, 1, 0)) %>%
	  mutate(wtr_trip = ifelse(amode == 3, 1, 0)) %>%
	  mutate(dtr_trip = ifelse(amode == 4, 1, 0)) %>%
	  mutate(dtr_trip = ifelse(amode == 5, 1 + amode, 0)) %>%
	  mutate(active = 0.0)

	# go go gadget: Add active transportation time to trips
	for (timeperiod in LOOKUP_TIMEPERIOD$timeperiod_abbrev) {
	  trips <- add_active(timeperiod, trips)
	}
	trips <- tbl_df(trips)

	## Add Travel Cost and Travel Time to Trips
	print("Adding active travel cost and time to trips")
	trips <- trips %>%
	  mutate(costMode = 0) %>%
	  mutate(costMode = ifelse(trip_mode <= 8, trip_mode, costMode)) %>%
	  mutate(costMode = ifelse((trip_mode >= 9) & (trip_mode <=13), 9, costMode)) %>%
	  mutate(costMode = ifelse((trip_mode >= 14) & (trip_mode <=18) & (orig_purpose == 'Home'), 10, costMode)) %>%
	  mutate(costMode = ifelse((trip_mode >= 14) & (trip_mode <=18) & (dest_purpose == 'Home'), 11, costMode)) %>%
	  mutate(cost = 0) %>%
	  mutate(cost_fail = 0) %>%
	  mutate(time = 0) %>%
	  mutate(time_fail = 0)

	for (timeperiod in LOOKUP_TIMEPERIOD$timeperiod_abbrev) {
	  trips <- add_cost(timeperiod, trips)
	  trips <- add_time(timeperiod, trips)
	}
	trips <- tbl_df(trips)
	
}
