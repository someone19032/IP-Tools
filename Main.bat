@echo off
chcp 65001 >nul
title IP Tools
setlocal enabledelayedexpansion

:main
cls
echo.
echo [38;5;196m
echo [38;2;128;0;0m ██▓ ██▓███      ██▓ ███▄    █   █████▒ ▒█████  
echo [38;2;160;0;0m▓██▒▓██░  ██▒   ▓██▒ ██ ▀█   █ ▓██   ▒ ▒██▒  ██▒
echo [38;2;192;0;0m▒██▒▓██░ ██▓▒   ▒██▒▓██  ▀█ ██▒▒████ ░ ▒██░  ██▒
echo [38;2;224;0;0m░██░▒██▄█▓▒ ▒   ░██░▓██▒  ▐▌██▒░▓█▒  ░ ▒██   ██░
echo [38;2;255;50;50m░██░▒██▒ ░  ░   ░██░▒██░   ▓██░░▒█░    ░ ████▓▒░
echo [38;2;255;100;100m░▓  ▒▓▒░ ░  ░   ░▓  ░ ▒░   ▒ ▒  ▒ ░    ░ ▒░▒░▒░ 
echo [38;2;255;150;150m ▒ ░░▒ ░         ▒ ░░ ░░   ░ ▒░ ░        ░ ▒ ▒░ 
echo [38;2;255;200;200m ▒ ░░░           ▒ ░   ░   ░ ░  ░ ░    ░ ░ ░ ▒  
echo [38;2;255;230;230m ░               ░           ░             ░ ░   
echo.
echo [38;2;128;0;0m[1] [0mIP Geolocation Lookup
echo [38;2;128;0;0m[2] [0mCreate IP Grabber
echo [38;2;128;0;0m[3] [0mCheck My IP
echo [38;2;128;0;0m[4] [0mIP Generator
echo [38;2;128;0;0m[5] [0mScan IP Addresses
echo [38;2;128;0;0m[6] [0mPort Scanner
echo [38;2;128;0;0m[7] [0mReverse DNS Lookup
echo [38;2;128;0;0m[8] [0mHelp / About
echo [38;2;128;0;0m[9] [0mExit
echo.

set /p choice=[38;2;128;0;0mSelect option:[0m 

if "%choice%"=="1" goto geolookup
if "%choice%"=="2" goto creategrabber
if "%choice%"=="3" goto myip
if "%choice%"=="4" goto ipgen
if "%choice%"=="5" goto scanips
if "%choice%"=="6" goto portscan
if "%choice%"=="7" goto reversedns
if "%choice%"=="8" goto help
if "%choice%"=="9" exit

echo [38;5;196mInvalid selection![0m
timeout /t 1 >nul
goto main

:geolookup
cls
set /p ip=[38;2;128;0;0mEnter IP address: [0m
curl -s "http://ip-api.com/json/%ip%?fields=status,message,country,countryCode,region,regionName,city,zip,lat,lon,timezone,isp,org,as,proxy" > temp.json
findstr /C:"\"status\":\"success\"" temp.json >nul
if errorlevel 1 (
    echo [38;2;255;0;0m[!] Failed to retrieve info. Check your IP or connection.[0m
) else (
    type temp.json
)
del temp.json
pause >nul
goto main

:myip
cls
echo.
echo [38;2;128;0;0mGetting your public IP...[0m
curl -s https://api.ipify.org
echo.
pause >nul
goto main

:creategrabber
cls
echo [38;2;128;0;0mLoading...
python CreateGrabber.py
pause >nul
goto main

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
set /p savefile=[38;2;128;0;0mSave results to file (leave blank to skip): [0m
echo.
set valid=0
:generateloop
set /a octet1=%random% %% 256
set /a octet2=%random% %% 256
set /a octet3=%random% %% 256
set /a octet4=%random% %% 256
set ip=%octet1%.%octet2%.%octet3%.%octet4%

if %octet1% equ 0 goto generateloop
if %octet1% equ 10 goto generateloop
if %octet1% equ 127 goto generateloop
if %octet1% equ 169 if %octet2% equ 254 goto generateloop
if %octet1% equ 172 if %octet2% geq 16 if %octet2% leq 31 goto generateloop
if %octet1% equ 192 if %octet2% equ 168 goto generateloop
if %octet1% geq 224 goto generateloop

set /a valid+=1

if "%output%"=="1" (
    echo [38;2;128;0;0m[!] Valid IP: %ip%[0m
) else (
    curl -s -H "Content-Type: application/json" -X POST -d "{\"content\":\"Valid IP: %ip%\"}" %webhook% >nul
)

if not "%savefile%"=="" echo %ip%>>%savefile%

if %valid% lss %count% goto generateloop

echo.
echo [38;2;128;0;0mDone! Generated %count% valid IP addresses.[0m
echo.
pause >nul
goto main

:scanips
cls
setlocal enabledelayedexpansion
echo [38;2;128;0;0mDetecting local IP address...[0m
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /i "IPv4"') do set LOCAL_IP=%%a
set LOCAL_IP=%LOCAL_IP:~1%
if not defined LOCAL_IP (
    echo [38;2;255;0;0mCould not detect local IP address.[0m
    pause >nul
    goto main
)
for /f "tokens=1,2,3 delims=." %%b in ("!LOCAL_IP!") do set PREFIX=%%b.%%c.%%d
echo [38;2;128;0;0mScanning: !PREFIX!.1 - .254[0m
for /L %%i in (1,1,254) do (
    ping -n 1 -w 1000 !PREFIX!.%%i | findstr /i "Reply" >nul
    if !errorlevel! equ 0 (
        echo [38;2;0;255;0mIP !PREFIX!.%%i is active.[0m
    )
)
pause >nul
goto main

:portscan
cls
set /p ip=[38;2;128;0;0mEnter IP to scan: [0m
for %%p in (21 22 23 25 53 80 110 135 139 143 443 445 3306 3389) do (
    echo [38;2;128;0;0mScanning port %%p...[0m
    powershell -Command "(New-Object Net.Sockets.TcpClient).Connect('%ip%', %%p)" 2>nul && echo [38;2;0;255;0mPort %%p is open.[0m
)
pause >nul
goto main

:reversedns
cls
set /p ip=[38;2;128;0;0mEnter IP for reverse DNS lookup: [0m
nslookup %ip%
pause >nul
goto main

:help
cls
echo [38;2;128;0;0mIP Tools Utility[0m
echo Developed by kao_someone on DC
echo Features:
echo - IP Geolocation
echo - IP Grabber Launcher
echo - IP Generator with saving and Discord output
echo - Port Scanning
echo - Reverse DNS
echo - Local IP Scanner
echo.
pause >nul
goto main
