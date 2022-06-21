@echo off


echo 504msf_exercise.bat
echo.
echo This script will start the lanmanserver service if it is not already running, and change the value of the following registry keys:
echo hklm\software\microsoft\windows\currentversion\policies\system\LocalAccountTokenFilterPolicy = 1
echo hklm\system\currentcontrolset\control\lsa\ForceGuest = 0
echo hklm\system\currentcontrolset\control\lsa\LmCompatibilityLevel = 0
echo.
echo This script will also create a script on your Desktop called 504msf_restore.bat that will restore each setting to its original value.
echo.
echo Is it okay to proceed?
pause
echo.


REM Create beginning of restore script (if "." is passed, script will be created in current directory instead of Desktop)
if [%1]==[.] (
   set RESTOREFILE=.\504msf_restore.bat
) else (
   set RESTOREFILE=%USERPROFILE%\Desktop\504msf_restore.bat
)
if exist "%RESTOREFILE%" (
  echo.
  echo The 504msf_restore.bat file already exists.  Please run it and then delete it before running this script again so that you don't lose your original settings!
  pause
  exit /B 1
)
echo @echo off > "%RESTOREFILE%"
echo at ^> nul >> "%RESTOREFILE%"
echo if %%ERRORLEVEL%% NEQ 0 ( >> "%RESTOREFILE%"
echo    echo Please run this script with elevated privileges! >> "%RESTOREFILE%"
echo    pause >> "%RESTOREFILE%"
echo    exit /B 1 >> "%RESTOREFILE%"
echo ) >> "%RESTOREFILE%"
echo echo 504msf_restore.bat >> "%RESTOREFILE%"
echo echo. >> "%RESTOREFILE%"
echo echo This script will revert the system settings changed by 504msf_exercise.bat back to their original settings on this system. >> "%RESTOREFILE%"
echo echo. >> "%RESTOREFILE%"
echo echo Is it okay to proceed? >> "%RESTOREFILE%"
echo pause >> "%RESTOREFILE%"
echo echo. >> "%RESTOREFILE%"


REM Start the lanmanserver service if it isn't working
sc query lanmanserver | findstr RUNNING >nul
if %ERRORLEVEL% EQU 1 (
   echo Running: sc start lanmanserver
   sc start lanmanserver
   echo.
   echo echo Running: sc stop lanmanserver >> "%RESTOREFILE%"
   echo sc stop lanmanserver >> "%RESTOREFILE%"
   echo echo. >> "%RESTOREFILE%"
)

REM Global findstr command (used in all subsequent reg queries)
set fnd=findstr /I /L /C:"REG_DWORD"

REM TokenFilter check
set qry=reg query "hklm\software\microsoft\windows\currentversion\policies\system" /v LocalAccountTokenFilterPolicy
%qry% >nul 2>nul
if %ERRORLEVEL% EQU 1 (set TOKENFILTER=DELME) else (
for /f "Tokens=2*" %%a in ('%qry%^|%fnd%') do (
 @set TOKENFILTER=%%b
)
)
echo Running: reg add hklm\software\microsoft\windows\currentversion\policies\system /v LocalAccountTokenFilterPolicy /t REG_DWORD /d 1 /f
reg add hklm\software\microsoft\windows\currentversion\policies\system /v LocalAccountTokenFilterPolicy /t REG_DWORD /d 1 /f
echo.
if %TOKENFILTER%==DELME (
   echo echo Running: reg delete hklm\software\microsoft\windows\currentversion\policies\system /v LocalAccountTokenFilterPolicy /f >> "%RESTOREFILE%"
   echo reg delete hklm\software\microsoft\windows\currentversion\policies\system /v LocalAccountTokenFilterPolicy /f >> "%RESTOREFILE%"
   echo echo. >> "%RESTOREFILE%"
) else (
   echo echo Running: reg add hklm\software\microsoft\windows\currentversion\policies\system /v LocalAccountTokenFilterPolicy /t REG_DWORD /d %TOKENFILTER% /f >> "%RESTOREFILE%"
   echo reg add hklm\software\microsoft\windows\currentversion\policies\system /v LocalAccountTokenFilterPolicy /t REG_DWORD /d %TOKENFILTER% /f >> "%RESTOREFILE%"
   echo echo. >> "%RESTOREFILE%"
)


REM ForceGuest check
set qry=reg query "HKLM\System\CurrentControlSet\Control\Lsa" /v ForceGuest
%qry% >nul 2>nul
if %ERRORLEVEL% EQU 1 (set FORCEGUEST=DELME) else (
for /f "Tokens=2*" %%a in ('%qry%^|%fnd%') do (
 @set FORCEGUEST=%%b
)
)
echo Running: reg add hklm\system\currentcontrolset\control\lsa /v ForceGuest /t REG_DWORD /d 0 /f
reg add hklm\system\currentcontrolset\control\lsa /v ForceGuest /t REG_DWORD /d 0 /f
echo.
if %FORCEGUEST%==DELME (
   echo echo Running: reg delete hklm\system\currentcontrolset\control\lsa /v ForceGuest /f >> "%RESTOREFILE%"
   echo reg delete hklm\system\currentcontrolset\control\lsa /v ForceGuest /f >> "%RESTOREFILE%"
   echo echo. >> "%RESTOREFILE%"
) else (
   echo echo Running: reg add hklm\system\currentcontrolset\control\lsa /v ForceGuest /t REG_DWORD /d %FORCEGUEST% /f >> "%RESTOREFILE%"
   echo reg add hklm\system\currentcontrolset\control\lsa /v ForceGuest /t REG_DWORD /d %FORCEGUEST% /f >> "%RESTOREFILE%"
   echo echo. >> "%RESTOREFILE%"
)


REM LmCompatibilityLevel check
set qry=reg query "HKLM\System\CurrentControlSet\Control\Lsa" /v LmCompatibilityLevel
%qry% >nul 2>nul
if %ERRORLEVEL% EQU 1 (set LMCOMPAT=DELME) else (
for /f "Tokens=2*" %%a in ('%qry%^|%fnd%') do (
 @set LMCOMPAT=%%b
)
)
echo Running: reg add hklm\system\currentcontrolset\control\lsa /v LmCompatibilityLevel /t REG_DWORD /d 0 /f
reg add hklm\system\currentcontrolset\control\lsa /v LmCompatibilityLevel /t REG_DWORD /d 0 /f
echo.
if %LMCOMPAT%==DELME (
   echo echo Running: reg delete hklm\system\currentcontrolset\control\lsa /v LmCompatibilityLevel /f >> "%RESTOREFILE%"
   echo reg delete hklm\system\currentcontrolset\control\lsa /v LmCompatibilityLevel /f >> "%RESTOREFILE%"
   echo echo. >> "%RESTOREFILE%"
) else (
   echo echo Running: reg add hklm\system\currentcontrolset\control\lsa /v LmCompatibilityLevel /t REG_DWORD /d %LMCOMPAT% /f >> "%RESTOREFILE%"
   echo reg add hklm\system\currentcontrolset\control\lsa /v LmCompatibilityLevel /t REG_DWORD /d %LMCOMPAT% /f >> "%RESTOREFILE%"
   echo echo. >> "%RESTOREFILE%"
)


echo Finished!
echo.
pause

echo echo Finished! >> "%RESTOREFILE%"
echo echo. >> "%RESTOREFILE%"
echo pause >> "%RESTOREFILE%"