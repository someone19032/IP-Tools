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
echo [38;2;128;0;0m[4] [0mIP Generator
echo [38;2;128;0;0m[5] [0mExit
echo.

set /p choice=[38;2;128;0;0mSelect option:[0m 

if "%choice%"=="1" goto geolookup
if "%choice%"=="2" goto creategrabber
if "%choice%"=="3" goto myip
if "%choice%"=="4" goto ipgen
if "%choice%"=="5" exit

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

:ipgen
:ipgen
cls
echo.
echo [38;2;128;0;0m[1] Console output
echo [38;2;128;0;0m[2] Discord webhook[0m
echo.
set /p output=[38;2;128;0;0mSelect output method: [0m

if "%output%"=="2" (
    set /p webhook=[38;2;128;0;0mEnter Discord webhook URL: [0m
)

set /p count=[38;2;128;0;0mHow many valid IPs to generate: [0m
echo.
echo [38;2;128;0;0mGenerating %count% valid IP addresses...[0m
echo.

set valid=0
:generateloop
set /a octet1=%random% %% 256
set /a octet2=%random% %% 256
set /a octet3=%random% %% 256
set /a octet4=%random% %% 256

set ip=%octet1%.%octet2%.%octet3%.%octet4%

:: Check if IP is valid (not in private/reserved ranges)
if %octet1% equ 0 goto generateloop
if %octet1% equ 10 goto generateloop
if %octet1% equ 127 goto generateloop
if %octet1% equ 169 if %octet2% equ 254 goto generateloop
if %octet1% equ 172 if %octet2% geq 16 if %octet2% leq 31 goto generateloop
if %octet1% equ 192 if %octet2% equ 168 goto generateloop
if %octet1% geq 224 goto generateloop

:: If we get here, IP is valid
set /a valid+=1

if "%output%"=="1" (
    echo [38;2;128;0;0m[!] Valid IP: %ip%[0m
) else (
    curl -s -H "Content-Type: application/json" -X POST -d "{\"content\":\"Valid IP: %ip%\"}" %webhook% >nul
)

if %valid% lss %count% goto generateloop

echo.
echo [38;2;128;0;0mDone! Generated %count% valid IP addresses.[0m
echo.
pause
goto main
