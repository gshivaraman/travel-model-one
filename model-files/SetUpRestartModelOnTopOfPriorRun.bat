
:: This batch file is used to set up the model to run a 4th iteration
:: starting from an empty folder and bringing in the necessary files from another folder where 3 iterations of the base run were carried out.  

:: some of this is based on two existing files: 
:: - SetUpModel.bat - https://github.com/alexmitrani/travel-model-one/blob/master/model-files/SetUpModel.bat
:: - calibrateModel.bat - https://github.com/BayAreaMetro/travel-model-one/blob/master/utilities/calibration/calibrateModel.bat

:: Carry out general setup process, starting from an existing run folder


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

copy /Y %GITHUB_DIR%\model-files\RunModel.bat                            		.
copy /Y %GITHUB_DIR%\model-files\RestartRunModel.bat                     		.
copy /Y %GITHUB_DIR%\model-files\LogRunModel.bat 						 		.
copy /Y %GITHUB_DIR%\model-files\LogRestartRunModel.bat					 		.
copy /Y %GITHUB_DIR%\model-files\LogRestartRunModel0.bat				 		.
copy /Y %GITHUB_DIR%\model-files\RunIteration.bat                        		CTRAMP
copy /Y %GITHUB_DIR%\model-files\FullRunIteration.bat                    		CTRAMP
copy /Y %GITHUB_DIR%\model-files\RestartRunIteration.bat                 		CTRAMP
copy /Y %GITHUB_DIR%\model-files\RunLogsums.bat                          		.
copy /Y %GITHUB_DIR%\model-files\RunCoreSummaries.bat                    		.
copy /Y %GITHUB_DIR%\model-files\RunPrepareEmfac.bat                     		.
copy /Y %GITHUB_DIR%\utilities\RTP\RunMetrics.bat                        		.
copy /Y %GITHUB_DIR%\utilities\RTP\RunScenarioMetrics.bat                		.
copy /Y %GITHUB_DIR%\utilities\RTP\ExtractKeyFiles.bat                   		.
copy /Y %GITHUB_DIR%\utilities\RTP\QAQC\Run_QAQC.bat                     		.
copy /Y %GITHUB_DIR%\utilities\check-setupmodel\Check_SetupModelLog.py   		.
copy /Y %GITHUB_DIR%\model-files\runtime\JavaOnly_FullRun_runMain.cmd  			CTRAMP\runtime
copy /Y %GITHUB_DIR%\model-files\runtime\JavaOnly_Restart_runMain.cmd  			CTRAMP\runtime
copy /Y %GITHUB_DIR%\model-files\runtime\JavaOnly_runMain.cmd  					CTRAMP\runtime
copy /Y %GITHUB_DIR%\model-files\runtime\SetPath.bat  					     	CTRAMP\runtime\SetPath.bat
copy /Y %GITHUB_DIR%\model-files\runtime\mtcTourBased.properties  				CTRAMP\runtime\mtcTourBased.properties
copy /Y %GITHUB_DIR%\model-files\runtime\mtcTourBasedFullRun.properties  		CTRAMP\runtime\mtcTourBasedFullRun.properties
copy /Y %GITHUB_DIR%\model-files\runtime\mtcTourBasedRestartRun.properties  	CTRAMP\runtime\mtcTourBasedRestartRun.properties



:: if %COMPUTER_PREFIX% == BIGI    (copy %GITHUB_DIR%\utilities\monitoring\notify_slack.py  CTRAMP\scripts\notify_slack.py)
if %COMPUTER_PREFIX% == BIGI    set HOST_IP_ADDRESS=10.60.10.70

:: copy over CUBE6_VoyagerAPI
set MODEL_ROOT_DIR=F:\23791501
ECHO %MODEL_ROOT_DIR%

:setup_inputs
:: Stamp the feedback report with the date and time of the model start
echo STARTED MODEL RUN  %DATE% %TIME% >> logs\feedback.rpt 

:: done.  







