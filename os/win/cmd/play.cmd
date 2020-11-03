@echo off
setlocal enabledelayedexpansion

call net-ra\nickname nickname

set romZipUrl=%2
set romZipUrl=%romZipUrl:"=%
for %%a in ("%romZipUrl%") do (
   set "urlPath=!romZipUrl:%%~NXa=!"
   set "romZip=%%~NXa"
)

:: host, alone, or (host-ip-address)
set connectType=%3
IF NOT [%4]==[] set port=--port %4

set emulator=%1%
call net-ra\core %emulator%

for /f "tokens=1 delims=." %%a in ("%romZip%") do (
  set romDir=%%a
)
  
IF "%emulator%" == "mednafen_saturn_libretro" IF EXIST "net-ra\roms\%romDir%" (
  GOTO DoneDownloading
)
  
\windows\system32\curl -g -o "net-ra\roms\%romZip%" -L --continue-at - "!romZipUrl: H=%%20H!"

:DoneDownloading

IF "%emulator%" == "mednafen_saturn_libretro" (
  :: set romDir=%romZip:~0,-4%
  IF NOT EXIST "net-ra\roms\!romDir!" (
	powershell -ExecutionPolicy ByPass -Command "Expand-Archive -Force 'net-ra\roms\%romZip%' 'net-ra\roms\!romDir!'"
	del "net-ra\roms\%romZip%"
  )
  set romZip=!romDir!\!romDir!.cue
)

IF "%connectType%" == "host" (
  set connectFlag=--host
) ELSE (
  IF "%connectType%" == "alone" (
    set connectFlag=
  ) ELSE (
      IF "%connectType%" == "" (
        set connectFlag=
      ) ELSE (
	    set connectFlag=--connect %connectType%
	  )
  )
)

call net-ra\default

del net-ra\logs\retroarch.log > nul 2>&1

start /b net-ra\retroarch --config net-ra/retroarch.cfg --appendconfig net-ra/required.cfg --libretro net-ra/cores/%emulator%.dll "net-ra\roms\%romZip%" --nick %nickname% %connectFlag% %port% > nul 2>&1

IF NOT "%connectType%" == "host" exit 0

call net-ra\post
