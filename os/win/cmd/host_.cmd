call net-ra\default
call net-ra\nickname nickname

del net-ra\logs\retroarch.log > nul 2>&1
start /b net-ra\retroarch --config net-ra/retroarch.cfg --appendconfig net-ra/required.cfg --nick %nickname% --host > nul 2>&1

call net-ra\mednafen_saturn
call net-ra\post