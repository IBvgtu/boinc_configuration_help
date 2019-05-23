
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
set CMD_FILE="%UserProfile%\Desktop\Deploy\SendData.txt"

set DefaultPause=y
goto :NextAction

:Defined
set USER_NAME=%1
set SERVER_IP=%2
set SESSION_NAME=%3
set CMD_FILE=%4
:NextAction

:: Send data
psftp.exe -l %USER_NAME:"=% %USER_NAME:"=%@%SERVER_IP:"=% -load "%SESSION_NAME:"=%" -b "%CMD_FILE:"=%" -batch

if defined DefaultPause pause