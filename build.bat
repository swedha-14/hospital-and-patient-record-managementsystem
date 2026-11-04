@echo off
REM ============================================================================
REM Patient Record Management System - Automated Build & Test Script for Windows
REM ============================================================================

echo [INFO] Checking for Maven...
where mvn >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    echo [INFO] Found system Maven. Running 'mvn clean package'...
    mvn clean package
) else (
    echo [INFO] Checking installed portable Maven...
    if exist "C:\Users\USER\.maven\apache-maven-3.9.6\bin\mvn.cmd" (
        "C:\Users\USER\.maven\apache-maven-3.9.6\bin\mvn.cmd" clean package
    ) else (
        echo [ERROR] Maven not found in PATH or at C:\Users\USER\.maven\apache-maven-3.9.6\bin\mvn.cmd.
        echo Please ensure Apache Maven is installed and added to your system PATH.
        exit /b 1
    )
)

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ============================================================================
    echo [SUCCESS] Build completed successfully!
    echo WAR file generated at: target\patient-management-system.war
    if exist "%~dp0tomcat-9\webapps" (
        echo [INFO] Updating local Tomcat 9 deployment...
        copy /y "%~dp0target\patient-management-system.war" "%~dp0tomcat-9\webapps\patient-management-system.war" >nul
        copy /y "%~dp0target\patient-management-system.war" "%~dp0tomcat-9\webapps\ROOT.war" >nul
        echo [INFO] Ready to run using run.bat!
    )
    echo ============================================================================
) else (
    echo.
    echo [ERROR] Build failed. Please review error messages above.
)
pause
