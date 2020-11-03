setlocal enabledelayedexpansion

:: set nickname if needed
set nicknamefile=net-ra/nickname.cfg
IF NOT EXIST %nicknamefile% (
  set /p nickname="Choose your nickname for netplay: "
  echo netplay_nickname = "!nickname!">%nicknamefile%
) ELSE (
  set /p nickname=<%nicknamefile%
  set nickname=!nickname:~20!
  set nickname=!nickname:~0,-1!
)

ENDLOCAL&set %~1=%nickname%
