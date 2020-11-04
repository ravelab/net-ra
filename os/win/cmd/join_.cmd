setlocal enabledelayedexpansion

@set server=https://NetplayArcade.com
:: set server=http://192.168.1.140:3000

call net-ra\default
call net-ra\nickname nickname

FOR /F "usebackq delims=" %%b IN (`\windows\system32\curl -s -X GET -H "Content-Type: text/plain" %server%/api/games?id^=%1`) do (SET gameInfo=%%b)

:: echo %gameInfo%

for %%a in ("%gameInfo:^=" "%") do (
  set line=%%~a
  if not "!line!"=="!line:emulator=!" (
    set emulator=!line:~9!
  )
  if not "!line!"=="!line:address-port=!" (
    set addressport=!line:~13!
    FOR /F "tokens=1,2 delims=:" %%g IN ("!addressport!") do (
      set address=%%g
	  set port=%%h
	)
  )
    if not "!line!"=="!line:url=!" (
    set url=!line:~4!
  )
)

call net-ra\core %emulator%

set filename=tmp.zip
IF "%emulator%" == "fbneo_libretro" (
  for %%a in ("%url%") do (
    set "urlPath=!url:%%~NXa=!"
    set "filename=%%~NXa"
  )
)

\windows\system32\curl -g -o "%TEMP%\%filename%" -L "!url: H=%%20H!"

IF "%emulator%" == "mednafen_saturn_libretro" (
  for %%a in ("%url%") do (
    set "urlPath=!url:%%~NXa=!"
    set "rom=%%~NXa"
  )
  set rom=!rom:~0,-4!
  powershell -ExecutionPolicy ByPass -Command "Expand-Archive -Force %TEMP%\%filename% %TEMP%\tmp"
  del "%TEMP%\%filename%"
  set filename=tmp\!rom!.cue
)

net-ra\retroarch --config net-ra/retroarch.cfg --appendconfig net-ra/required.cfg --libretro net-ra/cores/%emulator%.dll "%TEMP%\%filename%" --nick %nickname% --connect %address% --port %port%

IF "%emulator%" == "mednafen_saturn_libretro" (
  del /s /q "%TEMP%\tmp" > nul 2>&1
) ELSE (
  del "%TEMP%\%filename%"
)
