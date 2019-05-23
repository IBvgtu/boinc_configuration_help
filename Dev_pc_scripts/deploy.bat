
cls
@echo off

set UserName="boincadm"
set ServerIP="25.9.156.110"
set SessionName="MySession"

set RootDir="%UserProfile%\Desktop\Source\"
set DeployDir="%UserProfile%\Desktop\Deploy\"
set SendDataCommandsFile="%DeployDir:"=%SendData.txt"
set SendActionsCommandsFile="%DeployDir:"=%SendActions.txt"



:: (1) Get all files to deploy
 
call get_files.bat %RootDir% %DeployDir%

if %errorlevel% gtr 0 (
	echo @@@@@@ Process failed 'get_files.bat'
	pause
	exit /b 1
)

:: (2) Send files to server

call send_data.bat %UserName% %ServerIP% %SessionName% %SendDataCommandsFile%

if %errorlevel% gtr 0 (
	echo @@@@@@ Process failed 'send_data.bat'
	pause
	exit /b 1
)

:: (3) Send actions to server

call send_actions.bat %UserName% %ServerIP% %SessionName% %SendActionsCommandsFile%

if %errorlevel% gtr 0 (
	echo @@@@@@ Process failed 'send_actions.bat'
	pause
	exit /b 1
)

echo ================ Completed ================
pause