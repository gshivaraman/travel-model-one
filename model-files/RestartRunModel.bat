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

:: Start the cube cluster
Cluster %COMMPATH%\CTRAMP 1-48 Starthide Exit

::  Set the IP address of the host machine which sends tasks to the client machines 
if %computername%==BIGIRON			   set HOST_IP_ADDRESS=10.60.10.70
rem if %computername%==WIN-A4SJP19GCV5     set HOST_IP_ADDRESS=10.0.0.70
rem for aws machines, HOST_IP_ADDRESS is set in SetUpModel.bat

:: for AWS, this will be "WIN-"
SET computer_prefix=%computername:~0,4%
set INSTANCE=%COMPUTERNAME%
if "%COMPUTER_PREFIX%" == "BIGI" (
  rem figure out instance
  for /f "delims=" %%I in ('"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -Command (wget http://169.254.169.254/latest/meta-data/instance-id).Content"') do set INSTANCE=%%I
)

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
set PROJECT=%myfolder:~11,3%
:: this would yield "IPA" in the example above
set FUTURE_ABBR=%myfolder:~15,2%
:: this would yield "16" in the example above
set FUTURE=X
:: FUTURE is initialised to X so that further down it can be tested whether another definition has been set or not.  

:: FUTURE ------------------------- make sure FUTURE_ABBR is one of the five [RT,CG,BF] -------------------------
:: The long names are: BaseYear ie 2015, Blueprint aka PBA50, CleanAndGreen, BackToTheFuture, or RisingTidesFallingFortunes

::if %PROJECT%==IPA (SET FUTURE=PBA50)
::if %PROJECT%==DBP (SET FUTURE=PBA50)
::if %PROJECT%==FBP (SET FUTURE=PBA50)
::if %PROJECT%==EIR (SET FUTURE=PBA50)
::if %PROJECT%==PPA (
::  if %FUTURE_ABBR%==RT (set FUTURE=RisingTidesFallingFortunes)
::  if %FUTURE_ABBR%==CG (set FUTURE=CleanAndGreen)
::  if %FUTURE_ABBR%==BF (set FUTURE=BackToTheFuture)
::)

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

:: "E:\Program Files\Python27\python.exe" "CTRAMP\scripts\notify_slack.py" "Starting *%MODEL_DIR%*"

set MAXITERATIONS=3
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

:: Stamp the feedback report with the date and time of the model start
echo STARTED RESTART MODEL RUN  %DATE% %TIME% >> logs\feedback.rpt 

:: ------------------------------------------------------------------------------------------------------
::
:: Step 9:  Prepare for iteration 4 and execute RunIteration batch file
::
:: ------------------------------------------------------------------------------------------------------

: iter3

:: Set the iteration parameters
set ITER=3
set PREV_ITER=2
set WGT=0.33
set PREV_WGT=0.67
set SAMPLESHARE=0.50
set SEED=0

:: Runtime configuration: set the workplace shadow pricing parameters

:: Here it is necessary to switch in the restart run version of mtcTourBased.properties
copy /Y CTRAMP\runtime\mtcTourBasedRestartRun.properties                        CTRAMP\runtime\mtcTourBased.properties

:: Here, changes get made to mtcTourBased.properties:
"E:\Program Files\Python27\python.exe" CTRAMP\scripts\preprocess\RuntimeConfiguration.py --iter %ITER%
if ERRORLEVEL 1 goto done

:: Call RestartRunIteration batch file
:: This is a slightly modified version of RunIteration.bat, changed to accomodate the Household manager Java process already running for a restart run, while the other Java processes will require restarting.  
call CTRAMP\RestartRunIteration.bat
if ERRORLEVEL 2 goto done

:: Shut down java
:: The following line has been commented out to enable restart runs.  
:: LMZ - "And to clarify, for the baseline run, you’d run all three iterations, but then comment out this line which kills the java components."
:: C:\Windows\SysWOW64\taskkill /f /im "java.exe"


:: update telecommute constants one more time just to evaluate the situation
"E:\Program Files\Python27\python.exe" CTRAMP\scripts\preprocess\updateTelecommuteConstants.py


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
:: Step 12:  Prepare inputs for EMFAC
::
:: ------------------------------------------------------------------------------------------------------

if not exist hwy\iter%ITER%\avgload5period_vehclasses.csv (
  rem Export network to csv version (with vehicle class volumn columns intact)
  rem Input : hwy\iter%ITER%\avgload5period.net
  rem Output: hwy\iter%ITER%\avgload5period_vehclasses.csv
  runtpp "CTRAMP\scripts\metrics\net2csv_avgload5period.job"
  IF ERRORLEVEL 2 goto error
)

:: Run Prepare EMFAC
call RunPrepareEmfac.bat SB375 WithFreight

:: ------------------------------------------------------------------------------------------------------
::
:: Step 13:  Build destination choice logsums
::
:: ------------------------------------------------------------------------------------------------------

: logsums

:: call RunAccessibility
:: if ERRORLEVEL 2 goto done
:: LMZ - "You should also comment out RunLogsums since that uses the model core"
:: call RunLogsums
if ERRORLEVEL 2 goto done

:: LMZ - "you could comment out other summarization processes like CoreSummaries, Metrics, ScenarioMetrics"

:: ------------------------------------------------------------------------------------------------------
::
:: Step 14:  Core summaries
::
:: ------------------------------------------------------------------------------------------------------

: core_summaries

call RunCoreSummaries
if ERRORLEVEL 2 goto done

:: ------------------------------------------------------------------------------------------------------
::
:: Step 15:  Cobra Metrics
::
:: ------------------------------------------------------------------------------------------------------

:: Kept the parts of RunMetrics that ran successfully. Commented out lines from vmt_vht_metrics onwards in RunMetrics, but kept RunMetrics as part of the main process.  
call RunMetrics
if ERRORLEVEL 2 goto done

:: ------------------------------------------------------------------------------------------------------
::
:: Step 16:  Scenario Metrics
::
:: ------------------------------------------------------------------------------------------------------

:: Commenting out RunScenarioMetrics for now.  
:: call RunScenarioMetrics
if ERRORLEVEL 2 goto done

:: ------------------------------------------------------------------------------------------------------
::
:: Step 17:  Directory clean up
::
:: ------------------------------------------------------------------------------------------------------


:: Extract key files
call extractkeyfiles
c:\windows\system32\Robocopy.exe /E extractor "%M_DIR%OUTPUT"


: cleanup

:: Move all the TP+ printouts to the \logs folder
copy *.prn logs\*.prn

:: Close the cube cluster
Cluster "%COMMPATH%\CTRAMP" 1-48 Close Exit

:: Delete all the temporary TP+ printouts and cluster files
del *.prn
del *.script.*
del *.script

:: commented out call to Run_QAQC as this was for specific future scenarios
:: run QA/QC for PBA50
:: call Run_QAQC

:: Success target and message
:success
ECHO RESTART RUN FINISHED SUCCESSFULLY!

:: "E:\Program Files\Python27\python.exe" "CTRAMP\scripts\notify_slack.py" "Finished *%MODEL_DIR%*"

:: deleted some lines that were specific to a previous configuration that used AWS instances

:: no errors
goto donedone

:: this is the done for errors
:done
ECHO FINISHED.  

:: if we got here and didn't shutdown -- assume something went wrong
:: "E:\Program Files\Python27\python.exe" "CTRAMP\scripts\notify_slack.py" ":exclamation: Error in *%MODEL_DIR%*"

:donedone