@echo off

:Print
if "%1"=="" goto end
echo print %1 
shift
goto Print

:end
echo All done
