@echo off
set GroupYear=%~1
if %GroupYear%==1314 call:hrggroup1314
if not %GroupYear%==1314 call:hrggroup

goto:eof
:hrggroup1314
echo hrggroup1314 Called

goto:eof
:hrggroup
echo hrggroup Called
