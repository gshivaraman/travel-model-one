
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

SET computer_prefix=%computername:~0,4%

:: copy over CTRAMP
set GITHUB_DIR= %USERPROFILE%\Documents\GitHub\travel-model-one
mkdir CTRAMP\model
mkdir CTRAMP\runtime
mkdir CTRAMP\scripts
mkdir CTRAMP\scripts\metrics
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
copy /Y %GITHUB_DIR%\utilities\RTP\RunMetrics.bat                        .
copy /Y %GITHUB_DIR%\utilities\RTP\RunScenarioMetrics.bat                .
copy /Y %GITHUB_DIR%\utilities\RTP\ExtractKeyFiles.bat                   .
copy /Y %GITHUB_DIR%\utilities\RTP\QAQC\Run_QAQC.bat                     .
copy /Y %GITHUB_DIR%\utilities\check-setupmodel\Check_SetupModelLog.py   .


:: if %COMPUTER_PREFIX% == BIGI    (copy %GITHUB_DIR%\utilities\monitoring\notify_slack.py  CTRAMP\scripts\notify_slack.py)
if %COMPUTER_PREFIX% == BIGI    set HOST_IP_ADDRESS=10.60.10.70

:: copy over CUBE6_VoyagerAPI
set MODEL_ROOT_DIR=F:\23791501
c:\windows\system32\Robocopy.exe /E %MODEL_ROOT_DIR%\CUBE6_VoyagerAPI                       	CUBE6_VoyagerAPI

:setup_inputs
:: copy over INPUTs from baseline
set MODEL_SETUP_BASE_DIR=F:\23791501\2015_TM152_STR_BA

c:\windows\system32\Robocopy.exe /E "%MODEL_SETUP_BASE_DIR%\INPUT\landuse"        INPUT\landuse
c:\windows\system32\Robocopy.exe /E "%MODEL_SETUP_BASE_DIR%\INPUT\nonres"         INPUT\nonres
c:\windows\system32\Robocopy.exe /E "%MODEL_SETUP_BASE_DIR%\INPUT\popsyn"         INPUT\popsyn
c:\windows\system32\Robocopy.exe /E "%MODEL_SETUP_BASE_DIR%\INPUT\warmstart"      INPUT\warmstart
c:\windows\system32\Robocopy.exe /E "%MODEL_SETUP_BASE_DIR%\INPUT\hwy"            INPUT\hwy
c:\windows\system32\Robocopy.exe /E "%MODEL_SETUP_BASE_DIR%\INPUT\trn"            INPUT\trn
c:\windows\system32\Robocopy.exe /E "%MODEL_SETUP_BASE_DIR%\INPUT\skims"          INPUT\skims
copy /Y "%MODEL_SETUP_BASE_DIR%\INPUT\params.properties"                          INPUT\params.properties

mkdir main
copy "%MODEL_SETUP_BASE_DIR%\main\ShadowPricing_7.csv"                            main

:: source of skims to copy
set SKIM_DIR=%MODEL_SETUP_BASE_DIR%

:: copy skims
:copy_skims
copy "%SKIM_DIR%\skims\HWYSKM*"           skims
copy "%SKIM_DIR%\skims\COM_HWYSKIM*"      skims
copy "%SKIM_DIR%\skims\trnskm*"           skims
copy "%SKIM_DIR%\skims\nonmotskm.tpp"     skims
copy "%SKIM_DIR%\skims\accessibility.csv" skims

:: done.  







