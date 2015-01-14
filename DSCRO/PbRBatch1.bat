REM @echo off 
cd "%~dp0"
del Outputs\*.zip
call:Config APC 1314
call:Config APC 1415
call:Config OP 1314
call:Config OP 1415
call:Config EM 1314
call:Config EM 1415

goto:eof
:Config
set Type=%~1
set Year=%~2
call:FileExport 00T 5HQ 
call:FileExport 00V 5JX
call:FileExport 00W 5NT
call:FileExport 01D 5NQ
call:FileExport 01M 
call:FileExport 00Y 5J5
call:FileExport 01G 5F5
call:FileExport 01N 
call:FileExport 01W 5F7
call:FileExport 01Y 5LH
call:FileExport 02A 5NR
call:FileExport 02H 5HG

goto:eof
:FileExport
set CCG=%~1
set PCT=%~2
cd "%~dp0"
bcp "EXEC TIS.[PbR].[EXPORT_%Type%_Tariff] '%CCG%','%Year%','%PCT%'" queryout Outputs\RoadTesting_%Type%_%CCG%_HRG%Year%_Output.csv  -c -t "," -T -S TISLOAD
copy /b Outputs\Headers\%Type%.csv+Outputs\RoadTesting_%Type%_%CCG%_HRG%Year%_Output.csv Outputs\RoadTesting_%Type%_%CCG%_HRG%Year%.csv
del Outputs\RoadTesting_%Type%_%CCG%_HRG%Year%_Output.csv
cd "%~dp0"Outputs
f:\7za  a -tzip RoadTesting_%Type%_%CCG%_HRG%Year%.zip RoadTesting_%Type%_%CCG%_HRG%Year%.csv
del RoadTesting_%Type%_%CCG%_HRG%Year%.csv
del "F:\FTP Server\%CCG%\PBR\RoadTesting\RoadTesting_%Type%_%CCG%_HRG%Year%.zip"
move RoadTesting_%Type%_%CCG%_HRG%Year%.zip "F:\FTP Server\%CCG%\PBR\RoadTesting"
goto:eof


