@echo off
IF %1.==. GOTO End

set path="%1;%PATH%" >NUL 2>&1

:End