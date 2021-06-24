
:: This batch file is used to set up the model to run a 4th iteration
:: starting from an empty folder and bringing in the necessary files from another folder where 3 iterations of the base run were carried out.  

:: some of this is based on calibrateModel.bat - https://github.com/BayAreaMetro/travel-model-one/blob/master/utilities/calibration/calibrateModel.bat

:: Carry out general setup process, starting from an empty folder
call SetUpModel.bat

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







