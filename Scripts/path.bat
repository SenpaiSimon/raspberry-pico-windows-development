@echo off
IF %1.==. GOTO End
IF %2.==. GOTO End

setx -m path "%1;%2;%PATH%" >NUL 2>&1

:End