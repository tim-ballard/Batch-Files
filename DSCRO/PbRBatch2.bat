@echo off 
REM call:SetType EM
call:SetType APC
REM call:SetType NAC

goto:eof
:SetType
set GroupType=%~1
call:FileExport 1314
REM call:group 1314 
call:group 1415
REM call:group C1415 
REM ImportOutputFiles.bat

goto:eof
:FileExport
REM osql -E -Q "EXEC TIS.[PbR].[EXPORT_HRG_Input] '%GroupType%', '%~1'"
bcp TIS.dbo.DMIC_Extract_HRG_temp out Inputs\%GroupType%_HRG_Input.csv  -c -t "," -T -S TISLOAD

goto:eof
:group
REM Set Global Variables
set GroupYear=%~1

REM First configures local grouping logic then runs grouper
call:hrggroup%GroupYear% 
call:GrouperLaunch
call:ImportConfig

goto:eof
:hrggroup1314
IF %GroupType%==APC (
set Logic=apc_v46lp.tre 
)
IF %GroupType%==NAC (
set Logic=nap_v46lp.tre
)
IF %GroupType%==EM (
set Logic=em_v46lp.tre
)
set Grouper=HRGGrouper.exe
set Definition=

goto:eof
:hrggroupC1415
set Logic=%GroupType%
set Grouper=hrg-grouper.exe
set Definition=\sample_rdf

goto:eof
:hrggroup1415
set Logic=%GroupType%
set Grouper=hrg-grouper.exe
set Definition=\sample_rdf

goto:eof
:GrouperLaunch
START "%GroupYear% %GroupType% Grouping" /D"%~dp0Groupers\%GroupYear%" /WAIT "%~dp0Groupers\%GroupYear%\%Grouper%" -i "%~dp0Inputs\%GroupType%_HRG_Input.csv" -o "%~dp0Groupers\%GroupYear%\%GroupType%\%GroupType%_HRG_%GroupYear%_Output.csv" -d "%~dp0Groupers\%GroupYear%%Definition%\HRG4_sample_%GroupType%.rdf" -l %Logic%

goto:eof
:ImportConfig
IF %GroupType%==EM (
call:import Output_attend
)
IF %GroupType%==NAC (
call:import Output_attend
)
IF %GroupType%==APC (
call:import Output_FCE
call:import Output_Flag_rel
call:import Output_spell_rel
)

goto:eof
:import
set OutFile=%~1

osql -E -Q "DELETE FROM [TIS].[PbR].[%GroupType%_HRG_%GroupYear%_%OutFile%]"
bcp [TIS].[PbR].[%GroupType%_HRG_%GroupYear%_%OutFile%] in "%~dp0Groupers\%GroupYear%\%GroupType%\%GroupType%_HRG_%GroupYear%_%OutFile%.csv" -c -F 2 -t "," -T -S TISLOAD
goto:eof