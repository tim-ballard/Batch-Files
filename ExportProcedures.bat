ECHO OFF
set Updated=%~1
if [%Updated%]==[] set Updated=1
sqlcmd -Q "EXECUTE [Admin].[sp_BackupAllProcedures] %Updated%" -S SQL -d Admin
PAUSE