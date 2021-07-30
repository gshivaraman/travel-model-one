

# Starting position in directory structure: 
# "C:\Users\amitrani\Documents\Bay Area Fares\2015_TM152_STR_T7\"
# "C:\Users\amitrani\Documents\Bay Area Fares\2015_TM152_STR_T7\20210729_to_test_CoreSummariesStr.R"
# "C:\Users\amitrani\Documents\Bay Area Fares\2015_TM152_STR_T7\CoreSummariesStr.R"

# Available subfolders:
# "C:\Users\amitrani\Documents\Bay Area Fares\2015_TM152_STR_T7\updated_output"
# "C:\Users\amitrani\Documents\Bay Area Fares\2015_TM152_STR_T7\database"
# "C:\Users\amitrani\Documents\Bay Area Fares\2015_TM152_STR_T7\core_summaries"
# "C:\Users\amitrani\Documents\Bay Area Fares\2015_TM152_STR_T7\main"
# "C:\Users\amitrani\Documents\Bay Area Fares\2015_TM152_STR_T7\popsyn"
# "C:\Users\amitrani\Documents\Bay Area Fares\2015_TM152_STR_T7\landuse"
# "C:\Users\amitrani\Documents\Bay Area Fares\2015_TM152_STR_T7\CTRAMP"

source('CoreSummariesStr.R', encoding = 'UTF-8')
trips <- CoreSummariesStr(fullrun=TRUE, iter=4, sampleshare=0.5, logrun=TRUE)

trips <- CoreSummariesStr(fullrun=FALSE, iter=4, sampleshare=0.5, logrun=TRUE)

summarize_attributes_mean <- trips %>%
  group_by(skims_mode) %>%
  summarize(walktime = mean(walktime), wait = mean(wait), IVT = mean(IVT), transfers = mean(transfers), boardfare = mean(boardfare), xfare = mean(xfare), faremat = mean(faremat)) %>%
  ungroup()

summarize_attributes_min <- trips %>%
  group_by(skims_mode) %>%
  summarize(walktime = min(walktime), wait = min(wait), IVT = min(IVT), transfers = min(transfers), boardfare = min(boardfare), xfare = min(xfare), faremat = min(faremat)) %>%
  ungroup()

