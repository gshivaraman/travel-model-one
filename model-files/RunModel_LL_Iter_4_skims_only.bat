::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:: RunModel.bat
::
:: MS-DOS batch file to execute the MTC travel model.  Each of the model steps are sequentially
:: called here.  
::
:: For complete details, please see http://mtcgis.mtc.ca.gov/foswiki/Main/RunModelBatch.
::
:: dto (2012 02 15) gde (2009 04 22)
::
::~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:: ------------------------------------------------------------------------------------------------------
::
:: Step 1:  Set the necessary path variables
::
:: ------------------------------------------------------------------------------------------------------

:: Set the path
call CTRAMP\runtime\SetPath.bat

SET SCENARIONAME=2015_TM152_IPA_16_T2


::  Set the IP address of the host machine which sends tasks to the client machines 
set HOST_IP_ADDRESS=169.254.0.2

set HOST_IP=169.254.0.2

:: Figure out the model year
set MODEL_DIR=%CD%
set PROJECT_DIR=%~p0
set PROJECT_DIR2=%PROJECT_DIR:~0,-1%
:: get the base dir only
for %%f in (%PROJECT_DIR2%) do set myfolder=%%~nxf
:: the first four characters are model year
set MODEL_YEAR=%myfolder:~0,4%

:: MODEL YEAR ------------------------- make sure it's numeric --------------------------------
set /a MODEL_YEAR_NUM=%MODEL_YEAR% 2>nul
if %MODEL_YEAR_NUM%==%MODEL_YEAR% (
  echo Numeric model year [%MODEL_YEAR%]
) else (
  echo Couldn't determine numeric model year from project dir [%PROJECT_DIR%]
  echo Guessed [%MODEL_YEAR%]
  exit /b 2
)
:: MODEL YEAR ------------------------- make sure it's in [2000,3000] -------------------------
if %MODEL_YEAR% LSS 2000 (
  echo Model year [%MODEL_YEAR%] is less than 2000
  exit /b 2
)
if %MODEL_YEAR% GTR 3000 (
  echo Model year [%MODEL_YEAR%] is greater than 3000
  exit /b 2
)

:: an example of a folder name with the naming convention used below would be 2015_TM152_IPA_16
::set PROJECT=%myfolder:~11,3%
set PROJECT=IPA
:: this would yield "IPA" in the example above
::set FUTURE_ABBR=%myfolder:~15,2%
set FUTURE_ABBR=BA
:: this would yield "16" in the example above
set FUTURE=X
:: FUTURE is initialised to X so that further down it can be tested whether another definition has been set or not.  

:: FUTURE ------------------------- make sure FUTURE_ABBR is one of the five [RT,CG,BF] -------------------------
:: The long names are: BaseYear ie 2015, Blueprint aka PBA50, CleanAndGreen, BackToTheFuture, or RisingTidesFallingFortunes

if %PROJECT%==IPA (SET FUTURE=PBA50)
if %PROJECT%==DBP (SET FUTURE=PBA50)
if %PROJECT%==FBP (SET FUTURE=PBA50)
if %PROJECT%==EIR (SET FUTURE=PBA50)
if %PROJECT%==PPA (
  if %FUTURE_ABBR%==RT (set FUTURE=RisingTidesFallingFortunes)
  if %FUTURE_ABBR%==CG (set FUTURE=CleanAndGreen)
  if %FUTURE_ABBR%==BF (set FUTURE=BackToTheFuture)
)

:: Steer modification for base run, considering that the model folder will be called "2015_TM152_STR_BA" for the base run.  
if %PROJECT%==STR (
	if %FUTURE_ABBR%==BA (set FUTURE=PBA50)
)

echo on
echo FUTURE = %FUTURE%

echo off
if %FUTURE%==X (
  echo on
  echo Couldn't determine FUTURE name.
  echo Make sure the name of the project folder conform to the naming convention.
  exit /b 2
)

echo on
echo turn echo back on

:: python "CTRAMP\scripts\notify_slack.py" "Starting *%MODEL_DIR%*"

::set MAXITERATIONS=3
:: Revised by LL, 7/7/21
set MAXITERATIONS=5
:: --------TrnAssignment Setup -- Standard Configuration
:: CHAMP has dwell  configured for buses (local and premium)
:: CHAMP has access configured for for everything
:: set TRNCONFIG=STANDARD
:: set COMPLEXMODES_DWELL=21 24 27 28 30 70 80 81 83 84 87 88
:: set COMPLEXMODES_ACCESS=21 24 27 28 30 70 80 81 83 84 87 88 110 120 130

:: --------TrnAssignment Setup -- Fast Configuration
:: NOTE the blank ones should have a space
set TRNCONFIG=FAST
set COMPLEXMODES_DWELL= 
set COMPLEXMODES_ACCESS= 

:: ------------------------------------------------------------------------------------------------------
::
:: Step 9:  Prepare for iteration 4 and execute RunIteration batch file
::
:: ------------------------------------------------------------------------------------------------------

: iter4

:: Set the iteration parameters
set ITER=4
set PREV_ITER=3
set WGT=1.00
set PREV_WGT=0.00
set SAMPLESHARE=0.50
set SEED=0


:: ------------------------------------------------------------------------------------------------------
::
:: Added by LL, 8/6/21
::
:: Build highway and transit skims from Outputs of Iteration 4
::
:: ------------------------------------------------------------------------------------------------------

:: Start the cube cluster
Cluster "%COMMPATH%\CTRAMP" 1-36 StartHide Exit

:skims

:: Skim automobile level-of-service matrices
runtpp CTRAMP\scripts\skims\HwySkims.job
if ERRORLEVEL 2 goto done

cd trn\TransitAssignment.iter%ITER%
set ALLTIMEPERIODS=AM MD PM EV EA
set TRNASSIGNITER=0
set PREVTRNASSIGNITER=NEG1
set PHTDIFFCOND=0.0001
set VOLDIFFCOND=0.005
set TRNASSIGNMODE=NORMAL
set TOTMAXTRNITERS=30
set MAXPATHTIME=240
set PCT=%%
set PYTHONPATH=%USERPROFILE%\Documents\GitHub\NetworkWrangler;%USERPROFILE%\Documents\GitHub\NetworkWrangler\_static
set TRN_ERRORLEVEL=0

:: Skim transit level-of-service matrices and re-calculate Fares, accordingly
runtpp ..\..\CTRAMP\scripts\skims\TransitSkims_T2.job
if ERRORLEVEL 2 goto done

cd ..\..\
:: ------------------------------------------------------------------------------------------------------
::
:: Step 11:  Build simplified skim databases
::
:: ------------------------------------------------------------------------------------------------------

: database

runtpp CTRAMP\scripts\database\SkimsDatabase.job
if ERRORLEVEL 2 goto done

:: ------------------------------------------------------------------------------------------------------
::
:: Step 14:  Core summaries
::
:: ------------------------------------------------------------------------------------------------------

: core_summaries

call RunCoreSummaries
if ERRORLEVEL 2 goto done


:: Extract key files
call extractkeyfiles
c:\windows\system32\Robocopy.exe /E extractor "..\OUTPUT\%SCENARIONAME%"

:: skims are copied to INPUT/skims so that there will be a safe set of skims for use as an input to the restart runs.
mkdir INPUT\skims
copy /Y skims                           	INPUT\skims


:: Close the cube cluster
Cluster "%COMMPATH%\CTRAMP" 1-36 Close Exit

:donedone