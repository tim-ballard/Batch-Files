@ECHO OFF
set /p Password="Enter new password: "
if [%Password%]==[] goto:eof
sqlcmd -Q "EXECUTE [Admin].[sp_EmailPasswordUpdate] @Password = '%Password%', @User = 'tballard@nhs.net'" -S SQL -d Admin
PAUSE