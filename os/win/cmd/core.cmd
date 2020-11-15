set emulator=%1
set coreZipUrl=http://buildbot.libretro.com/nightly/windows/x86_64/latest/%emulator%.dll.zip
for %%a in (%coreZipUrl:/= %) do set coreZip=%%a
set coreBin=%coreZip:~0,-4%

IF "%emulator%" == "fbneo_libretro" (
  call net-ra\fbneo
)
IF "%emulator%" == "mednafen_saturn_libretro" (
  call net-ra\mednafen_saturn
)

IF NOT EXIST "net-ra\cores\%coreBin%" (
  \windows\system32\curl -s -o net-ra\cores\%coreZip% -L %coreZipUrl%
  powershell -ExecutionPolicy ByPass -Command "Expand-Archive -Force net-ra/cores/%coreZip% net-ra/cores"
  del net-ra\cores\%coreZip%
)

