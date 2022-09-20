@echo off
setlocal EnableExtensions


title DS4Windows Installer


set "Choice[1]=Only Install DS4Windows"
set "Choice[2]=Install DS4Windows Including Dependencies"

set "Message="
:Menu
cls
echo.%Message%
echo.
set "x=0"
:MenuLoop
set /a "x+=1"
if defined Choice[%x%] (
    call echo   %x%. %%Choice[%x%]%%
    goto MenuLoop
)
echo.


:Prompt
set "Input="
set /p "Input=>>I Want to(1 or 2): "

if not defined Input goto Prompt
set "Input=%Input:"=%"
set "Input=%Input:^=%"
set "Input=%Input:<=%"
set "Input=%Input:>=%"
set "Input=%Input:&=%"
set "Input=%Input:|=%"
set "Input=%Input:(=%"
set "Input=%Input:)=%"

set "Input=%Input:^==%"
call :Validate %Input%

call :Process %Input%
goto End


:Validate
set "Next=%2"
if not defined Choice[%1] (
    set "Message=Invalid Input: %1"
    goto Menu
)
if defined Next shift & goto Validate
goto :eof


:Process
set "Next=%2"
call set "Choice=%%Choice[%1]%%"

if "%Choice%" EQU "Only Install DS4Windows" (
    
    powershell -Command "Invoke-WebRequest https://github.com/microsoft/winget-cli/releases/download/v1.3.2091/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle -OutFile Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
    powershell -Command "Invoke-WebRequest https://download.visualstudio.microsoft.com/download/pr/9dc77a6b-0276-4ad5-9bfa-d84b546686ef/f01bbcf2dc0e7f5dbd0a7d337fd4cd43/dotnet-runtime-6.0.9-win-x64.exe -OutFile dotnet-runtime-6.0.9-win-x64.exe"
) 

if "%Choice%" EQU "Install DS4Windows Including Dependencies" (
    echo Install-Module PackageManagement && winget install --id=ViGEm.ViGEmBus -e  && winget install --id=ViGEm.HidHide -e  && winget install --id=Microsoft.DotNet.Runtime.6 -e && powershell -Command "https://download.visualstudio.microsoft.com/download/pr/9dc77a6b-0276-4ad5-9bfa-d84b546686ef/f01bbcf2dc0e7f5dbd0a7d337fd4cd43/dotnet-runtime-6.0.9-win-x64.exe"
)
:: if "%Choice%" EQU "Exit The Script" echo exit
:: Prevent the command from being processed twice if listed twice.
set "Choice[%1]="
if defined Next shift & goto Process
goto :eof


:End
endlocal
pause >nul