@echo off
chcp 65001 >nul
title IP Grabber Creator
setlocal enableDelayedExpansion

:main
cls
echo.
echo [38;5;196m▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
echo [38;2;128;0;0m ██▓ ██▓███      ██▓ ███▄    █   █████▒ ▒█████  
echo [38;2;160;0;0m▓██▒▓██░  ██▒   ▓██▒ ██ ▀█   █ ▓██   ▒ ▒██▒  ██▒
echo [38;2;192;0;0m▒██▒▓██░ ██▓▒   ▒██▒▓██  ▀█ ██▒▒████ ░ ▒██░  ██▒
echo [38;2;224;0;0m░██░▒██▄█▓▒ ▒   ░██░▓██▒  ▐▌██▒░▓█▒  ░ ▒██   ██░
echo [38;2;255;50;50m░██░▒██▒ ░  ░   ░██░▒██░   ▓██░░▒█░    ░ ████▓▒░
echo [38;2;255;100;100m░▓  ▒▓▒░ ░  ░   ░▓  ░ ▒░   ▒ ▒  ▒ ░    ░ ▒░▒░▒░ 
echo [38;2;255;150;150m ▒ ░░▒ ░         ▒ ░░ ░░   ░ ▒░ ░        ░ ▒ ▒░ 
echo [38;2;255;200;200m ▒ ░░░           ▒ ░   ░   ░ ░  ░ ░    ░ ░ ░ ▒  
echo [38;2;255;230;230m ░               ░           ░             ░ ░   
echo [38;5;52m                                         ░                                         
echo [38;5;196m▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
echo.
echo [38;2;128;0;0m[1] [0mIP Geolocation Lookup
echo [38;2;128;0;0m[2] [0mCreate IP Grabber
echo [38;2;128;0;0m[3] [0mCheck My IP
echo [38;2;128;0;0m[4] [0mExit
echo.

set /p choice=[38;2;128;0;0mSelect option:[0m 

if "%choice%"=="1" goto geolookup
if "%choice%"=="2" goto creategrabber
if "%choice%"=="3" goto myip
if "%choice%"=="4" exit

echo [38;5;196mInvalid selection![0m
timeout /t 1 >nul
goto main

:geolookup
cls
echo.
set /p ip=[38;2;128;0;0mEnter IP address: [0m
echo.
curl -s "http://ip-api.com/json/%ip%?fields=status,message,country,countryCode,region,regionName,city,zip,lat,lon,timezone,isp,org,as,proxy"
echo.
pause
goto main

:myip
cls
echo.
echo [38;2;128;0;0mGetting your public IP...[0m
curl -s https://api.ipify.org
echo.
pause
goto main

:creategrabber
cls
echo. [38;2;128;0;0m
python CreateGrabber.py
pause >nul
goto main