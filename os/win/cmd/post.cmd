::@echo on

set server=https://NetplayArcade.com
:: set server=http://192.168.1.140:3000

set logfile=net-ra\logs\retroarch.log
:: wait for logfile to exists
:CheckForFile
IF EXIST %logfile% GOTO FoundLogFile

GOTO CheckForFile

:FoundLogFile

timeout 1 >NUL

copy /Y %logfile% tmp.log > nul 2>&1

for /f "delims=" %%a in ('findstr /C:"[netplay] Port Mapping Successful: " tmp.log') do set address_port=%%a
IF "%address_port%" == "" GOTO FoundLogFile
for %%a in (%address_port: = %) do set address_port=%%a

for /f "delims=" %%a in ('findstr /C:"[CORE]: Loading dynamic libretro core from: " tmp.log') do set emulator=%%a
for %%a in (%emulator:"= %) do set emulator=%%a
for %%a in (%emulator:/= %) do set emulator=%%a
for %%a in (%emulator:\= %) do set emulator=%%a
set emulator=%emulator:~0,-4%

for /f "delims=" %%a in ('findstr /C:"No game-specific overrides found at " tmp.log') do set title=%%a
set "title=%title:*found at =%"
set title=%title:~0,-5%
FOR %%i IN ("%title%") DO (
  set title=%%~ni%%~xi
)

for /f "delims=" %%a in ('findstr /C:"game's full name is " tmp.log') do set title=%%a
IF "%emulator%" == "fbneo_libretro" (
  set "title=%title:*name is =%"
)

::echo "title=%title%^host=%nickname%^emulator=%emulator%^address-port=%address_port%"

FOR /F "tokens=*" %%g IN ('\windows\system32\curl -s -X POST -H "Content-Type: text/plain" --data "title=%title%^host=%nickname%^emulator=%emulator%^address-port=%address_port%" %server%/api/games') do (SET token=%%g)

echo.
echo Tell you friends to paste and execute the following command in Windows PowerShell or Mac Terminal (after following the installation instruction on %server% ):
echo.
echo net-ra/join %token%
echo.

del tmp.log
