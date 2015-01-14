@echo off
setlocal EnableDelayedExpansion
set Id=%~1
REM Section1 Empties Folder of XML Files
REM Section2 Prepares Data Tables for Consented Patients only
REM Section3 Runs Stored Procedure to generate XML
REM Section4 Delete existing GPG files, Compress and Encrypt XML files
REM Section5 FTP Files to PatientView 
IF NOT [%Id%]==[] (
call:Section%Id%
)
IF [%Id%]==[] (
call:Section1
call:Section2
call:Section3
call:Section4
call:Section5
)
goto:eof
:Section1
for %%F in ("%~dp0XML\*.xml") do (
	DEL %%~fF
)
goto:eof
:Section2
osql -E -Q "EXEC [SIR_An].[dbo].[DiabetesPatientView_CreateTables]"

goto:eof
:Section3
osql -E -Q "EXEC [SIR_An].[dbo].[DiabetesPatientView_XML_FileOut]"

goto:eof
:Section4
for %%I in ("%~dp0EncryptedFiles\*.gpg") do (
	DEL %%~fI
)
for %%F in ("%~dp0XML\*.xml") do (
	set fn=%%~nxF
	set filename=%%~nF
	gpg --batch -e -o "%~dp0EncryptedFiles\!filename!.gpg"  -r "info@renalpatientview.org" "%~dp0XML\!fn!"
)
goto:eof
:Section5
"%~dp0WinSCP\"WinSCP.com -script="%~dp0WinSCP\"PV_FTPSetttings.txt

goto:eof