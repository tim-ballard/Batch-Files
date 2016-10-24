@echo off 
:: GroupType's A&E=EM	IP=APC	OP=NAC
set GroupType=%1
set GroupYear=%2
set Populate=[%3]
set Plus=
if %Populate%==[1] call:PopulateInput
if %GroupYear:~-4% GEQ 1718 call:hrggroupplus
if %GroupYear:~-4% LEQ 1314 call:hrggroupold
if not %GroupYear:~-4% LEQ 1314 (if not %GroupYear:~-4% GEQ 1718 (call:hrggroup))
call:GrouperLaunch

goto:eof
:PopulateInput
bcp "SELECT * FROM [Legacy].[dbo].[PbR_%GroupType%_Grouper_Input]" queryout "%~dp0Inputs\%GroupType%_HRG_Input.csv"  -c -t "," -T -S SGMVMRESDB45

goto:eof
:hrggroupold
for /F "tokens=1,2 delims==" %%i in ('%~dp0%GroupLookup.bat') do (
if %%i EQU %GroupYear%%GroupType%Logic set Logic=%%j
if %%i EQU %GroupYear%Grouper set Grouper=%%j
if %%i EQU %GroupYear%Definition set Definition=%%j
) 

goto:eof
:hrggroup
set Logic=%GroupType%
set Grouper=hrg-grouperc.exe
set Definition=\sample_rdf


goto:eof
:hrggroupplus
set Logic=%GroupType%
set Grouper=hrg-grouperc.exe
set Definition=\sample_rdf
set Plus=+


goto:eof
:GrouperLaunch
ECHO Grouper Running...
START "%GroupYear% %GroupType% Grouping" /D"%~dp0%GroupYear%" /WAIT "%~dp0%GroupYear%\%Grouper%" -i "%~dp0Inputs\%GroupType%_HRG_Input.csv" -o "%~dp0%GroupYear%\%GroupType%\%GroupType%_HRG_%GroupYear%_Output.csv" -d "%~dp0%GroupYear%%Definition%\HRG4%Plus%_sample_%GroupType%.rdf" -l %Logic%

goto:eof