@echo off
 
set GroupYear=%1

if %GroupYear% LSS 1314 echo Less than 1314
if not %GroupYear% LSS 1314 echo Greater than 1314