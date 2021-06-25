
:: This batch file is used to set up the model to run a 4th iteration
:: starting from an empty folder and bringing in the necessary files from another folder where 3 iterations of the base run were carried out.  

:: some of this is based on two existing files: 
:: - SetUpModel.bat - https://github.com/alexmitrani/travel-model-one/blob/master/model-files/SetUpModel.bat
:: - calibrateModel.bat - https://github.com/BayAreaMetro/travel-model-one/blob/master/utilities/calibration/calibrateModel.bat

:: Carry out general setup process, starting from an empty folder


:: ------------------------------------------------------------------------------------------------------
::
:: Step 0:  Set up folder structure and copy inputs from base and non-base
::
:: ------------------------------------------------------------------------------------------------------

ECHO on
SET computer_prefix=%computername:~0,4%
ECHO %computer_prefix%

:: copy over CTRAMP
set GITHUB_DIR= %USERPROFILE%\Documents\GitHub\travel-model-one
ECHO %GITHUB_DIR%
mkdir CTRAMP\model
mkdir CTRAMP\runtime
mkdir CTRAMP\scripts
mkdir skims
mkdir main
mkdir logs
mkdir landuse
mkdir popsyn
mkdir nonres
mkdir database
mkdir logsums

c:\windows\system32\Robocopy.exe /E %GITHUB_DIR%\model-files\model       CTRAMP\model
c:\windows\system32\Robocopy.exe /E %GITHUB_DIR%\model-files\runtime     CTRAMP\runtime
c:\windows\system32\Robocopy.exe /E %GITHUB_DIR%\model-files\scripts     CTRAMP\scripts
c:\windows\system32\Robocopy.exe /E %GITHUB_DIR%\utilities\RTP\metrics   CTRAMP\scripts\metrics
:: copy /Y %GITHUB_DIR%\utilities\monitoring\notify_slack.py                CTRAMP\scripts
copy /Y %GITHUB_DIR%\model-files\RunModel.bat                            .
copy /Y %GITHUB_DIR%\model-files\RestartRunModel.bat                     .
copy /Y %GITHUB_DIR%\model-files\LogRunModel.bat 						 .
copy /Y %GITHUB_DIR%\model-files\LogRestartRunModel.bat					 .
copy /Y %GITHUB_DIR%\model-files\LogRestartRunModel0.bat					 .
copy /Y %GITHUB_DIR%\model-files\RunIteration.bat                        CTRAMP
copy /Y %GITHUB_DIR%\model-files\FullRunIteration.bat                    CTRAMP
copy /Y %GITHUB_DIR%\model-files\RestartRunIteration.bat                 CTRAMP
copy /Y %GITHUB_DIR%\model-files\RunLogsums.bat                          .
copy /Y %GITHUB_DIR%\model-files\RunCoreSummaries.bat                    .
copy /Y %GITHUB_DIR%\model-files\RunPrepareEmfac.bat                     .
copy /Y %GITHUB_DIR%\utilities\RTP\ExtractKeyFiles.bat                   .
copy /Y %GITHUB_DIR%\utilities\RTP\QAQC\Run_QAQC.bat                     .
copy /Y %GITHUB_DIR%\utilities\check-setupmodel\Check_SetupModelLog.py   .


:: if %COMPUTER_PREFIX% == BIGI    (copy %GITHUB_DIR%\utilities\monitoring\notify_slack.py  CTRAMP\scripts\notify_slack.py)
if %COMPUTER_PREFIX% == BIGI    set HOST_IP_ADDRESS=10.60.10.70

:: copy over CUBE6_VoyagerAPI
set MODEL_ROOT_DIR=F:\23791501
ECHO %MODEL_ROOT_DIR%
c:\windows\system32\Robocopy.exe /E %MODEL_ROOT_DIR%\CUBE6_VoyagerAPI                       	CUBE6_VoyagerAPI

:setup_inputs
:: copy over INPUTs from baseline
set MODEL_SETUP_BASE_DIR=F:\23791501\2015_TM152_STR_BA
ECHO %MODEL_SETUP_BASE_DIR%

c:\windows\system32\Robocopy.exe /E "%MODEL_SETUP_BASE_DIR%\INPUT\landuse"        	INPUT\landuse
c:\windows\system32\Robocopy.exe /E "%MODEL_SETUP_BASE_DIR%\INPUT\nonres"         	INPUT\nonres
c:\windows\system32\Robocopy.exe /E "%MODEL_SETUP_BASE_DIR%\INPUT\popsyn"         	INPUT\popsyn
c:\windows\system32\Robocopy.exe /E "%MODEL_SETUP_BASE_DIR%\INPUT\warmstart"      	INPUT\warmstart
c:\windows\system32\Robocopy.exe /E "%MODEL_SETUP_BASE_DIR%\INPUT\skims"          	INPUT\skims
c:\windows\system32\Robocopy.exe /E "%MODEL_SETUP_BASE_DIR%\hwy"            		hwy
c:\windows\system32\Robocopy.exe /E "%MODEL_SETUP_BASE_DIR%\trn"            		trn

copy /Y "%MODEL_SETUP_BASE_DIR%\INPUT\params.properties"                          	INPUT\params.properties

copy "%MODEL_SETUP_BASE_DIR%\main\ShadowPricing_7.csv"                            	main

:: Stamp the feedback report with the date and time of the model start
echo STARTED MODEL RUN  %DATE% %TIME% >> logs\feedback.rpt 

:: Move the input files, which are not accessed by the model, to the working directories
copy INPUT\landuse\             landuse\
copy INPUT\popsyn\              popsyn\
copy INPUT\nonres\              nonres\
copy INPUT\warmstart\main\      main\
copy INPUT\warmstart\nonres\    nonres\
c:\windows\system32\Robocopy.exe /E "%MODEL_SETUP_BASE_DIR%\main"            		main

:: source of skims to copy
set SKIM_DIR=%MODEL_SETUP_BASE_DIR%
ECHO %SKIM_DIR%

:copy_skims
copy "%SKIM_DIR%\skims\HWYSKM*"           										skims
copy "%SKIM_DIR%\skims\COM_HWYSKIM*"      										skims
copy "%SKIM_DIR%\skims\trnskm*"           										skims
copy "%SKIM_DIR%\skims\nonmotskm.tpp"     										skims
copy "%SKIM_DIR%\skims\accessibility.csv" 										skims

:: done.  







