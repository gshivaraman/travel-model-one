::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:: ExtractKeyFiles.bat
::
:: MS-DOS batch file to extract key model files from various model run directories
:: for quick exporting for data summary.
::
:: lmz - Create version for PBAU (Plan Bay Area Update)
:: updated for BAF by AM
::
:: This just pulls output into extractor\
::
:: See also CopyFilesToM.bat, which is meant to run afterwards
::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo STARTED EXTRACTOR RUN  %DATE% %TIME% >> logs\feedback.rpt

:: Create the needed directories
mkdir extractor

:: Assume this is set already
set ITER=%ITER%

:: Highway assignment results
copy hwy\iter%ITER%\avgload5period.net            extractor\avgload5period.net
copy hwy\iter%ITER%\avgload5period.csv            extractor\avgload5period.csv
copy hwy\iter%ITER%\avgload5period_vehclasses.csv extractor\avgload5period_vehclasses.csv

:: Demand results
copy main\householdData_%ITER%.csv extractor\main\householdData_%ITER%.csv
copy main\personData_%ITER%.csv    extractor\main\personData_%ITER%.csv
copy main\indivTripData_%ITER%.csv extractor\main\indivTripData_%ITER%.csv
copy main\indivTourData_%ITER%.csv extractor\main\indivTourData_%ITER%.csv
copy main\jointTripData_%ITER%.csv extractor\main\jointTripData_%ITER%.csv
copy main\jointTourData_%ITER%.csv extractor\main\jointTourData_%ITER%.csv
copy main\wsLocResults_%ITER%.csv  extractor\main\wsLocResults_%ITER%.csv

:: Report results
copy logs\HwySkims.debug  extractor\HwySkims.debug
copy logs\feedback.rpt    extractor\feedback.rpt
copy logs\SpeedErrors.log extractor\SpeedErrors.log

:: Skim databases
:: mkdir extractor\skimDB
:: copy database\*.csv extractor\skimDB\*.csv

:: Trip tables
mkdir extractor\main
copy main\tripsEA.tpp extractor\main
copy main\tripsAM.tpp extractor\main
copy main\tripsMD.tpp extractor\main
copy main\tripsPM.tpp extractor\main
copy main\tripsEV.tpp extractor\main
copy main\ShadowPricing_7.csv extractor\main

mkdir extractor\nonres
copy nonres\ixDaily2015.tpp       	extractor\nonres
copy nonres\ixDailyx4.tpp         	extractor\nonres
copy nonres\tripsIX*.tpp          	extractor\nonres
copy nonres\tripsTrk*.tpp         	extractor\nonres

mkdir extractor\skims
copy skims\trnskm*.tpp				extractor\skims


:: Save the control file
copy CTRAMP\runtime\mtcTourBased.properties extractor\mtcTourBased.properties
copy CTRAMP\runtime\mtcTourBased.properties extractor\logsums.properties

:: Accessibility files
mkdir extractor\accessibilities
copy accessibilities\nonMandatoryAccessibilities.csv extractor\accessibilities
copy accessibilities\mandatoryAccessibilities.csv    extractor\accessibilities
copy skims\accessibility.csv                         extractor\accessibilities

:: Core summaries
mkdir extractor\core_summaries
copy core_summaries\*.*                              extractor\core_summaries
mkdir extractor\updated_output
copy updated_output\*.*                              extractor\updated_output

:success
echo ExtractKeyFiles into extractor for STR Complete
echo ENDED EXTRACTOR RUN  %DATE% %TIME% >> logs\feedback.rpt

:done
