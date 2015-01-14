@echo off 

call:config 1314 1
call:config 1415 2
pause
goto:eof


:config
call:import%~2 %~1 APC Output_FCE
call:import%~2 %~1 APC Output_Flag_rel
call:import%~2 %~1 APC Output_spell_rel
REM call:import%~2 %~1 NAC Output_attend
REM call:import%~2 %~1 EM Output_attend
goto:eof


:import1
set GroupYear=%~1
set GroupType=%~2
set OutFile=%~3


osql -E -Q "DELETE FROM [TIS].[PbR].[%GroupType%_HRG_%GroupYear%_%OutFile%]"
bcp [TIS].[PbR].[%GroupType%_HRG_%GroupYear%_%OutFile%] in "%~dp0Groupers\%GroupYear%\%GroupType%\%GroupType%_HRG_%GroupYear%_%OutFile%.csv" -c -F 2 -t "," -T -S TISLOAD
goto:eof


:import2
set GroupYear=%~1
set GroupType=%~2
set OutFile=%~3


osql -E -Q "DELETE FROM [TIS].[PbR].[%GroupType%_HRG_%GroupYear%_%OutFile%]"
bcp [TIS].[PbR].[%GroupType%_HRG_%GroupYear%_%OutFile%] in "%~dp0Groupers\C%GroupYear%\%GroupType%\%GroupType%_HRG_C%GroupYear%_%OutFile%.csv" -c -F 2 -t "," -T -S TISLOAD
goto:eof