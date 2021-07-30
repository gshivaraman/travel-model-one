

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

