@echo off
setlocal enabledelayedexpansion

title Patient Record Management System - Web Technology Assignment-II

REM Delegate to PowerShell runner for rich verification and live output
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0run.ps1"
