@echo off 
REM GroupType's A&E=EM	IP=APC	OP=NAC
set GroupType=%1
set GroupYear=%2
set Populate=_%3
if %Populate%==_1 call:PopulateInput
call:hrggroup
call:GrouperLaunch

goto:eof
:PopulateInput
bcp "SELECT * FROM [nhs_CDS_access].[dbo].[PbR_%GroupType%_Grouper_Input]" queryout "%~dp0Inputs\%GroupType%_HRG_Input.csv"  -c -t "," -T -S BIDEV1

goto:eof
:hrggroup
set Logic=%GroupType%
set Grouper=hrg-grouper.exe
set Definition=\sample_rdf

goto:eof
:GrouperLaunch
START "%GroupYear% %GroupType% Grouping" /D"%~dp0%GroupYear%" /WAIT "%~dp0%GroupYear%\%Grouper%" -i "%~dp0Inputs\%GroupType%_HRG_Input.csv" -o "%~dp0%GroupYear%\%GroupType%\%GroupType%_HRG_%GroupYear%_Output.csv" -d "%~dp0%GroupYear%%Definition%\HRG4_sample_%GroupType%.rdf" -l %Logic%

goto:eof