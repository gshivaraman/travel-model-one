:: SetPath.bat
:: Utility to set the path.  Used in RunModel as well as RunMain and RunNodeX. 

:: The path for storing outputs
SET OUTPUTSPATH=F:\23791501\outputs\

:: The commpath
SET COMMPATH=F:\23791501\2015_TM152_STR_BA\

@echo off
FOR /f %%a IN ('WMIC OS GET LocalDateTime ^| FIND "."') DO SET DTS=%%a
SET TimeStamp=%DTS:~0,4%%DTS:~4,2%%DTS:~6,2%%DTS:~8,2%%DTS:~10,2%%DTS:~12,2%
echo %TimeStamp%

:: The path to the backup folder
mkdir %OUTPUTSPATH%\%TimeStamp%
SET M_DIR=%OUTPUTSPATH%\outputs\%TimeStamp%

:: The location of the 64-bit java development kit
set JAVA_PATH=C:\Program Files\Java\jdk-16.0.1

:: The location of the GAWK binary executable files
set GAWK_PATH=E:\Program Files (x86)\GnuWin32

:: The location of R and R libraries
set R_HOME=E:\Program Files\R\R-4.0.5
set R_LIB=E:\Program Files\R\R-4.0.5\library

:: The location of the RUNTPP executable from Citilabs
:: The API was obtained from here: https://communities.bentley.com/products/mobility-simulation-analytics/m/cube-files/275055
set TPP_PATH=E:\Program Files (x86)\Citilabs\CubeVoyager;%COMMPATH%\CUBE6_VoyagerAPI\Dlls\x64

:: The location of python
set PYTHON_PATH=E:\Program Files\Python27

:: The location of the MTC.JAR file
set RUNTIME=CTRAMP/runtime

:: Add these variables to the PATH environment variable, moving the current path to the back
set PATH=%RUNTIME%;%JAVA_PATH%/bin;%TPP_PATH%;%GAWK_PATH%/bin;%PYTHON_PATH%

::  Set the Java classpath (locations where Java needs to find configuration and JAR files)
set CLASSPATH=%RUNTIME%/config;%RUNTIME%;%RUNTIME%/config/jppf-2.4/jppf-2.4-admin-ui/lib/*;%RUNTIME%/mtc.jar
