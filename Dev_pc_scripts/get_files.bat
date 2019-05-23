
@echo off

:: ---- If not defined all variables => use default variables

IF NOT [%1] == [] (
	IF NOT [%2] == [] (
		goto :Defined
	)
)
set ROOT_DIR="%UserProfile%\Desktop\Source\"
set DEPLOY_DIR="%UserProfile%\Desktop\Deploy\"

set DefaultPause=y
goto :NextAction

:Defined
set ROOT_DIR=%1
set DEPLOY_DIR=%2
:NextAction

:: ----------- User defined data [begin] -------------

set SolutionFolder="ProthPrimeSearch\"
set BoincFolder="ClientApp ProthPrimeSearch\"
set ProjectFolder="ProthPrimeNumbers\"
set MainAppConfiguration="Debug\"
set ServerProjectFolder="ProthPrimeSearchData\"

:: ------ root directory copy from:

:: ------ root directory copy to:
set DESTINATION_DIR="%DEPLOY_DIR%Data\"



:: ------- Files copy from:
set WORK_GENERATOR_DIR=%ROOT_DIR%%SolutionFolder%"Include\work_generator\"
set RESULTS_VALIDATOR_DIR=%ROOT_DIR%%SolutionFolder%"Include\validator\"
set ASIMILATOR_DIR=%ROOT_DIR%%SolutionFolder%"Include\assimilator\"
set MAIN_APP=%ROOT_DIR%%SolutionFolder%%BoincFolder%"win_build\Build\Win32\%MainAppConfiguration%example_app.exe"



:: ------- Files copy to:
set WORK_GENERATOR_DESTINATION_DIR=%DESTINATION_DIR%"WorkGenerator\"
set RESULTS_VALIDATOR_DESTINATION_DIR=%DESTINATION_DIR%"ResultsValidator\"
set ASIMILATOR_DESTINATION_DIR=%DESTINATION_DIR%"Asimilator\"
set MAIN_APP_DESTINATION_DIR=%DESTINATION_DIR%"Application\"

:: ----------- User defined data [end] ---------------

set ROOT_DIR="%DESTINATION_DIR:"=%"
set DESTINATION_DIR="%DESTINATION_DIR:"=%"


set WORK_GENERATOR_DIR="%WORK_GENERATOR_DIR:"=%"
set RESULTS_VALIDATOR_DIR="%RESULTS_VALIDATOR_DIR:"=%"
set ASIMILATOR_DIR="%ASIMILATOR_DIR:"=%"
set MAIN_APP="%MAIN_APP:"=%"

set WORK_GENERATOR_DESTINATION_DIR="%WORK_GENERATOR_DESTINATION_DIR:"=%"
set RESULTS_VALIDATOR_DESTINATION_DIR="%RESULTS_VALIDATOR_DESTINATION_DIR:"=%"
set ASIMILATOR_DESTINATION_DIR="%ASIMILATOR_DESTINATION_DIR:"=%"
set MAIN_APP_DESTINATION_DIR="%MAIN_APP_DESTINATION_DIR:"=%"


:: ---------------------------------------------------------------- BUILDING

IF NOT EXIST %ROOT_DIR% (
	echo Directory not exist:
	echo %ROOT_DIR%
	pause
	GOTO :exit
)



set BUILD_PATH="%UserProfile%"\Desktop\Source\"%SolutionFolder%%BoincFolder%"win_build\uc2.vcxproj"
set BUILD_PATH="%BUILD_PATH:"=%"

echo %BUILD_PATH%

:: -------------- Build project solution ----------------
msbuild %BUILD_PATH% /p:Configuration=Debug /t:Rebuild /noconsolelogger /nologo /m
set BUILD_STATUS=%ERRORLEVEL%
	
if not %BUILD_STATUS%==0 (
	echo @@@@@@ Build failed
	echo @@@@@@ Path: %BUILD_PATH%
	pause
	exit /b 1
)



:: ---------------------------------------------------------------- COPYING

if not exist %DESTINATION_DIR% (
	mkdir %DESTINATION_DIR%
)


if not exist %DESTINATION_DIR%%ServerProjectFolder% (
	mkdir %DESTINATION_DIR%%ServerProjectFolder%
)

:: ---------- Main aplication (copying files)

if not exist %MAIN_APP_DESTINATION_DIR% (
	mkdir %MAIN_APP_DESTINATION_DIR%
)

echo f | XCOPY "%MAIN_APP:"=%" "%MAIN_APP_DESTINATION_DIR:"=%ProthPrimeSearch_app.exe" /S /Y

:: ---------- WORK_GENERATOR (copying files)

if not exist %WORK_GENERATOR_DESTINATION_DIR% (
	mkdir %WORK_GENERATOR_DESTINATION_DIR%
)

XCOPY "%WORK_GENERATOR_DIR:"=%Base_Boinc_WorkGenerator.cpp" %WORK_GENERATOR_DESTINATION_DIR% /S /Y
XCOPY "%WORK_GENERATOR_DIR:"=%Base_Boinc_WorkGenerator.h" %WORK_GENERATOR_DESTINATION_DIR% /S /Y
XCOPY "%WORK_GENERATOR_DIR:"=%%ProjectFolder:"=%ProthPrimeNumbers_Boinc_WorkGenMain.cpp" %WORK_GENERATOR_DESTINATION_DIR% /S /Y
XCOPY "%WORK_GENERATOR_DIR:"=%%ProjectFolder:"=%ProthPrimeNumbers_WorkGenerator.cpp" %WORK_GENERATOR_DESTINATION_DIR% /S /Y
XCOPY "%WORK_GENERATOR_DIR:"=%%ProjectFolder:"=%ProthPrimeNumbers_WorkGenerator.h" %WORK_GENERATOR_DESTINATION_DIR% /S /Y
XCOPY "%WORK_GENERATOR_DIR:"=%%ProjectFolder:"=%Makefile" %WORK_GENERATOR_DESTINATION_DIR% /S /Y


:: ---------- RESULTS_VALIDATOR (copying files)

if not exist %WORK_GENERATOR_DESTINATION_DIR% (
	mkdir %WORK_GENERATOR_DESTINATION_DIR%
)

XCOPY "%RESULTS_VALIDATOR_DIR:"=%%ProjectFolder:"=%ProthPrimeNumbers_ResultsValidator.cpp" %RESULTS_VALIDATOR_DESTINATION_DIR% /S /Y
XCOPY "%RESULTS_VALIDATOR_DIR:"=%%ProjectFolder:"=%ProthPrimeNumbers_ResultsValidator.h" %RESULTS_VALIDATOR_DESTINATION_DIR% /S /Y
XCOPY "%RESULTS_VALIDATOR_DIR:"=%%ProjectFolder:"=%ProthPrimeNumbers_BoincValidator.cpp" %RESULTS_VALIDATOR_DESTINATION_DIR% /S /Y
XCOPY "%RESULTS_VALIDATOR_DIR:"=%%ProjectFolder:"=%my_boinc_utils.h" %RESULTS_VALIDATOR_DESTINATION_DIR% /S /Y
XCOPY "%RESULTS_VALIDATOR_DIR:"=%%ProjectFolder:"=%Makefile" %RESULTS_VALIDATOR_DESTINATION_DIR% /S /Y


:: ---------- ASIMILATOR (copying files)

if not exist %ASIMILATOR_DESTINATION_DIR% (
	mkdir %ASIMILATOR_DESTINATION_DIR%
)

XCOPY "%ASIMILATOR_DIR:"=%%ProjectFolder:"=%my_boinc_utils.h" %ASIMILATOR_DESTINATION_DIR% /S /Y
XCOPY "%ASIMILATOR_DIR:"=%%ProjectFolder:"=%ProthPrimeNumbers_Boinc_assim_handler.cpp" %ASIMILATOR_DESTINATION_DIR% /S /Y
XCOPY "%ASIMILATOR_DIR:"=%%ProjectFolder:"=%ProthPrimeNumbers_ResultsAssimilator.cpp" %ASIMILATOR_DESTINATION_DIR% /S /Y
XCOPY "%ASIMILATOR_DIR:"=%%ProjectFolder:"=%ProthPrimeNumbers_ResultsAssimilator.h" %ASIMILATOR_DESTINATION_DIR% /S /Y
XCOPY "%ASIMILATOR_DIR:"=%%ProjectFolder:"=%Makefile" %ASIMILATOR_DESTINATION_DIR% /S /Y

if defined DefaultPause pause

