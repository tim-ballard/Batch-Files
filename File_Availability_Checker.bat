@echo off
REM 1: File Available 0: File Locked 2: File Doesn't exist
set File=%~1
if exist "%File%" (
	2>nul (
	  >>"%File%" (call )
	) && (echo 1) || (echo 0)
) else (
  echo 2
)