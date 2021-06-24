
:: The name of the scenario and the name of the scenario folder in which the model will be run.
SET SCENARIONAME=2015_TM152_STR_BA

:: The path to the project folder
SET PROJECTPATH=F:\23791501\

:: The commpath
SET COMMPATH=F:\23791501\%SCENARIONAME%\

:: The path for storing outputs
SET OUTPUTSPATH=%PROJECTPATH%outputs\

:: The path for storing logs
SET LOGPATH=%PROJECTPATH%logs\

@echo off
FOR /f %%a IN ('WMIC OS GET LocalDateTime ^| FIND "."') DO SET DTS=%%a
SET TimeStamp=%DTS:~0,4%%DTS:~4,2%%DTS:~6,2%%DTS:~8,2%%DTS:~10,2%%DTS:~12,2%
echo %TimeStamp%

Call RunModel.bat > %LOGPATH%%TimeStamp%RunModel.txt

::