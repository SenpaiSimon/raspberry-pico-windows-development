@echo off
net session >nul
if %errorLevel% == 0 (
    echo 0
) else (
    echo 1
)