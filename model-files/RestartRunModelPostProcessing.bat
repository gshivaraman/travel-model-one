
:: The index number of the scenario for which the postprocessing is to be undertaken
SET SCENARIOINDEX=7

:: The timestamp which was defined when the model was originally run
SET TimeStamp=20210723172841
echo %TimeStamp%

:: The name of the scenario and the name of the scenario folder in which the model will be run.
SET SCENARIONAME=2015_TM152_STR_T%SCENARIOINDEX%

:: The path to the project folder
SET PROJECTPATH=F:\23791501\

:: The commpath
SET COMMPATH=F:\23791501\%SCENARIONAME%\

:: The path for storing outputs
SET OUTPUTSPATH=%PROJECTPATH%outputs\

:: The path for storing logs
SET LOGPATH=%PROJECTPATH%logs\

:: The path for input fares files
SET INPUTFARESPATH=%PROJECTPATH%inputs\%SCENARIOINDEX%

:: The path for input skims
SET SKIMS_SOURCE_DIR=%PROJECTPATH%%SCENARIONAME%\INPUT\skims

:: The path for output skims
SET SKIMS_OUTPUT_DIR=%PROJECTPATH%%SCENARIONAME%\skims

:: The following environment variable allows the sample share to be varied from this scenario-specific file which is used to trigger the model run.  
set MYSAMPLESHARE=0.5
:: Set the path
call CTRAMP\runtime\SetPath.bat

:: Start the cube cluster
Cluster %COMMPATH%\CTRAMP 1-40 Starthide Exit

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

:: Steer modification for base run, considering that the model folder will be called "2015_TM152_STR_BA" for the base run.  
set FUTURE=PBA50

set MAXITERATIONS=5

:: --------TrnAssignment Setup -- Fast Configuration
:: NOTE the blank ones should have a space
set TRNCONFIG=FAST
set COMPLEXMODES_DWELL= 
set COMPLEXMODES_ACCESS= 

:: Stamp the feedback report with the date and time of the model start
echo STARTED POSTPROCESSING  %DATE% %TIME% >> logs\ppfeedback.rpt 


: iter4

:: Set the iteration parameters
set ITER=4
set PREV_ITER=3
set WGT=1.0
set PREV_WGT=0.0
set SAMPLESHARE=%MYSAMPLESHARE%
set SEED=0

:: ------------------------------------------------------------------------------------------------------
::
:: Step 11:  Build simplified skim databases
::
:: ------------------------------------------------------------------------------------------------------

: database

runtpp CTRAMP\scripts\database\SkimsDatabase.job
if ERRORLEVEL 2 goto done

: core_summaries
call RunCoreSummaries
if ERRORLEVEL 2 goto done


:: Extract key files
call RestartExtractKeyFiles
c:\windows\system32\Robocopy.exe /E extractor "%M_DIR%OUTPUT"


: cleanup

:: Move all the TP+ printouts to the \logs folder
copy *.prn logs\*.prn

:: Close the cube cluster
Cluster "%COMMPATH%\CTRAMP" 1-40 Close Exit

:: Delete all the temporary TP+ printouts and cluster files
del *.script.*
del *.script

:: Success target and message
:success
ECHO RESTART RUN FINISHED SUCCESSFULLY!


:: no errors
goto donedone

:: this is the done for errors
:done
ECHO FINISHED.  

:: if we got here and didn't shutdown -- assume something went wrong

:donedone