* ad-hoc Stata 15 code to investigate issues with fare by distance scenarios

cd "C:\Users\amitrani\Documents\Bay Area Fares\"

import excel "WorkbookStr_2015_TM152_MTC_T26_20210902103141amitrani_vs_WorkbookStr_2015_TM152_MTC_T41_20210909114142amitrani.xlsx", sheet("county_od_trip_mode") firstrow clear

keep if dRegional1>0 & dRegional2>0 & dRegional1!=. & dRegional2!=.
keep if trip_mode!="TNC - Shared e.g. sharing with strangers (added in Travel Model 1.5)"
keep if trip_mode!="TNC (Transportation Network Company, or ride-hailing services) - Single party (added in Travel Model 1.5)"

tab trip_mode
gen dregional = round(dRegional1)

collapse (sum) trips1 trips2 revenue1 revenue2, by(trip_mode dregional)

export excel using "WorkbookStr_2015_TM152_MTC_T26_20210902103141amitrani_vs_WorkbookStr_2015_TM152_MTC_T41_20210909114142amitrani.xlsx", sheet("distance_analysis") sheetmodify firstrow(variables)

gen revdiff= revenue2- revenue1
encode trip_mode, generate(trip_mode_n)
label list trip_mode_n
keep trip_mode_n dregional revdiff

reshape wide revdiff, i( dregional) j( trip_mode_n)

export excel using "WorkbookStr_2015_TM152_MTC_T26_20210902103141amitrani_vs_WorkbookStr_2015_TM152_MTC_T41_20210909114142amitrani.xlsx", sheet("distance_analysis_2") sheetmodify firstrow(variables)

import excel "WorkbookStr_2015_TM152_MTC_T26_20210902103141amitrani_vs_WorkbookStr_2015_TM152_MTC_T43_20210910073234amitrani.xlsx", sheet("county_od_trip_mode") firstrow clear

keep if dRegional1>0 & dRegional2>0 & dRegional1!=. & dRegional2!=.
keep if trip_mode!="TNC - Shared e.g. sharing with strangers (added in Travel Model 1.5)"
keep if trip_mode!="TNC (Transportation Network Company, or ride-hailing services) - Single party (added in Travel Model 1.5)"

tab trip_mode
gen dregional = round(dRegional1)

collapse (sum) trips1 trips2 revenue1 revenue2, by(trip_mode dregional)

export excel using "WorkbookStr_2015_TM152_MTC_T26_20210902103141amitrani_vs_WorkbookStr_2015_TM152_MTC_T43_20210910073234amitrani.xlsx", sheet("distance_analysis") sheetmodify firstrow(variables)

gen revdiff= revenue2- revenue1
encode trip_mode, generate(trip_mode_n)
label list trip_mode_n
keep trip_mode_n dregional revdiff

reshape wide revdiff, i( dregional) j( trip_mode_n)

export excel using "WorkbookStr_2015_TM152_MTC_T26_20210902103141amitrani_vs_WorkbookStr_2015_TM152_MTC_T43_20210910073234amitrani.xlsx", sheet("distance_analysis_2") sheetmodify firstrow(variables)


*

