
:: The index number of the scenario
SET SCENARIOINDEX=0

:: The name of the scenario and the name of the scenario folder in which the model will be run.
SET SCENARIONAME=2015_TM152_STR_BA

:: The path to the project folder
SET PROJECTPATH=F:\23791501\

:: The path for storing outputs
SET OUTPUTSPATH=%PROJECTPATH%outputs\

:: The path for storing logs
SET LOGPATH=%PROJECTPATH%logs\

:: The path for input fares files
SET INPUTFARESPATH=%PROJECTPATH%inputs\%SCENARIOINDEX%

copy /Y %INPUTFARESPATH%\ACE.far                            	%PROJECTPATH%%SCENARIONAME%\INPUT\trn
copy /Y %INPUTFARESPATH%\Amtrak.far                          	%PROJECTPATH%%SCENARIONAME%\INPUT\trn
copy /Y %INPUTFARESPATH%\BART.far                            	%PROJECTPATH%%SCENARIONAME%\INPUT\trn
copy /Y %INPUTFARESPATH%\Caltrain.far                          	%PROJECTPATH%%SCENARIONAME%\INPUT\trn
copy /Y %INPUTFARESPATH%\farelinks.far                         	%PROJECTPATH%%SCENARIONAME%\INPUT\trn
copy /Y %INPUTFARESPATH%\Ferry.far                            	%PROJECTPATH%%SCENARIONAME%\INPUT\trn
copy /Y %INPUTFARESPATH%\HSR.far                            	%PROJECTPATH%%SCENARIONAME%\INPUT\trn
copy /Y %INPUTFARESPATH%\SMART.far                            	%PROJECTPATH%%SCENARIONAME%\INPUT\trn
copy /Y %INPUTFARESPATH%\xfare.far                            	%PROJECTPATH%%SCENARIONAME%\INPUT\trn
copy /Y %INPUTFARESPATH%\TransitSkims.job                       %PROJECTPATH%%SCENARIONAME%\CTRAMP\scripts\skims
copy /Y %INPUTFARESPATH%\overrideTransitSkimMatrix0.job          %PROJECTPATH%%SCENARIONAME%\CTRAMP\scripts\skims\overrideTransitSkimMatrix.job

:: Move the input files, which are not accessed by the model, to the working directories
copy /Y INPUT\trn\                 trn\

@echo off
FOR /f %%a IN ('WMIC OS GET LocalDateTime ^| FIND "."') DO SET DTS=%%a
SET TimeStamp=%DTS:~0,4%%DTS:~4,2%%DTS:~6,2%%DTS:~8,2%%DTS:~10,2%%DTS:~12,2%
echo %TimeStamp%

:: The following environment variable allows the sample share to be varied from this scenario-specific file which is used to trigger the model run.  
set MYSAMPLESHARE=0.5

Call RestartRunModel.bat > %LOGPATH%%TimeStamp%RestartRunModel.txt

::