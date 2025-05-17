@echo off
chcp 65001 >nul
title IP Tools
setlocal enabledelayedexpansion
goto :main

:main
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set BS=%%A
set /a spacessCount=36
set "spacess="
for /L %%i in (1,1,%spacessCount%) do set "spacess=!spacess! "       	                    
cls
echo.
echo                                      [38;2;128;0;0m   ██▓ ██▓███      ██▓ ███▄    █   █████▒ ▒█████     Made by kao_someone on DC
echo                                      [38;2;160;0;0m  ▓██▒▓██░  ██▒   ▓██▒ ██ ▀█   █ ▓██   ▒ ▒██▒  ██▒
echo                                      [38;2;192;0;0m  ▒██▒▓██░ ██▓▒   ▒██▒▓██  ▀█ ██▒▒████ ░ ▒██░  ██▒
echo                                      [38;2;224;0;0m  ░██░▒██▄█▓▒ ▒   ░██░▓██▒  ▐▌██▒░▓█▒  ░ ▒██   ██░
echo                                      [38;2;255;50;50m  ░██░▒██▒ ░  ░   ░██░▒██░   ▓██░░▒█░    ░ ████▓▒░
echo                                      [38;2;255;100;100m  ░▓  ▒▓▒░ ░  ░   ░▓  ░ ▒░   ▒ ▒  ▒ ░    ░ ▒░▒░▒░ 
echo                                      [38;2;255;150;150m   ▒ ░░▒ ░         ▒ ░░ ░░   ░ ▒░ ░        ░ ▒ ▒░ 
echo                                      [38;2;255;200;200m   ▒ ░░░           ▒ ░   ░   ░ ░  ░ ░    ░ ░ ░ ▒  
echo                                      [38;2;255;230;230m   ░               ░           ░             ░ ░     
echo.
                                                             echo             	        	    [38;2;128;0;0m[1][0m IP Geolookup              [38;2;128;0;0m[12][0m Port Range Scan
                                                             echo          	                    [38;2;128;0;0m[2][0m Create Grabber            [38;2;128;0;0m[13][0m IP Reputation
                                                             echo            	                    [38;2;128;0;0m[3][0m Check My IP               [38;2;128;0;0m[14][0m Speed Test
                                                             echo              	                    [38;2;128;0;0m[4][0m IP Generator              [38;2;128;0;0m[15][0m WiFi Passwords
                                                             echo             	                    [38;2;128;0;0m[5][0m Scan IPs                  [38;2;128;0;0m[16][0m MAC Changer
                                                             echo                                     [38;2;128;0;0m[6][0m Port Scanner              [38;2;128;0;0m[17][0m Tor Check
                                                             echo                                     [38;2;128;0;0m[7][0m Reverse DNS               [38;2;128;0;0m[18][0m HTTP Headers
                                                             echo                                     [38;2;128;0;0m[8][0m WHOIS Lookup              [38;2;128;0;0m[19][0m Connections
                                                             echo             	                    [38;2;128;0;0m[9][0m DNS Lookup                [38;2;128;0;0m[20][0m Hosts Editor
                                                             echo              	                    [38;2;128;0;0m[10][0m Subnet Calc              [38;2;128;0;0m[21][0m VPN Test
                                                             echo              	                    [38;2;128;0;0m[11][0m Proxy Check              [38;2;128;0;0m[22][0m Locate Private Ips
                                                             echo.
                                                             echo            	                    [38;2;128;0;0m[23][0m Help                     [38;2;128;0;0m[24][0m Exit
                                                             echo.

set /p choice=.%BS%%spacess%[38;2;128;0;0mSelect:[0m 
if "%choice%"=="1" goto geolookup
if "%choice%"=="2" goto creategrabber
if "%choice%"=="3" goto myip
if "%choice%"=="4" goto ipgen
if "%choice%"=="5" goto scanips
if "%choice%"=="6" goto portscan
if "%choice%"=="7" goto reversedns
if "%choice%"=="8" goto whoislookup
if "%choice%"=="9" goto dnslookup
if "%choice%"=="10" goto subnetcalc
if "%choice%"=="11" goto proxycheck
if "%choice%"=="12" goto portrange
if "%choice%"=="13" goto reputationcheck
if "%choice%"=="14" goto speedtest
if "%choice%"=="15" goto wifipass
if "%choice%"=="16" goto macchange
if "%choice%"=="17" goto torexit
if "%choice%"=="18" goto httpheader
if "%choice%"=="19" goto connmon
if "%choice%"=="20" goto hostedit
if "%choice%"=="21" goto vpntest
if "%choice%"=="24" exit
if "%choice%"=="23" goto help
if "%choice%"=="22" goto privlocator

echo %leftpad%[38;2;255;0;0mInvalid selection![0m
timeout /t 1 >nul
goto main



:iplookup
cls
set /p ip=Enter IP to lookup: 
echo Looking up IP address: %ip%
nslookup %ip%
pause >nul
goto page2

:: Domain Lookup
:domainlookup
cls
set /p domain=Enter domain to lookup: 
echo Looking up domain: %domain%
nslookup %domain%

:privlocator
cls
set /p range=[38;2;128;0;0mEnter your local network range: [0m

for /l %%i in (1,1,254) do (
    ping -n 1 %range%%%i | find "TTL=" > nul
    if !errorlevel! == 0 (
        echo Host %range%%%i is online
    )
)

pause >nul
goto :main

:blacklist
cls
if not defined ABUSEIPDB_KEY (
    echo [38;2;255;255;0m[!] No AbuseIPDB API key set[0m
    set /p ABUSEIPDB_KEY=Enter AbuseIPDB API Key: 
    set /p ip=[38;2;128;0;0mEnter IP to check:[0m 
) else (
    set /p ip=[38;2;128;0;0mEnter IP to check [%last_ip%]: [0m
    if "!ip!"=="" set ip=!last_ip!
)

curl -s "https://api.abuseipdb.com/api/v2/check?ipAddress=%ip%" -H "Key: %ABUSEIPDB_KEY%" > temp.json
type temp.json | findstr /C:"abuseConfidenceScore" || echo [38;2;255;0;0m[!] Invalid API key or no results[0m
del temp.json
set last_ip=%ip%
pause
goto main


:wifipass
setlocal enabledelayedexpansion
cls

echo ---Saved Wifi Passwords---

for /f "tokens=1,* delims=:" %%A in ('netsh wlan show profiles ^| findstr "All User Profile"') do (
    set "profile=%%B"
    set "profile=!profile:~1!"

    set "password=X"
    for /f "tokens=2 delims=:" %%C in ('netsh wlan show profile name="!profile!" key=clear ^| findstr /C:"Key Content"') do (
        set "password=%%C"
        set "password=!password:~1!"
    )
    echo !profile!: !password!
)

set "currentSSID="
for /f "tokens=2 delims=:" %%A in ('netsh wlan show interfaces ^| findstr /C:"SSID" ^| findstr /V "BSSID"') do (
    set "currentSSID=%%A"
    set "currentSSID=!currentSSID:~1!"
)

echo.
echo ---Current Wifi Password---

if defined currentSSID (
    set "curpass=X"
    for /f "tokens=2 delims=:" %%A in ('netsh wlan show profile name="!currentSSID!" key=clear ^| findstr /C:"Key Content"') do (
        set "curpass=%%A"
        set "curpass=!curpass:~1!"
    )
    echo !currentSSID!: !curpass!
) else (
    echo Not connected to Wi-Fi (current SSID: X)
)

echo.
echo ---LAN Address---

set "ipFound=false"
for /f "tokens=2 delims=:" %%A in ('ipconfig ^| findstr /C:"IPv4 Address"') do (
    set "ip=%%A"
    set "ip=!ip:~1!"
    echo !ip!
    set "ipFound=true"
    goto afterIP
)

:afterIP
if not defined ipFound (
    echo X
)

endlocal
pause >nul
goto main

:macchange
cls
powershell -Command "Get-NetAdapter | Select-Object Name, MacAddress"
set /p newmac=Enter new MAC (00-11-22-33-44-55): 
netsh interface set interface "Wi-Fi" admin=disable
netsh interface set interface "Wi-Fi" admin=enable
goto main

:torexit
cls
curl -s "https://check.torproject.org/exit-addresses" | findstr "%ip%"
pause
goto main

:httpheader
cls
set /p url=[38;2;128;0;0mEnter URL: [0m
curl -I "https://%url%"
pause
goto main

:connmon
cls
netstat -ano -p TCP
pause
goto main

:hostedit
cls
notepad C:\Windows\System32\drivers\etc\hosts
goto main

:vpntest
cls
curl -s "https://ipinfo.io/json" && echo Checking DNS... && nslookup whoami.akamai.net
pause
goto main

:fakeagent
cls
set /p url=Enter URL: 
curl -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64)" "%url%"
pause
goto main

:packetsniff
cls
python -c "from scapy.all import sniff; sniff(prn=lambda x: x.summary(), count=10)"
pause
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
chcp 65001 >nul
setlocal enabledelayedexpansion
cls
set /a spaceCount=45
set "space="
for /L %%i in (1,1,%spaceCount%) do set "space=!space! "
set /a spacesCount=26
set "spaces="
for /L %%i in (1,1,%spacesCount%) do set "spaces=!spaces! "
echo.
echo %space%[38;2;128;0;0mIP Tools - Help Menu 
echo %space%[38;2;128;0;0m===================[0m
echo.

echo %space%[38;2;160;160;160m=== Core Features ===[0m
echo %spaces%[1] IP Geolocation Lookup    - Locate any IP address
echo %spaces%[2] Create IP Grabber        - Generate IP logging tools
echo %spaces%[3] Check My IP              - Show your public IP
echo %spaces%[4] IP Generator             - Generate random valid IPs
echo.

echo %space%[38;2;160;160;160m=== Network Tools ===[0m
echo %spaces%[5] Scan IP Addresses       - Find active devices on network
echo %spaces%[6] Port Scanner            - Check open ports on an IP
echo %spaces%[7] Reverse DNS Lookup      - Convert IP to hostname
echo %spaces%[8] IP WHOIS Lookup         - Get ownership information
echo.

echo %space%[38;2;160;160;160m=== Utilities ===[0m
echo %spaces%[9] DNS Lookup              - Resolve domain records
echo %spaces%[10] IP Subnet Calculator   - Calculate network ranges
echo %spaces%[11] Proxy Checker          - Detect proxy/VPN usage
echo %spaces%[12] Port Range Scan        - Custom port scanning
echo.

echo %space%[38;2;160;160;160m=== Advanced ===[0m
echo %spaces%[13] IP Reputation Check    - Check if IP is malicious
echo %spaces%[14] Network Speed Test     - Test connection speed
echo %spaces%[15] Generate Report        - Save results to file
echo %spaces%[16] Help                   - Show this menu
echo %spaces%[17] Exit                   - Close the program
echo.

pause >nul
goto main

:whoislookup
cls
set /p ip=[38;2;128;0;0mEnter IP address for WHOIS lookup: [0m
curl -s "https://ipwhois.app/json/%ip%" > temp.json
findstr /C:"\"success\":true" temp.json >nul
if errorlevel 1 (
    echo [38;2;255;0;0m[!] Failed to retrieve info. Check your IP or connection.[0m
) else (
    type temp.json
)
del temp.json
pause >nul
goto main

:dnslookup
cls
set /p domain=[38;2;128;0;0mEnter domain name or IP for DNS lookup: [0m
nslookup %domain%
pause >nul
goto main

:subnetcalc
cls
echo Enter IP Address (e.g., 192.168.1.0):
set /p ip=IP Address: 
echo Enter Subnet Mask (e.g., 255.255.255.0):
set /p mask=Subnet Mask: 
echo Calculating...
rem Here you'd typically call a Python or external script to do subnet calculations
pause >nul
goto main

:proxycheck
cls
set /p ip=[38;2;128;0;0mEnter IP address to check for proxy: [0m
curl -s "https://www.proxycheck.io/v2/%ip%" > temp.json
findstr /C:"\"proxy\":true" temp.json >nul
if errorlevel 1 (
    echo [38;2;255;0;0m[!] IP is not a proxy.[0m
) else (
    echo [38;2;255;0;0m[!] IP is a proxy.[0m
)
del temp.json
pause >nul
goto main

:portrange
cls
set /p ip=[38;2;128;0;0mEnter IP to scan: [0m
set /p startport=[38;2;128;0;0mEnter start port: [0m
set /p endport=[38;2;128;0;0mEnter end port: [0m
for /L %%p in (%startport%,1,%endport%) do (
    echo Scanning port %%p...
    powershell -Command "(New-Object Net.Sockets.TcpClient).Connect('%ip%', %%p)" 2>nul && echo Port %%p is open.
)
pause >nul
goto main

:reputationcheck
cls
set /p ip=[38;2;128;0;0mEnter IP address to check reputation: [0m
curl -s "https://api.abuseipdb.com/api/v2/check?ipAddress=%ip%" -H "Key: YOUR_API_KEY" > temp.json
findstr /C:"\"abuseConfidenceScore\"" temp.json
type temp.json
del temp.json
pause >nul
goto main

:speedtest
cls
echo Running Speedtest...
python speedtest-cli.py --simple
pause >nul
goto main

:savereport
cls
set /p reportname=Enter report filename (e.g., report.txt): 
echo Generating report...
echo IP Tools Report > %reportname%
echo Report generated on %date% at %time% >> %reportname%
rem Call each tool to append output to the report file
pause >nul
goto main
