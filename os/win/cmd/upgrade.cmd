
/windows/system32/curl https://s.netplayarcade.com/file/arcade/version.txt -o tmp.txt 2> nul
fc /L net-ra\version.txt tmp.txt | find "***">NUL
IF NOT ERRORLEVEL 1 (
  ECHO Upgrading net-ra...
  /windows/system32/curl -L https://s.netplayarcade.com/file/arcade/net-ra.exe -o net-ra.exe
  .\net-ra -y -o.
)
