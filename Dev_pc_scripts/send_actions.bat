
@echo off

IF NOT [%1] == [] (
	IF NOT [%2] == [] (
		IF NOT [%3] == [] (
			IF NOT [%4] == [] (
				goto :Defined
			)
		)
	)
)

set USER_NAME="boincadm"
set SERVER_IP="25.9.156.110"
set SESSION_NAME="MySession"
set CMD_FILE="%UserProfile%\Desktop\Deploy\SendActions.txt"

set DefaultPause=y
goto :NextAction

:Defined
set USER_NAME=%1
set SERVER_IP=%2
set SESSION_NAME=%3
set CMD_FILE=%4
:NextAction

:: Send actions
plink.exe -ssh -l %USER_NAME:"=%  %USER_NAME:"=%@%SERVER_IP:"=% -load "%SESSION_NAME:"=%" -m "%CMD_FILE:"=%" -batch

if defined DefaultPause pause