@echo off 
:: GroupType's A&E=EM	IP=APC	OP=NAC
set GroupType=%1
set GroupYear=%2
set Populate=[%3]
if %Populate%==[1] call:PopulateInput
if %GroupYear% LSS 1314 call:hrggroupold
if not %GroupYear% LSS 1314 call:hrggroup
call:GrouperLaunch

goto:eof
:PopulateInput
bcp "SELECT * FROM [nhs_CDS_access].[dbo].[PbR_%GroupType%_Grouper_Input]" queryout "%~dp0Inputs\%GroupType%_HRG_Input.csv"  -c -t "," -T -S BIDEV1

goto:eof
:hrggroupold
for /F "tokens=1,2 delims==" %%i in ('GroupLookup.bat') do (
if %%i EQU %GroupYear%%GroupType%Logic set Logic=%%j
if %%i EQU %GroupYear%Grouper set Grouper=%%j
if %%i EQU %GroupYear%Definition set Definition=%%j
) 

goto:eof
:hrggroup
set Logic=%GroupType%
set Grouper=hrg-grouper.exe
set Definition=\sample_rdf

goto:eof
:GrouperLaunch
START "%GroupYear% %GroupType% Grouping" /D"%~dp0%GroupYear%" /WAIT "%~dp0%GroupYear%\%Grouper%" -i "%~dp0Inputs\%GroupType%_HRG_Input.csv" -o "%~dp0%GroupYear%\%GroupType%\%GroupType%_HRG_%GroupYear%_Output.csv" -d "%~dp0%GroupYear%%Definition%\HRG4_sample_%GroupType%.rdf" -l %Logic%

goto:eof