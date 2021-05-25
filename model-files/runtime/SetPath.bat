:: SetPath.bat
:: Utility to set the path.  Used in RunModel as well as RunMain and RunNodeX. 

:: The commpath
SET COMMPATH=X:\COMMPATH

:: The location of the 64-bit java development kit
set JAVA_PATH=C:\Program Files\Java\jdk-16.0.1

:: The location of the GAWK binary executable files
set GAWK_PATH=X:\UTIL\Gawk

:: The location of R and R libraries
set R_HOME=E:\Program Files\R\R-4.0.5
set R_LIB=E:\Program Files\R\R-4.0.5\library

:: The location of the RUNTPP executable from Citilabs
set TPP_PATH=C:\Program Files\Citilabs\CubeVoyager; C:\Users\GShivaraman\Downloads\CUBE6_VoyagerAPI

:: The location of python
set PYTHON_PATH=C:\Python27

:: The location of the MTC.JAR file
set RUNTIME=CTRAMP/runtime

:: Add these variables to the PATH environment variable, moving the current path to the back
set PATH=%RUNTIME%;%JAVA_PATH%/bin;%TPP_PATH%;%GAWK_PATH%/bin;%PYTHON_PATH%

::  Set the Java classpath (locations where Java needs to find configuration and JAR files)
set CLASSPATH=%RUNTIME%/config;%RUNTIME%;%RUNTIME%/config/jppf-2.4/jppf-2.4-admin-ui/lib/*;%RUNTIME%/mtc.jar
