@echo off
chcp 850 >nul 2>&1
setlocal EnableExtensions DisableDelayedExpansion
set "PH_SELF=%~f0"
if /i "%~1"=="--ok" goto :INIT
if /i "%~1"=="--boot" goto :BOOT

rem === Reabre em janela de console classico, como Administrador ===
net session >nul 2>&1
if errorlevel 1 goto :ELEVATE
start "" conhost.exe cmd.exe /c call "%~f0" --ok
exit /b
:ELEVATE
powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath 'conhost.exe' -ArgumentList ('cmd.exe /c call ' + [char]34 + $env:PH_SELF + [char]34 + ' --ok') -Verb RunAs" >nul 2>&1
if errorlevel 1 goto :NOADMIN
exit /b
:NOADMIN
echo.
echo  Execute este arquivo como Administrador.
pause
exit /b

:INIT
mode con cols=140 lines=40
color 0C
title PRISMA HUB CMD - v0.1 NOVA
call :UIVARS
call :PATHS
cls
call :AT 3 3 "%R%>> PRISMA HUB CMD - v0.1 NOVA%N%"
call :AT 4 3 "%R%>> Carregando o sistema...%N%"
call :LOADHW
call :LOG "PRISMA HUB CMD v0.1 NOVA iniciado"

:MENU
call :HDR
call :AT 4 3 "%R%>> Carregando o sistema...%N%"
call :AT 6 3 "%R%>> Bem-vindo ao Prisma Hub!%N%"
call :AT 7 3 "%R%>> Escolha uma opá∆o no menu abaixo:%N%"
call :DRAWMENU
call :AT 33 3 "%R%Escolha uma opá∆o: %N%"
<nul set /p "=%ESC%[33;22H%ESC%[?25h"
choice /c 1234560 /n >nul
set "SEL=%errorlevel%"
if %SEL% lss 1 goto :MENU
if %SEL% gtr 7 goto :MENU
goto :M%SEL%

:M1
call :OPT
goto :MENU
:M2
call :CLEAN
goto :MENU
:M3
call :BACKUPUI
goto :MENU
:M4
call :TUT
goto :MENU
:M5
call :SOC
goto :MENU
:M6
call :UNDOUI
goto :MENU
:M7
goto :EXITUI

rem ======================================================================
rem  BOOT - reaplicacao automatica no login (com tela de progresso)
rem ======================================================================
:BOOT
mode con cols=140 lines=40
color 0C
title PRISMA HUB CMD - Reaplicando otimizaá‰es
call :UIVARS
call :PATHS
set "PH_BOOT=1"
call :LOADHW
call :LOG "BOOT: iniciando a reaplicacao"
call :BOOTUI
call :LOG "BOOT: concluido"
exit

:UIVARS
for /f %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"
set "R=%ESC%[91m"
set "D=%ESC%[31m"
set "N=%ESC%[0m"
set "MK_W=%D%[ .. ]%N%"
set "MK_R=%R%[ >> ]%N%"
set "MK_OK=%R%[ OK ]%N%"
set "MK_ER=%R%[FALHA]%N%"
set "MK_SK=%D%[ -- ]%N%"
set "BFULL=€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€"
set "BEMPTY=∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞"
set "BLANK=                                                                                                                        "
exit /b

:PATHS
set "PH_DIR=%ProgramData%\PrismaHub"
set "PH_BK=%PH_DIR%\backup"
set "PH_LOG=%PH_DIR%\logs"
set "PH_ST=%PH_DIR%\state"
set "PH_TMP=%PH_DIR%\tmp"
for %%D in ("%PH_DIR%" "%PH_BK%" "%PH_LOG%" "%PH_ST%" "%PH_TMP%") do if not exist "%%~D" mkdir "%%~D" >nul 2>&1
set "RG=17"
set "RA=27"
set "RB=29"
exit /b

:LOADHW
set "HW_OS=Windows"
set "HW_CPU=N/D"
set "HW_GPU=N/D"
set "HW_RAM=?"
set "HW_DSK=?"
set "PH_TS=00000000_000000"
call :RUNPS HW > "%PH_TMP%\hw.txt" 2>nul
for /f "usebackq tokens=1-6 delims=|" %%a in ("%PH_TMP%\hw.txt") do (
    set "HW_OS=%%a"
    set "HW_CPU=%%b"
    set "HW_GPU=%%c"
    set "HW_RAM=%%d"
    set "HW_DSK=%%e"
    set "PH_TS=%%f"
)
set "TODAY=%PH_TS:~0,8%"
set "PH_TODAY=%TODAY%"
exit /b

rem ======================================================================
rem  INTERFACE
rem ======================================================================
:AT
<nul set /p "=%ESC%[%~1;%~2H%~3"
exit /b

:HDR
cls
<nul set /p "=%ESC%[?25l"
call :AT 1 1 "%D%ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ%N%"
call :AT 3 3 "%R%>> PRISMA HUB CMD - v0.1 NOVA%N%"
call :AT 5 3 "%R%>> Sistema operacional: %HW_OS%%N%"
call :LOGO
call :HWBOX
call :FOOT
exit /b

:LOGO
call :AT 2 68 "%R%‹   ‹€‹   ‹%N%"
call :AT 3 68 "%R%€€‹€€€€€‹€€%N%"
call :AT 4 68 "%R%ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ%N%"
call :AT 5 47 "%R%€€€€  €€€€  €€€ €€€€€ €   €  €€€       €   € €   € €€€€ %N%"
call :AT 6 47 "%R%€   € €   €  €  €     €€ €€ €   €      €   € €   € €   €%N%"
call :AT 7 47 "%R%€€€€  €€€€   €  €€€€€ € € € €€€€€      €€€€€ €   € €€€€ %N%"
call :AT 8 47 "%R%€     €  €   €      € €   € €   €      €   € €   € €   €%N%"
call :AT 9 47 "%R%€     €   € €€€ €€€€€ €   € €   €      €   € €€€€€ €€€€ %N%"
call :AT 10 67 "%R%‹ﬂﬂ €ﬂ‹ﬂ€ €ﬂ‹%N%"
call :AT 11 67 "%R%€   € ﬂ € € €%N%"
call :AT 11 50 "%D%ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ%N%"
call :AT 11 83 "%D%ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ%N%"
call :AT 12 67 "%R%ﬂﬂﬂ ﬂ   ﬂ ﬂﬂ %N%"
call :AT 13 49 "%R%MAIS DESEMPENHO  ˙  MAIS LIBERDADE  ˙  SEM LIMITES%N%"
exit /b

:HWBOX
call :AT 2 105 "%D%⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø%N%"
for /l %%r in (3,1,12) do (
    call :AT %%r 105 "%D%≥%N%"
    call :AT %%r 138 "%D%≥%N%"
)
call :AT 13 105 "%D%¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ%N%"
call :AT 3 107 "%R%[ SISTEMA OPERACIONAL ]%N%"
call :AT 4 108 "%R%%HW_OS%%N%"
call :AT 5 107 "%R%[ VERS«O ]%N%"
call :AT 6 108 "%R%v0.1 NOVA%N%"
call :AT 7 107 "%D%ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ%N%"
call :AT 8 107 "%R%[ HARDWARE ]%N%"
call :AT 9 107 "%R%CPU   : %HW_CPU%%N%"
call :AT 10 107 "%R%GPU   : %HW_GPU%%N%"
call :AT 11 107 "%R%RAM   : %HW_RAM% GB%N%"
call :AT 12 107 "%R%DISCO : %HW_DSK% GB%N%"
exit /b

:FOOT
call :AT 37 1 "%D%ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ%N%"
call :AT 38 2 "%R%////%N%"
call :AT 38 104 "%R%PRISMA HUB CMD  |  v0.1 NOVA  ////%N%"
exit /b

:FRAME
call :AT 15 12 "%D%⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø%N%"
for /l %%r in (16,1,33) do (
    call :AT %%r 12 "%D%≥%N%"
    call :AT %%r 127 "%D%≥%N%"
)
call :AT 34 12 "%D%¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ%N%"
exit /b

:SCREEN
call :HDR
call :AT 4 3 "%R%>> M¢dulo: %~1%N%"
call :AT 6 3 "%R%>> Siga as instruá‰es na tela.%N%"
call :FRAME
exit /b

:DRAWMENU
call :AT 15 12 "%D%⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø%N%"
for /l %%r in (16,1,30) do (
    call :AT %%r 12 "%D%≥%N%"
    call :AT %%r 127 "%D%≥%N%"
)
call :AT 31 12 "%D%¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ%N%"
for %%r in (16 18 20 22 24 26 28 30) do call :AT %%r 14 "%D%ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ%N%"
call :MITEM 17 1 œ "OTIMIZAÄ«O" "Ajustes de desempenho, FPS e sistema."
call :MITEM 19 2 ı "LIMPAR MEM‡RIA" "Remove arquivos tempor†rios e limpa o sistema."
call :MITEM 21 3 ˛ "BACKUP" "Cria pontos de restauraá∆o e backups."
call :MITEM 23 4 Ù "TUTORIAIS" "Aprende a extrair o m†ximo do seu PC."
call :MITEM 25 5 ™ "REDES SOCIAIS" "Acesse nossos canais e fique por dentro."
call :MITEM 27 6 Æ "DESATIVAR" "Desativa todas as opá‰es aplicadas no programa."
call :MITEM 29 0 Ø "SAIR" "Encerra o programa."
exit /b

:MITEM
call :AT %~1 16 "%R%[ %~2 ]%N%"
call :AT %~1 26 "%R%%~3%N%"
call :AT %~1 33 "%R%%~4%N%"
call :AT %~1 56 "%D%> %~5%N%"
exit /b

rem --- linha de grupo (lista de etapas) ---
:GRP
set /a "GRW=RG+%~1"
set "GT=%~3%BLANK%"
call :AT %GRW% 15 "%~2 %GT:~0,100%"
exit /b

rem --- linha da acao atual ---
:ACT
set "AT_=%~1%BLANK%"
call :AT %RA% 15 "%R%>> %AT_:~0,100%%N%"
exit /b

rem --- barra de progresso: %1 = porcentagem ---
:BAR
if defined QUIET exit /b
set "PCT=%~1"
if %PCT% gtr 100 set "PCT=100"
set /a "FL=PCT/2"
set /a "EM=50-FL"
set "BF="
set "BE="
if %FL% gtr 0 call set "BF=%%BFULL:~0,%FL%%%"
if %EM% gtr 0 call set "BE=%%BEMPTY:~0,%EM%%%"
<nul set /p "=%ESC%[%RB%;15H%R%[%BF%%D%%BE%%R%] %PCT%%%   %N%"
exit /b

:TXTINIT
set "TROW=%~1"
exit /b

:TXT
call :AT %TROW% 15 "%~1%N%"
set /a TROW+=1
exit /b

:ASKYN
call :AT %~1 15 "%R%%~2 [S/N]: %N%"
choice /c SN /n >nul
if errorlevel 2 (set "YN=0") else (set "YN=1")
exit /b

:PRESS
call :AT 35 15 "%D%[ Pressione qualquer tecla para continuar ]%N%"
pause >nul
exit /b

:LOG
set "LM=%~1"
set "LM=%LM:|=/%"
>>"%PH_LOG%\prisma_%TODAY%.log" echo [%time:~0,8%] %LM%
exit /b

:MARK
findstr /x /c:"%~1" "%PH_ST%\applied.lst" >nul 2>&1 || (>>"%PH_ST%\applied.lst" echo %~1)
exit /b

:UNMARK
if not exist "%PH_ST%\applied.lst" exit /b
findstr /v /x /c:"%~1" "%PH_ST%\applied.lst" > "%PH_TMP%\ap.tmp" 2>nul
move /y "%PH_TMP%\ap.tmp" "%PH_ST%\applied.lst" >nul 2>&1
exit /b

rem --- executa uma secao PowerShell embutida no fim deste arquivo ---
:RUNPS
set "PH_SEC=%~1"
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "$ProgressPreference='SilentlyContinue'; $RawText=[IO.File]::ReadAllText($env:PH_SELF,[Text.Encoding]::GetEncoding(28591)); function Get-Section([string]$n){ $m=[regex]::Match($RawText,'(?s)'+[char]35+'<'+$n+'>(.*?)'+[char]35+'</'+$n+'>'); return $m.Groups[1].Value }; Invoke-Expression ((Get-Section 'LIB')+[Environment]::NewLine+(Get-Section $env:PH_SEC))"
exit /b %errorlevel%

rem ======================================================================
rem  BACKUP
rem ======================================================================
:BKCHECK
set "BK_OK=0"
if not exist "%PH_BK%\backup.ok" exit /b
if not exist "%PH_BK%\services.csv" exit /b
if not exist "%PH_BK%\power_active.txt" exit /b
dir /b "%PH_BK%\reg_*.reg" >nul 2>&1 || exit /b
set "BK_OK=1"
call :BKREAD
exit /b

:BKREAD
for /f "usebackq tokens=1,* delims==" %%a in ("%PH_BK%\backup.ok") do set "BK_%%a=%%b"
exit /b

rem --- garante backup valido antes de alterar o sistema (retorna 0 = ok, 1 = cancelar) ---
:NEEDBK
call :BKCHECK
if "%BK_OK%"=="1" exit /b 0
call :BACKUPUI
call :BKCHECK
if "%BK_OK%"=="1" exit /b 0
exit /b 1

:BACKUPUI
call :SCREEN "BACKUP"
call :BKCHECK
if "%BK_OK%"=="1" goto :BK_SHOW
call :TXTINIT 17
call :TXT "%R%Nenhum backup v†lido foi encontrado."
call :TXT " "
call :TXT "%D%Antes de qualquer alteraá∆o no sistema (otimizaá∆o ou limpeza), o PRISMA HUB cria"
call :TXT "%D%um £nico backup inicial. Ele guarda:"
call :TXT "%D%  ˙ ponto de restauraá∆o do Windows (liga a Proteá∆o do Sistema se estiver desligada)"
call :TXT "%D%  ˙ exportaá∆o das chaves de registro que o programa altera"
call :TXT "%D%  ˙ serviáos, plano de energia, apps instalados, inicializaá∆o e rede"
call :TXT " "
call :TXT "%D%Local: %PH_BK%"
call :ASKYN 28 "Criar o backup inicial agora?"
if "%YN%"=="0" (
    call :AT 30 15 "%R%Backup n∆o criado. Otimizaá∆o e limpeza ficam bloqueadas atÇ que ele exista.%N%"
    call :PRESS
    exit /b 1
)
call :BKCREATE
exit /b %errorlevel%

:BK_SHOW
call :TXTINIT 17
call :TXT "%R%STATUS DO BACKUP"
call :TXT " "
call :TXT "%D%Status ............ %R%VµLIDO"
call :TXT "%D%Data .............. %R%%BK_DATA%"
call :TXT "%D%Hor†rio ........... %R%%BK_HORA%"
call :TXT "%D%Local ............. %R%%BK_LOCAL%"
call :TXT "%D%Ponto de restauraá∆o %R%%BK_PONTO_RESTAURACAO%"
call :TXT "%D%Chaves de registro  %R%%BK_ITENS_REGISTRO%"
call :TXT " "
call :TXT "%R%O backup inicial j† foi realizado. Nenhum novo backup ser† criado."
call :PRESS
exit /b 0

:BKCREATE
call :SCREEN "BACKUP"
set "RG=17"
set "RA=27"
set "RB=29"
call :GRP 0 "%MK_W%" "Preparando pastas do backup"
call :GRP 1 "%MK_W%" "Criando ponto de restauraá∆o do Windows"
call :GRP 2 "%MK_W%" "Exportando chaves do registro"
call :GRP 3 "%MK_W%" "Salvando serviáos, energia, apps, inicializaá∆o e rede"
call :GRP 4 "%MK_W%" "Gravando o registro do backup"
call :GRP 5 "%MK_W%" "Verificando a integridade do backup"
call :BAR 0
call :LOG "Backup: iniciando"

call :GRP 0 "%MK_R%" "Preparando pastas do backup"
call :ACT "Preparando..."
call :BAR 5
del /q "%PH_BK%\backup.ok" >nul 2>&1
del /q "%PH_BK%\reg_*.reg" >nul 2>&1
call :BAR 10
call :GRP 0 "%MK_OK%" "Preparando pastas do backup"

call :GRP 1 "%MK_R%" "Criando ponto de restauraá∆o do Windows"
call :ACT "Criando ponto de restauraá∆o (pode levar alguns segundos)..."
call :RUNPS RESTOREPOINT >nul 2>&1
if errorlevel 1 (set "RP=NAO") else (set "RP=SIM")
call :BAR 30
if "%RP%"=="SIM" (
    call :GRP 1 "%MK_OK%" "Criando ponto de restauraá∆o do Windows"
) else (
    call :GRP 1 "%MK_SK%" "Ponto de restauraá∆o indispon°vel - seguindo com os demais itens"
)
call :LOG "Backup: ponto de restauracao = %RP%"

call :GRP 2 "%MK_R%" "Exportando chaves do registro"
call :ACT "Exportando chaves do registro..."
set "RN=0"
for %%K in (
    "HKCU\Control Panel\Desktop"
    "HKCU\Control Panel\International\User Profile"
    "HKCU\System\GameConfigStore"
    "HKCU\Software\Microsoft\GameBar"
    "HKCU\Software\Microsoft\Siuf"
    "HKCU\Software\Microsoft\Windows\DWM"
    "HKCU\Software\Microsoft\Windows\CurrentVersion\Run"
    "HKCU\Software\Microsoft\Windows\CurrentVersion\Search"
    "HKCU\Software\Microsoft\Windows\CurrentVersion\Privacy"
    "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR"
    "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
    "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
    "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
    "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications"
    "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
    "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved"
    "HKLM\SOFTWARE\Policies\Microsoft"
    "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
    "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
    "HKLM\SYSTEM\CurrentControlSet\Control\Power"
    "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl"
    "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers"
    "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"
) do call :REGEXP "%%~K"
set "RC=0"
for /f %%c in ('dir /b "%PH_BK%\reg_*.reg" 2^>nul ^| find /c /v ""') do set "RC=%%c"
if "%RC%"=="0" goto :BKFAIL
call :GRP 2 "%MK_OK%" "Exportando chaves do registro"

call :GRP 3 "%MK_R%" "Salvando serviáos, energia, apps, inicializaá∆o e rede"
call :ACT "Salvando serviáos, energia, apps, inicializaá∆o e rede (aguarde)..."
call :BAR 60
call :RUNPS SNAPSHOT >nul 2>&1
if errorlevel 1 goto :BKFAIL
call :BAR 85
call :GRP 3 "%MK_OK%" "Salvando serviáos, energia, apps, inicializaá∆o e rede"

call :GRP 4 "%MK_R%" "Gravando o registro do backup"
call :ACT "Gravando o registro do backup..."
call :RUNPS NOW > "%PH_TMP%\now.txt" 2>nul
set "N_DATA=?"
set "N_HORA=?"
for /f "usebackq tokens=1-3 delims=|" %%a in ("%PH_TMP%\now.txt") do (
    set "N_DATA=%%a"
    set "N_HORA=%%b"
)
(
    echo STATUS=VALIDO
    echo DATA=%N_DATA%
    echo HORA=%N_HORA%
    echo LOCAL=%PH_BK%
    echo PONTO_RESTAURACAO=%RP%
    echo ITENS_REGISTRO=%RC%
) > "%PH_BK%\backup.ok"
call :BAR 92
call :GRP 4 "%MK_OK%" "Gravando o registro do backup"

call :GRP 5 "%MK_R%" "Verificando a integridade do backup"
call :ACT "Verificando..."
call :BKCHECK
if not "%BK_OK%"=="1" goto :BKFAIL
call :BAR 100
call :GRP 5 "%MK_OK%" "Verificando a integridade do backup"
call :ACT "Backup conclu°do."
call :LOG "Backup: concluido e verificado"
call :AT 31 15 "%R%Backup criado e verificado com sucesso.%N%"
call :AT 32 15 "%D%Local: %PH_BK%%N%"
call :PRESS
exit /b 0

:BKFAIL
del /q "%PH_BK%\backup.ok" >nul 2>&1
call :LOG "Backup: FALHOU"
call :AT 31 15 "%ESC%[7m  FALHA AO CRIAR O BACKUP. A operaá∆o foi cancelada.  %N%"
call :AT 32 15 "%D%Feche programas, libere espaáo em disco e tente novamente.%N%"
call :PRESS
exit /b 1

:REGEXP
set /a RN+=1
set "RNN=0%RN%"
reg export "%~1" "%PH_BK%\reg_%RNN:~-2%.reg" /y >nul 2>&1
set /a "PC=30+RN*25/24"
call :BAR %PC%
exit /b

rem ======================================================================
rem  REDES SOCIAIS
rem ======================================================================
:SOC
call :SCREEN "REDES SOCIAIS"
call :TXTINIT 17
call :TXT "%R%CRêDITOS"
call :TXT " "
call :TXT "%D%Desenvolvedor .... %R%jonzinhoXD"
call :TXT "%D%Criador do ....... %R%PRISMA HUB CMD"
call :TXT " "
call :TXT "%R%TIKTOK OFICIAL"
call :TXT " "
call :TXT "%D%Perfil ........... %R%@surejonn"
call :TXT "%D%Link ............. %R%https://www.tiktok.com/@surejonn"
call :TXT " "
call :TXT "%R%[ 1 ] %D%Abrir o TikTok no navegador padr∆o"
call :TXT "%R%[ 0 ] %D%Voltar ao menu"
choice /c 10 /n >nul
if errorlevel 2 exit /b
start "" "https://www.tiktok.com/@surejonn"
goto :SOC

rem ======================================================================
rem  SAIR
rem ======================================================================
:EXITUI
call :SCREEN "SAIR"
set "RG=17"
set "RA=27"
set "RB=29"
call :GRP 0 "%MK_W%" "Salvando registros do programa"
call :GRP 1 "%MK_W%" "Aplicando as alteraá‰es no sistema"
call :GRP 2 "%MK_W%" "Verificando se Ç necess†rio reiniciar"
call :BAR 0
call :GRP 0 "%MK_R%" "Salvando registros do programa"
call :ACT "Salvando..."
call :LOG "Encerrando o programa"
call :BAR 25
call :GRP 0 "%MK_OK%" "Salvando registros do programa"
call :GRP 1 "%MK_R%" "Aplicando as alteraá‰es no sistema"
call :ACT "Atualizando as configuraá‰es do Windows..."
rundll32.exe user32.dll,UpdatePerUserSystemParameters 1, True
ipconfig /flushdns >nul 2>&1
call :BAR 70
call :GRP 1 "%MK_OK%" "Aplicando as alteraá‰es no sistema"
call :GRP 2 "%MK_R%" "Verificando se Ç necess†rio reiniciar"
call :ACT "Verificando..."
call :RUNPS RESTARTCHK >nul 2>&1
set "NEEDRB=%errorlevel%"
call :BAR 100
call :GRP 2 "%MK_OK%" "Verificando se Ç necess†rio reiniciar"
call :ACT "Conclu°do."
if "%NEEDRB%"=="1" (
    call :AT 31 15 "%ESC%[7m  REINICIE O COMPUTADOR PARA APLICAR TODAS AS ALTERAÄÂES.  %N%"
    call :AT 32 15 "%D%Salve seu trabalho e reinicie o Windows quando puder.%N%"
) else (
    call :AT 31 15 "%R%Tudo certo. Nenhuma reinicializaá∆o pendente.%N%"
)
call :AT 33 15 "%R%Obrigado por usar o PRISMA HUB CMD!%N%"
call :AT 35 15 "%D%[ Pressione qualquer tecla para sair ]%N%"
pause >nul
<nul set /p "=%ESC%[?25h"
exit

rem ======================================================================
rem  AUXILIARES COMUNS
rem ======================================================================
:BKBANNER
call :AT 17 15 "%R%Backup j† realizado%D% ˙ Status: %R%VµLIDO%D% ˙ %R%%BK_DATA% %BK_HORA%%D% ˙ %R%%BK_LOCAL%%N%"
exit /b

rem --- porta de entrada: exige backup valido (retorna 0 = continuar, 1 = cancelado) ---
:GATE
call :SCREEN "%~1"
call :BKCHECK
if "%BK_OK%"=="1" goto :GATE_OK
call :BACKUPUI
call :BKCHECK
if not "%BK_OK%"=="1" goto :GATE_FAIL
call :SCREEN "%~1"
:GATE_OK
call :BKBANNER
exit /b 0
:GATE_FAIL
call :SCREEN "%~1"
call :AT 17 15 "%ESC%[7m  OPERAÄ«O CANCELADA: n∆o existe um backup v†lido.  %N%"
call :AT 19 15 "%D%Crie o backup (opá∆o 3) antes de otimizar ou limpar o sistema.%N%"
call :LOG "%~1 cancelado: backup indisponivel"
call :PRESS
exit /b 1

rem --- executa uma secao PowerShell e guarda a ultima linha da saida em RES ---
:RS
set "RES="
call :RUNPS %~1 > "%PH_TMP%\res.txt" 2>nul
for /f "usebackq delims=" %%a in ("%PH_TMP%\res.txt") do set "RES=%%a"
exit /b

rem ======================================================================
rem  1 - OTIMIZACAO
rem ======================================================================
:OPT
call :GATE "OTIMIZAÄ«O"
if errorlevel 1 exit /b
call :TXTINIT 19
call :TXT "%R%O que ser† feito (modo m†ximo):"
call :TXT "%D% ˙ Remover dezenas de apps nativos, de brinde e de fabricante (Copilot, Teams, Widgets, Xbox, Cortana...)"
call :TXT "%D% ˙ Desativar apps de terceiros na inicializaá∆o (Discord, Steam...), segundo plano, Edge e atualizadores"
call :TXT "%D% ˙ Desligar dezenas de serviáos e tarefas (telemetria, indexaá∆o, Bluetooth e compartilhamento sem uso)"
call :TXT "%D% ˙ Agrupar os serviáos do Windows em menos processos (vale depois de reiniciar)"
call :TXT "%D% ˙ Navegadores: abas inativas dormem e Edge e Chrome n∆o ficam abertos em segundo plano"
call :TXT "%D% ˙ Reduzir telemetria, an£ncios, localizaá∆o, hist¢rico de atividades e coleta de dados"
call :TXT "%D% ˙ Desativar animaá‰es, transparància e efeitos visuais"
call :TXT "%D% ˙ CPU em alto desempenho (sem overclock) e varreduras do Defender com menos uso de CPU"
call :TXT "%D% ˙ Jogos: Modo Jogo, GPU dedicada nos seus jogos, mouse sem aceleraá∆o, sem gravaá∆o em segundo plano"
call :TXT "%D% ˙ Rede: menor latància, sem economia de energia no adaptador e menos tr†fego em segundo plano"
call :TXT "%D% ˙ Reaplicar tudo no login, com uma janela mostrando o progresso (desative na opá∆o 6)"
call :TXT "%R%Preservado: %D%drivers, Windows Defender, Firewall, Windows Update, antiv°rus e perifÇricos."
call :TXT "%R%Revers°vel: %D%opá∆o 6 (DESATIVAR). Apps removidos podem precisar da Microsoft Store para voltar."
call :ASKYN 33 "Iniciar a otimizaá∆o agora?"
if "%YN%"=="0" exit /b

call :SCREEN "OTIMIZAÄ«O"
set "RG=17"
set "RA=27"
set "RB=29"
call :SETL
call :OPT_LIST
call :BAR 0
set "PC_B=0"
set "PR_B=0"
set "PC_A=0"
set "PR_A=0"
call :RUNPS PCOUNT > "%PH_TMP%\pc.txt" 2>nul
for /f "usebackq tokens=1-3 delims=|" %%a in ("%PH_TMP%\pc.txt") do (
    set "PC_B=%%a"
    set "PR_B=%%b"
)
call :LOG "Otimizacao iniciada (processos: %PC_B%)"

call :GRP 0 "%MK_R%" "%L0%"
call :ACT "%L0%..."
call :BKCHECK
if not "%BK_OK%"=="1" goto :OPT_ABORT
call :GRP 0 "%MK_OK%" "%L0%"
call :BAR 5

call :GRP 1 "%MK_R%" "%L1%"
set "AP_OK=0"
set "AP_NO=0"
set "AP_OD=NONE"
for %%p in (1 2 3 4) do call :OPT_APPS %%p
call :GRP 1 "%MK_OK%" "%L1%  [%AP_OK%]"

call :STEPRUN 2 55 OPT_START
call :STEPRUN 3 65 OPT_SVC
call :STEPRUN 4 72 OPT_PRIV
call :STEPRUN 5 80 OPT_VISUAL
call :STEPRUN 6 87 OPT_POWER
call :STEPRUN 7 93 OPT_GAME
call :STEPRUN 8 97 OPT_NET

call :GRP 9 "%MK_R%" "%L9%"
call :ACT "%L9%..."
call :RS OPT_KILL
call :LOG "OPT_KILL: %RES%"
copy /y "%PH_SELF%" "%PH_DIR%\PrismaHub.bat" >nul 2>&1
call :RS BOOTON
call :LOG "BOOTON: %RES%"
set "BT_TXT=N«O AGENDADO"
if "%RES%"=="OK" set "BT_TXT=ATIVO"
call :RUNPS PCOUNT > "%PH_TMP%\pc.txt" 2>nul
for /f "usebackq tokens=1-3 delims=|" %%a in ("%PH_TMP%\pc.txt") do (
    set "PC_A=%%a"
    set "PR_A=%%b"
)
>"%PH_ST%\needs_reboot.flag" echo 1
call :LOG "Otimizacao concluida: processos %PC_B% para %PC_A%, RAM em uso %PR_B% MB para %PR_A% MB"
call :GRP 9 "%MK_OK%" "%L9%"
call :BAR 100
call :ACT "Otimizaá∆o conclu°da."
set /a PC_D=PC_B-PC_A
if %PC_D% lss 0 set "PC_D=0"
set /a PR_D=PR_B-PR_A
if %PR_D% lss 0 set "PR_D=0"
call :AT 31 15 "%R%Processos: %PC_B% > %PC_A% (menos %PC_D%)  ˙  RAM em uso: %PR_B% MB > %PR_A% MB (menos %PR_D% MB)%N%"
call :AT 32 15 "%ESC%[7m  REINICIE O COMPUTADOR PARA APLICAR TODAS AS OTIMIZAÄÂES.  %N%"
call :AT 33 15 "%D%Apps removidos: %AP_OK%  ˙  n∆o removidos: %AP_NO%  ˙  Reaplicar ao ligar o PC: %R%%BT_TXT%%N%"
call :PRESS
exit /b

:OPT_ABORT
call :LOG "Otimizacao cancelada: backup invalido"
call :AT 31 15 "%ESC%[7m  OPERAÄ«O CANCELADA: o backup n∆o pìde ser verificado.  %N%"
call :PRESS
exit /b

:SETL
set "L0=Verificando o backup"
set "L1=Removendo apps nativos, de brinde e de fabricante"
set "L2=Desativando inicializaá∆o, segundo plano e navegadores"
set "L3=Desativando serviáos, tarefas e agrupando processos"
set "L4=Reduzindo telemetria, an£ncios, localizaá∆o e hist¢rico"
set "L5=Desativando animaá‰es e efeitos visuais"
set "L6=Otimizando energia e CPU (sem overclock)"
set "L7=Otimizando GPU, mouse e configuraá‰es para jogos"
set "L8=Otimizando a rede e a latància"
set "L9=Encerrando processos, liberando RAM e agendando o boot"
exit /b

:OPT_LIST
call :GRP 0 "%MK_W%" "%L0%"
call :GRP 1 "%MK_W%" "%L1%"
call :GRP 2 "%MK_W%" "%L2%"
call :GRP 3 "%MK_W%" "%L3%"
call :GRP 4 "%MK_W%" "%L4%"
call :GRP 5 "%MK_W%" "%L5%"
call :GRP 6 "%MK_W%" "%L6%"
call :GRP 7 "%MK_W%" "%L7%"
call :GRP 8 "%MK_W%" "%L8%"
call :GRP 9 "%MK_W%" "%L9%"
exit /b

:OPT_APPS
set "PH_PART=%~1"
call :ACT "%L1% (parte %~1 de 4)..."
call :RS OPT_APPS
call :LOG "OPT_APPS parte %~1: %RES%"
for /f "usebackq tokens=1-3 delims=|" %%a in ("%PH_TMP%\res.txt") do (
    set /a AP_OK+=%%a
    set /a AP_NO+=%%b
    if not "%%c"=="-" set "AP_OD=%%c"
)
set /a "PCT=5+%~1*10"
call :BAR %PCT%
exit /b

:STEPRUN
call set "LB=%%L%~1%%"
call :GRP %~1 "%MK_R%" "%LB%"
call :ACT "%LB%..."
call :RS %~3
call :LOG "%~3: %RES%"
call :SRCOUNT
call :GRP %~1 "%MK_OK%" "%LB%  [%SR_A%]%SR_X%"
call :BAR %~2
exit /b

:SRCOUNT
set "SR_A=0"
set "SR_X="
for /f "tokens=1-3 delims=|" %%a in ("%RES%") do (
    set "SR_A=%%a"
    if not "%%c"=="-" set "SR_X=  ˙  %%c"
)
exit /b

rem ======================================================================
rem  2 - LIMPAR MEMORIA
rem ======================================================================
:CLINFO
set "CL_LABEL=%~1"
set "CL_PATH="
if "%~1"=="TEMPU" set "CL_LABEL=Tempor†rios do usu†rio" & set "CL_PATH=%TEMP%"
if "%~1"=="TEMPW" set "CL_LABEL=Tempor†rios do Windows" & set "CL_PATH=%SystemRoot%\Temp"
if "%~1"=="INET" set "CL_LABEL=Cache da Internet (Windows)" & set "CL_PATH=%LOCALAPPDATA%\Microsoft\Windows\INetCache"
if "%~1"=="THUMB" set "CL_LABEL=Cache de miniaturas e °cones" & set "CL_PATH=%LOCALAPPDATA%\Microsoft\Windows\Explorer"
if "%~1"=="WU" set "CL_LABEL=Cache do Windows Update" & set "CL_PATH=%SystemRoot%\SoftwareDistribution\Download"
if "%~1"=="DO" set "CL_LABEL=Cache de Otimizaá∆o de Entrega" & set "CL_PATH=%SystemRoot%\ServiceProfiles\NetworkService\...\Cache"
if "%~1"=="WER" set "CL_LABEL=Relat¢rios de erro e dumps" & set "CL_PATH=%ProgramData%\Microsoft\Windows\WER e CrashDumps"
if "%~1"=="EDGE" set "CL_LABEL=Cache do Microsoft Edge" & set "CL_PATH=%LOCALAPPDATA%\Microsoft\Edge\User Data\*\Cache"
if "%~1"=="CHROME" set "CL_LABEL=Cache do Google Chrome" & set "CL_PATH=%LOCALAPPDATA%\Google\Chrome\User Data\*\Cache"
if "%~1"=="FIREFOX" set "CL_LABEL=Cache do Firefox" & set "CL_PATH=%LOCALAPPDATA%\Mozilla\Firefox\Profiles\*\cache2"
if "%~1"=="BIN" set "CL_LABEL=Lixeira (s¢ com a sua confirmaá∆o)" & set "CL_PATH=Todas as unidades"
exit /b

:CLEAN
call :GATE "LIMPAR MEM‡RIA"
if errorlevel 1 exit /b
set "CL_IDS=TEMPU TEMPW INET THUMB WU DO WER EDGE CHROME FIREFOX BIN"
call :AT 18 15 "%D%Analisando o sistema... aguarde alguns instantes.%N%"
call :RUNPS CLEAN_SCAN > "%PH_TMP%\scan.txt" 2>nul
call :AT 18 15 "%BLANK:~0,100%"
call :AT 18 15 "%R%ITENS QUE SER«O APAGADOS%D%  (tempor†rios: somente arquivos com mais de 24 horas)%N%"
set "CR=19"
set "CT_TXT=0 KB"
set "CT_BINC=0"
for /f "usebackq tokens=1-4 delims=|" %%a in ("%PH_TMP%\scan.txt") do call :CLROW "%%a" "%%b" "%%c" "%%d"
call :AT 30 15 "%R%TOTAL A LIBERAR: %CT_TXT%%N%"
call :AT 31 15 "%ESC%[7m ATENÄ«O %N% %D%Arquivos apagados N«O poder∆o ser restaurados pelo PRISMA HUB CMD (sem revers∆o garantida).%N%"
call :AT 32 15 "%D%Documentos, fotos, jogos e programas n∆o s∆o tocados. Feche os navegadores para limpar o cache deles.%N%"
call :ASKYN 33 "Confirmar a limpeza dos itens acima?"
if "%YN%"=="0" exit /b
set "CLEAN_BIN=0"
if "%CT_BINC%"=="0" goto :CLEAN_GO
call :AT 33 15 "%BLANK:~0,100%"
call :ASKYN 33 "Esvaziar tambÇm a Lixeira? Apaga de forma definitiva."
set "CLEAN_BIN=%YN%"

:CLEAN_GO
call :SCREEN "LIMPAR MEM‡RIA"
set "RG=17"
set "RA=28"
set "RB=30"
set "CI=0"
for %%i in (%CL_IDS%) do call :CLLIST %%i
call :BAR 0
call :RUNPS FREE > "%PH_TMP%\free.txt" 2>nul
set "FR_B=0"
set "FR_A=0"
for /f "usebackq delims=" %%a in ("%PH_TMP%\free.txt") do set "FR_B=%%a"
del /q "%PH_LOG%\limpeza_falhas.txt" >nul 2>&1
del /q "%PH_TMP%\clean_report.txt" >nul 2>&1
set "CT_RM=0"
set "CT_FL=0"
set "CT_KB=0"
set "CI=0"
call :LOG "Limpeza iniciada (lixeira: %CLEAN_BIN%)"
for %%i in (%CL_IDS%) do call :CLRUN1 %%i
call :RUNPS FREE > "%PH_TMP%\free.txt" 2>nul
for /f "usebackq delims=" %%a in ("%PH_TMP%\free.txt") do set "FR_A=%%a"
call :BAR 100
call :ACT "Limpeza conclu°da."
call :LOG "Limpeza concluida: removidos %CT_RM%, nao excluidos %CT_FL%"
call :AT 31 15 "%R%Limpeza conclu°da. Preparando o relat¢rio...%N%"
call :PRESS

call :SCREEN "LIMPAR MEM‡RIA - RELAT‡RIO"
call :AT 17 15 "%R%RELAT‡RIO DA LIMPEZA%N%"
>"%PH_LOG%\limpeza_%TODAY%.txt" echo PRISMA HUB CMD - Relatorio de limpeza (%TODAY%)
set "CR=18"
for /f "usebackq tokens=1-4 delims=|" %%a in ("%PH_TMP%\clean_report.txt") do call :CLREP "%%a" "%%b" "%%c" "%%d"
set /a CT_MB=CT_KB/1024
set /a CT_MD=(CT_KB%%1024)*10/1024
set /a FR_D=FR_A-FR_B
if %FR_D% lss 0 set "FR_D=0"
set /a CR+=1
call :AT %CR% 15 "%R%TOTAL: %CT_RM% arquivos removidos  ˙  %CT_FL% n∆o exclu°dos (em uso)  ˙  %CT_MB%.%CT_MD% MB apagados%N%"
set /a CR+=1
call :AT %CR% 15 "%R%Espaáo livre no disco do sistema: %D%%FR_B% MB > %FR_A% MB  %R%(liberado de fato: %FR_D% MB)%N%"
set /a CR+=1
if exist "%PH_LOG%\limpeza_falhas.txt" call :AT %CR% 15 "%D%Itens n∆o exclu°dos: %PH_LOG%\limpeza_falhas.txt%N%"
>>"%PH_LOG%\limpeza_%TODAY%.txt" echo TOTAL: removidos=%CT_RM% nao_excluidos=%CT_FL% apagado_MB=%CT_MB% livre_antes_MB=%FR_B% livre_depois_MB=%FR_A% liberado_MB=%FR_D%
call :AT 33 15 "%D%Relat¢rio salvo em: %PH_LOG%\limpeza_%TODAY%.txt%N%"
call :PRESS
exit /b

:CLROW
if "%~1"=="TOTAL" set "CT_TXT=%~4"
if "%~1"=="TOTAL" exit /b
if "%~1"=="BIN" set "CT_BINC=%~3"
call :CLINFO %~1
set "CLB=%CL_LABEL%%BLANK%"
set "CLP=%CL_PATH%%BLANK%"
set "CLS=%~4%BLANK%"
call :AT %CR% 15 "%R%[x] %D%%CLB:~0,38% %R%%CLS:~0,10% %D%%CLP:~0,52%%N%"
set /a CR+=1
exit /b

:CLLIST
call :CLINFO %~1
call :GRP %CI% "%MK_W%" "%CL_LABEL%"
set /a CI+=1
exit /b

:CLRUN1
call :CLINFO %~1
if "%~1"=="BIN" if "%CLEAN_BIN%"=="0" goto :CLSKIP
set "PH_CAT=%~1"
call :GRP %CI% "%MK_R%" "%CL_LABEL%"
call :ACT "Limpando: %CL_LABEL%..."
call :RS CLEAN_RUN
set "CF_RM=0"
set "CF_FL=0"
set "CF_KB=0"
set "CF_TX=0 KB"
for /f "usebackq tokens=2-5 delims=|" %%a in ("%PH_TMP%\res.txt") do (
    set "CF_RM=%%a"
    set "CF_FL=%%b"
    set "CF_KB=%%c"
    set "CF_TX=%%d"
)
set /a CT_RM+=CF_RM
set /a CT_FL+=CF_FL
set /a CT_KB+=CF_KB
>>"%PH_TMP%\clean_report.txt" echo %~1^|%CF_RM%^|%CF_FL%^|%CF_TX%
>>"%PH_LOG%\limpeza_%TODAY%.txt" echo %~1: removidos=%CF_RM% nao_excluidos=%CF_FL% liberado=%CF_TX%
call :LOG "CLEAN_%~1: %CF_RM% removidos, %CF_FL% nao excluidos, %CF_TX%"
call :GRP %CI% "%MK_OK%" "%CL_LABEL%"
goto :CLNEXT
:CLSKIP
>>"%PH_TMP%\clean_report.txt" echo BIN^|0^|0^|mantida
call :GRP %CI% "%MK_SK%" "%CL_LABEL% - mantida"
:CLNEXT
set /a CI+=1
set /a "PCT=CI*100/11"
call :BAR %PCT%
exit /b

:CLREP
call :CLINFO %~1
set "CLB=%CL_LABEL%%BLANK%"
call :AT %CR% 15 "%D%%CLB:~0,38%%R%removidos: %~2%D%  ˙  n∆o exclu°dos: %R%%~3%D%  ˙  liberado: %R%%~4%N%"
set /a CR+=1
exit /b

rem ======================================================================
rem  6 - DESATIVAR
rem ======================================================================
:UDNAME
set "UDN=%~1"
if "%~1"=="APPS" set "UDN=Apps nativos removidos e OneDrive"
if "%~1"=="START" set "UDN=Inicializaá∆o autom†tica e segundo plano"
if "%~1"=="SVC" set "UDN=Serviáos e tarefas desativados"
if "%~1"=="PRIV" set "UDN=Telemetria, an£ncios e sugest‰es"
if "%~1"=="VISUAL" set "UDN=Animaá‰es e efeitos visuais"
if "%~1"=="POWER" set "UDN=Plano de energia e CPU"
if "%~1"=="GAME" set "UDN=GPU e configuraá‰es de jogos"
if "%~1"=="NET" set "UDN=Rede e latància"
if "%~1"=="BOOT" set "UDN=Reaplicar ao ligar o PC"
exit /b

:UD_CHK
set "UA_%~1=0"
findstr /x /c:"%~1" "%PH_ST%\applied.lst" >nul 2>&1
if not errorlevel 1 set "UA_%~1=1"
if not errorlevel 1 set "ANY=1"
exit /b

:UD_ROW
call set "UAV=%%UA_%~3%%"
if "%UAV%"=="1" call :AT %~1 15 "%R%[ %~2 ]  ATIVA   %~4%N%"
if not "%UAV%"=="1" call :AT %~1 15 "%D%[ %~2 ]  ------  %~4%N%"
exit /b

:UNDOUI
call :SCREEN "DESATIVAR"
set "ANY=0"
if exist "%PH_ST%\applied.lst" for %%i in (APPS START SVC PRIV VISUAL POWER GAME NET BOOT) do call :UD_CHK %%i
if "%ANY%"=="0" goto :UNDO_NONE
call :AT 17 15 "%R%OTIMIZAÄÂES APLICADAS PELO PRISMA HUB  -  escolha qual desfazer:%N%"
call :UD_ROW 19 1 APPS "Apps nativos removidos (Copilot, Teams, Widgets, Xbox...) e OneDrive"
call :UD_ROW 20 2 START "Inicializaá∆o autom†tica e segundo plano (Edge, OneDrive, Phone Link...)"
call :UD_ROW 21 3 SVC "Serviáos e tarefas agendadas desativados"
call :UD_ROW 22 4 PRIV "Telemetria, an£ncios e sugest‰es"
call :UD_ROW 23 5 VISUAL "Animaá‰es e efeitos visuais"
call :UD_ROW 24 6 POWER "Plano de energia e CPU"
call :UD_ROW 25 7 GAME "GPU e configuraá‰es de jogos"
call :UD_ROW 26 8 NET "Rede e latància"
call :UD_ROW 27 9 BOOT "Reaplicaá∆o autom†tica ao ligar o PC (tarefa agendada)"
call :AT 29 15 "%R%[ A ] %D%Desfazer TUDO de uma s¢ vez%N%"
call :AT 30 15 "%R%[ 0 ] %D%Voltar ao menu%N%"
choice /c 123456789A0 /n >nul
set "UC=%errorlevel%"
if %UC%==11 exit /b
if %UC%==10 goto :UNDO_ALL
set "UID="
for /f "tokens=%UC%" %%i in ("APPS START SVC PRIV VISUAL POWER GAME NET BOOT") do set "UID=%%i"
call set "UAV=%%UA_%UID%%%"
if not "%UAV%"=="1" goto :UNDO_OFF
call :UDNAME %UID%
call :AT 31 15 "%R%Desfazer: %UDN%%N%"
call :ASKYN 33 "Confirmar a revers∆o?"
if "%YN%"=="0" goto :UNDOUI
call :UNDO_RUN %UID%
goto :UNDOUI

:UNDO_OFF
call :AT 31 15 "%D%Essa otimizaá∆o n∆o est† ativa. Nada para desfazer.%N%"
call :PRESS
goto :UNDOUI

:UNDO_NONE
call :AT 17 15 "%R%Nenhuma otimizaá∆o foi aplicada pelo PRISMA HUB ainda.%N%"
call :AT 19 15 "%D%Use a opá∆o 1 (OTIMIZAÄ«O) e depois volte aqui para desfazer o que quiser.%N%"
call :PRESS
exit /b

:UNDO_ALL
set "UL="
for %%i in (BOOT NET GAME POWER VISUAL PRIV SVC START APPS) do call :UD_ADD %%i
call :AT 31 15 "%R%Desfazer TODAS as otimizaá‰es aplicadas.%N%"
call :ASKYN 33 "Confirmar a revers∆o completa?"
if "%YN%"=="0" goto :UNDOUI
call :UNDO_RUN %UL%
goto :UNDOUI

:UD_ADD
call set "UAV=%%UA_%~1%%"
if "%UAV%"=="1" set "UL=%UL% %~1"
exit /b

:UNDO_RUN
call :SCREEN "DESATIVAR"
set "RG=17"
set "RA=27"
set "RB=29"
set "UN=0"
set "UI=0"
set "UT_OK=0"
set "UT_FL=0"
set "UT_MN=0"
for %%i in (%*) do call :UD_DRAW %%i
call :BAR 0
for %%i in (%*) do call :UD_DO %%i
call :BAR 100
call :ACT "Revers∆o conclu°da."
>"%PH_ST%\needs_reboot.flag" echo 1
call :AT 31 15 "%R%Revertidos: %UT_OK%  ˙  Falhas: %UT_FL%  ˙  Apps para reinstalar pela Microsoft Store: %UT_MN%%N%"
call :AT 32 15 "%ESC%[7m  REINICIE O COMPUTADOR PARA CONCLUIR A REVERS«O.  %N%"
call :PRESS
exit /b

:UD_DRAW
call :UDNAME %~1
call :GRP %UN% "%MK_W%" "%UDN%"
set /a UN+=1
exit /b

:UD_DO
call :UDNAME %~1
call :GRP %UI% "%MK_R%" "%UDN%"
call :ACT "Desfazendo: %UDN%..."
set "PH_ITEM=%~1"
call :RS UNDO
set "U_OK=0"
set "U_FL=0"
set "U_MN=0"
for /f "usebackq tokens=1-3 delims=|" %%a in ("%PH_TMP%\res.txt") do (
    set "U_OK=%%a"
    set "U_FL=%%b"
    set "U_MN=%%c"
)
set /a UT_OK+=U_OK
set /a UT_FL+=U_FL
set /a UT_MN+=U_MN
call :LOG "Desfazer %~1: %RES%"
if "%U_FL%"=="0" call :GRP %UI% "%MK_OK%" "%UDN%"
if not "%U_FL%"=="0" call :GRP %UI% "%MK_ER%" "%UDN%"
set /a UI+=1
set /a "PCT=UI*100/UN"
call :BAR %PCT%
exit /b

rem ======================================================================
rem  4 - TUTORIAIS
rem ======================================================================
:TUT
call :SCREEN "TUTORIAIS"
call :TXTINIT 17
call :TXT "%R%ESCOLHA UMA CATEGORIA"
call :TXT " "
call :TXT "%R%[ 1 ] %D%Primeiros passos e como o programa funciona"
call :TXT "%R%[ 2 ] %D%Opá∆o 1 - OTIMIZAÄ«O"
call :TXT "%R%[ 3 ] %D%Opá∆o 2 - LIMPAR MEM‡RIA"
call :TXT "%R%[ 4 ] %D%Opá∆o 3 - BACKUP"
call :TXT "%R%[ 5 ] %D%Opá∆o 6 - DESATIVAR (desfazer alteraá‰es)"
call :TXT "%R%[ 6 ] %D%Logs: onde ficam e como interpretar"
call :TXT "%R%[ 7 ] %D%Dicas de manutená∆o e desempenho (RAM, inicializaá∆o, drivers)"
call :TXT "%R%[ 8 ] %D%FPS em jogos: o que Ç feito e o que fazer por fora"
call :TXT " "
call :TXT "%R%[ 0 ] %D%Voltar ao menu"
choice /c 123456780 /n >nul
set "TC=%errorlevel%"
if %TC%==9 exit /b
call :TUTP%TC%
goto :TUT

:TUTP1
call :SCREEN "TUTORIAIS - PRIMEIROS PASSOS"
call :TXTINIT 17
call :TXT "%R%COMO USAR O PRISMA HUB CMD"
call :TXT "%D%O programa melhora o desempenho do Windows 10 e 11 em quatro passos simples:"
call :TXT " "
call :TXT "%R%  1. %D%Faáa o BACKUP (opá∆o 3). Ele Ç criado uma £nica vez e guarda suas configuraá‰es originais."
call :TXT "%R%  2. %D%Rode a OTIMIZAÄ«O (opá∆o 1) e reinicie o computador quando o programa avisar."
call :TXT "%R%  3. %D%Use LIMPAR MEM‡RIA (opá∆o 2) de tempos em tempos para liberar espaáo no HD ou SSD."
call :TXT "%R%  4. %D%Se algo n∆o agradar, use DESATIVAR (opá∆o 6) para desfazer uma ou todas as alteraá‰es."
call :TXT " "
call :TXT "%D%O menu aceita s¢ o n£mero da opá∆o, sem Enter. O programa pede permiss∆o de Administrador sozinho."
call :TXT "%D%Antes de otimizar ou limpar, ele confere o backup. Sem backup, abre a p†gina de backup e pede a criaá∆o."
call :TXT "%D%Se a criaá∆o ou a verificaá∆o do backup falhar, a operaá∆o Ç cancelada para proteger o seu sistema."
call :TXT " "
call :TXT "%R%Nunca s∆o alterados: %D%drivers, Windows Defender, Firewall e serviáos essenciais do Windows."
call :TXT "%R%Sair (opá∆o 0): %D%conclui o programa e avisa se o Windows precisa ser reiniciado."
call :PRESS
exit /b

:TUTP2
call :SCREEN "TUTORIAIS - OTIMIZAÄ«O"
call :TXTINIT 17
call :TXT "%R%O QUE FAZ"
call :TXT "%D%Remove apps nativos e de brinde, desliga serviáos, tarefas, telemetria, animaá‰es e inicializaá∆o autom†tica,"
call :TXT "%D%agrupa os serviáos do Windows em menos processos e ajusta CPU, GPU, jogos, navegadores e rede."
call :TXT "%R%RESULTADO"
call :TXT "%D%O programa mostra processos e RAM reais, antes e depois. O ganho maior aparece depois de reiniciar."
call :TXT "%D%A RAM liberada na hora volta a ser usada quando vocà abre programas. O ganho fixo vem de menos coisas ativas."
call :TXT "%R%REINICIE E REAPLICAÄ«O"
call :TXT "%D%O programa s¢ avisa para reiniciar. A cada login ele reaplica tudo numa janela com barra de progresso."
call :TXT "%R%CUIDADOS"
call :TXT "%D%Apps como Discord, Steam e Spotify deixam de abrir sozinhos. Antiv°rus, drivers e perifÇricos ficam."
call :TXT "%D%O OneDrive s¢ sai se Desktop e Documentos n∆o estiverem nele. Os Serviáos de Jogos do Xbox ficam."
call :TXT "%D%Indexaá∆o de pesquisa e compartilhamento de arquivos sem uso s∆o desligados. Desfaáa se precisar deles."
call :TXT "%D%Serviáos agrupados poupam RAM, mas se um travar, outros do grupo podem ser afetados."
call :TXT "%D%Edge e Chrome podem mostrar gerenciado pela sua organizaá∆o: Ç s¢ o aviso das pol°ticas aplicadas."
call :TXT "%R%N«O RECOMENDADO"
call :TXT "%D%Se vocà usa Game Pass, Phone Link, Teams pessoal, Email e Calend†rio, ou se o PC Ç de empresa."
call :PRESS
exit /b

:TUTP3
call :SCREEN "TUTORIAIS - LIMPAR MEM‡RIA"
call :TXTINIT 17
call :TXT "%R%O QUE FAZ"
call :TXT "%D%Apaga tempor†rios, caches e a lixeira para liberar espaáo no HD ou SSD. N∆o mexe em documentos,"
call :TXT "%D%fotos, jogos nem programas. Antes de apagar, mostra cada item com local e tamanho e pede confirmaá∆o."
call :TXT "%R%COMO FUNCIONA"
call :TXT "%D%Tempor†rios: s¢ arquivos com mais de 24 horas, para n∆o quebrar instaladores em andamento."
call :TXT "%D%Navegadores: s¢ o cache. Senhas, cookies e hist¢rico n∆o s∆o tocados. Feche-os antes de limpar."
call :TXT "%D%Lixeira: pergunta Ö parte, porque apagar Ç definitivo."
call :TXT "%R%IMPORTANTE"
call :TXT "%D%Arquivos apagados n∆o podem ser restaurados pelo PRISMA HUB CMD. N∆o h† revers∆o garantida."
call :TXT "%D%No fim, o relat¢rio mostra o que foi removido, o que estava em uso e o espaáo realmente liberado."
call :TXT "%R%QUANDO USAR"
call :TXT "%D%Uma vez por màs ou quando o disco estiver quase cheio."
call :TXT "%R%QUANDO EVITAR"
call :TXT "%D%Se h† algo importante na lixeira, ou durante downloads, instalaá‰es e o Windows Update."
call :PRESS
exit /b

:TUTP4
call :SCREEN "TUTORIAIS - BACKUP"
call :TXTINIT 17
call :TXT "%R%O QUE FAZ"
call :TXT "%D%Cria um £nico backup inicial, antes de qualquer alteraá∆o. Ele guarda um ponto de restauraá∆o do Windows,"
call :TXT "%D%as chaves de registro exportadas, serviáos, plano de energia, apps instalados, tarefas, inicializaá∆o e rede."
call :TXT "%R%ONDE FICA"
call :TXT "%D%%PH_BK%"
call :TXT "%D%N∆o apague essa pasta: a opá∆o DESATIVAR depende dela."
call :TXT "%R%QUANDO Jµ EXISTE"
call :TXT "%D%O programa informa status, data, hor†rio e local, e n∆o cria outro backup."
call :TXT "%R%SE FALHAR"
call :TXT "%D%Otimizaá∆o e limpeza ficam bloqueadas atÇ resolver. Libere espaáo, pause o antiv°rus e tente de novo."
call :TXT "%R%RESTAURAR NA M«O"
call :TXT "%D%Digite Criar um ponto de restauraá∆o no Windows e abra Restauraá∆o do Sistema."
call :TXT "%D%Os arquivos .reg da pasta de backup podem ser importados com duplo clique."
call :PRESS
exit /b

:TUTP5
call :SCREEN "TUTORIAIS - DESATIVAR"
call :TXTINIT 17
call :TXT "%R%O QUE FAZ"
call :TXT "%D%Lista tudo o que o PRISMA HUB aplicou e deixa vocà desfazer uma opá∆o por vez, ou tudo de uma s¢ vez."
call :TXT "%R%COMO DESFAZ"
call :TXT "%D%Antes de cada mudanáa, o programa salva o valor original. Ao desfazer, ele devolve esses valores:"
call :TXT "%D%registro, serviáos, tarefas agendadas e plano de energia."
call :TXT "%R%APPS REMOVIDOS"
call :TXT "%D%O programa tenta restaurar. Se n∆o conseguir, ele avisa e o app deve ser reinstalado pela Microsoft Store."
call :TXT "%D%O OneDrive volta pelo instalador do pr¢prio Windows."
call :TXT "%R%REAPLICAR AO LIGAR"
call :TXT "%D%O item 9 remove a tarefa que reaplica as otimizaá‰es no login. As demais voltam a valer s¢ no que sobrar."
call :TXT "%R%DEPOIS DE DESFAZER"
call :TXT "%D%Reinicie o computador para concluir."
call :TXT "%R%QUANDO USAR"
call :TXT "%D%Se sentir falta de um recurso (Xbox, Phone Link, Widgets...), se algo der problema depois de otimizar,"
call :TXT "%D%ou antes de passar o computador para outra pessoa."
call :PRESS
exit /b

:TUTP6
call :SCREEN "TUTORIAIS - LOGS"
call :TXTINIT 17
call :TXT "%R%ONDE FICAM"
call :TXT "%D%%PH_LOG%"
call :TXT "%D%Para abrir: copie o caminho acima e cole na barra de endereáo do Explorador de Arquivos."
call :TXT "%R%ARQUIVOS"
call :TXT "%D%prisma_AAAAMMDD.log ........ tudo o que o programa fez no dia: otimizaá‰es, desfazer, backup e erros."
call :TXT "%D%limpeza_AAAAMMDD.txt ....... relat¢rio da limpeza: removidos, n∆o exclu°dos e espaáo liberado."
call :TXT "%D%limpeza_falhas.txt ......... lista dos arquivos que estavam em uso e n∆o puderam ser apagados."
call :TXT "%D%Linhas BOOT mostram o que foi reaplicado ao entrar no Windows. A limpeza nunca roda sozinha."
call :TXT "%R%COMO LER"
call :TXT "%D%Cada linha comeáa com a hora. Exemplo: [14:32:10] OPT_SVC: 9/2/-"
call :TXT "%D%O primeiro n£mero Ç o que foi alterado e o segundo Ç o que foi ignorado ou falhou (9 alterados, 2 ignorados)."
call :TXT "%D%Procure as palavras FALHOU, NAO e cancelado: indicam erros, itens n∆o removidos ou operaá‰es canceladas."
call :PRESS
exit /b

:TUTP7
call :SCREEN "TUTORIAIS - DICAS DE DESEMPENHO"
call :TXTINIT 17
call :TXT "%R%MANUTENÄ«O"
call :TXT "%D%Use LIMPAR MEM‡RIA uma vez por màs. Reinicie o PC pelo menos uma vez por semana."
call :TXT "%R%QUEM USA A RAM"
call :TXT "%D%Ctrl + Shift + Esc, aba Processos, ordene por Mem¢ria. Feche ou desinstale o que vocà n∆o usa."
call :TXT "%R%MAIS FPS"
call :TXT "%D%Feche navegador e programas em segundo plano. Jogue com o PC na tomada, no plano de alto desempenho."
call :TXT "%D%Reduza sombras, anti-aliasing e resoluá∆o no pr¢prio jogo. Mantenha o driver da GPU atualizado."
call :TXT "%R%INICIALIZAÄ«O"
call :TXT "%D%Gerenciador de Tarefas, aba Inicializar: desative o que n∆o precisa abrir junto com o Windows."
call :TXT "%R%DRIVERS"
call :TXT "%D%Atualize GPU, chipset e rede pelo site do fabricante. Evite programas de terceiros que atualizam drivers."
call :TXT "%R%SEGURANÄA E TEMPERATURA"
call :TXT "%D%Mantenha o Windows Defender ativo e use um s¢ antiv°rus. Limpe a poeira: calor reduz o desempenho."
call :PRESS
exit /b

:TUTP8
call :SCREEN "TUTORIAIS - FPS EM JOGOS"
call :TXTINIT 17
call :TXT "%R%O QUE O PROGRAMA FAZ PELO SEU FPS"
call :TXT "%D%Modo Jogo ligado, gravaá∆o em segundo plano desligada, prioridade multim°dia e plano de energia de alto"
call :TXT "%D%desempenho. Mouse sem aceleraá∆o e sem o aviso das Teclas de Aderància, que minimiza o jogo."
call :TXT "%D%Notebook com duas placas de v°deo: seus jogos passam a usar a GPU dedicada. Placa Intel: mais mem¢ria de v°deo."
call :TXT "%D%Rede: adaptador sem economia de energia e sem espera de pacotes, o que ajuda no ping."
call :TXT "%R%O QUE N«O ê FEITO, DE PROP‡SITO"
call :TXT "%D%Isolamento de N£cleo, mitigaá‰es de CPU e Defender continuam ligados: s∆o proteá‰es do sistema."
call :TXT "%D%Custam um pouco de FPS em alguns jogos, mas desligar abre brechas. A escolha Ç sua, no Windows."
call :TXT "%R%O QUE AJUDA DE VERDADE POR FORA"
call :TXT "%D%Driver da GPU atualizado, jogo instalado em SSD e notebook na tomada. Limpe a poeira se esquentar demais."
call :TXT "%D%No jogo: reduza sombras, anti-aliasing, distÉncia de vis∆o e resoluá∆o. Prefira tela cheia ou sem bordas."
call :TXT "%D%Feche navegador, overlays e gravadores antes de jogar. Temperatura alta na CPU ou na GPU derruba o FPS."
call :TXT "%D%Com 8 GB de RAM, o ganho vem de sobrar mem¢ria para o jogo. Por isso feche o resto antes de jogar."
call :PRESS
exit /b

rem ======================================================================
rem  BOOT - tela de reaplicacao automatica no login
rem ======================================================================
:BOOTUI
call :SCREEN "REAPLICAÄ«O AO LIGAR"
call :AT 6 3 "%R%>> Reaplicando suas otimizaá‰es automaticamente...%N%"
call :SETL
set "L9=Encerrando processos e liberando RAM"
call :OPT_LIST
call :BAR 0
if not exist "%PH_ST%\applied.lst" goto :BOOT_NONE
call :BKCHECK
if not "%BK_OK%"=="1" goto :BOOT_NOBK
set "PC_B=0"
set "PR_B=0"
set "PC_A=0"
set "PR_A=0"
call :RUNPS PCOUNT > "%PH_TMP%\pc.txt" 2>nul
for /f "usebackq tokens=1-3 delims=|" %%a in ("%PH_TMP%\pc.txt") do (
    set "PC_B=%%a"
    set "PR_B=%%b"
)
call :GRP 0 "%MK_R%" "%L0%"
call :ACT "%L0%..."
call :GRP 0 "%MK_OK%" "%L0%"
call :BAR 5
call :BOOT_STEP 1 45 APPS
call :BOOT_STEP 2 55 START
call :BOOT_STEP 3 65 SVC
call :BOOT_STEP 4 72 PRIV
call :BOOT_STEP 5 80 VISUAL
call :BOOT_STEP 6 87 POWER
call :BOOT_STEP 7 93 GAME
call :BOOT_STEP 8 97 NET
call :GRP 9 "%MK_R%" "%L9%"
call :ACT "%L9%..."
call :RS OPT_KILL
call :LOG "BOOT OPT_KILL: %RES%"
call :RUNPS PCOUNT > "%PH_TMP%\pc.txt" 2>nul
for /f "usebackq tokens=1-3 delims=|" %%a in ("%PH_TMP%\pc.txt") do (
    set "PC_A=%%a"
    set "PR_A=%%b"
)
call :GRP 9 "%MK_OK%" "%L9%"
call :BAR 100
call :ACT "Reaplicaá∆o conclu°da."
set /a PC_D=PC_B-PC_A
if %PC_D% lss 0 set "PC_D=0"
set /a PR_D=PR_B-PR_A
if %PR_D% lss 0 set "PR_D=0"
call :LOG "BOOT: processos %PC_B% para %PC_A%, RAM em uso %PR_B% MB para %PR_A% MB"
call :AT 31 15 "%R%Processos: %PC_B% > %PC_A% (menos %PC_D%)  ˙  RAM em uso: %PR_B% MB > %PR_A% MB (menos %PR_D% MB)%N%"
call :AT 32 15 "%D%Para desativar a reaplicaá∆o: abra o PRISMA HUB, opá∆o 6, item 9.%N%"
goto :BOOT_WAIT

:BOOT_NONE
call :AT 31 15 "%D%Nenhuma otimizaá∆o ativa para reaplicar.%N%"
goto :BOOT_WAIT

:BOOT_NOBK
call :LOG "BOOT: backup invalido, nada foi aplicado"
call :AT 31 15 "%ESC%[7m  Backup n∆o encontrado: nada foi aplicado. Abra o PRISMA HUB e crie o backup (opá∆o 3).  %N%"

:BOOT_WAIT
call :AT 33 15 "%R%Esta janela fecha sozinha em 12 segundos. Pressione S para fechar agora.%N%"
choice /c S /t 12 /d S /n >nul
exit /b

:BOOT_STEP
call set "LB=%%L%~1%%"
findstr /x /c:"%~3" "%PH_ST%\applied.lst" >nul 2>&1
if errorlevel 1 goto :BOOT_SKIP
call :GRP %~1 "%MK_R%" "%LB%"
call :ACT "%LB%..."
set "BS_SEC=OPT_%~3"
if "%~3"=="APPS" set "PH_PART=0"
call :RS %BS_SEC%
call :LOG "BOOT %~3: %RES%"
call :SRCOUNT
call :GRP %~1 "%MK_OK%" "%LB%  [%SR_A%]%SR_X%"
call :BAR %~2
exit /b
:BOOT_SKIP
call :GRP %~1 "%MK_SK%" "%LB% - n∆o ativo"
call :BAR %~2
exit /b

#<LIB>
$ErrorActionPreference = 'SilentlyContinue'
$PH  = Join-Path $env:ProgramData 'PrismaHub'
$BK  = Join-Path $PH 'backup'
$ST  = Join-Path $PH 'state'
$LG  = Join-Path $PH 'logs'
$LOGF = Join-Path $LG ('prisma_' + (Get-Date -Format 'yyyyMMdd') + '.log')
function Log([string]$m) { Add-Content -Path $LOGF -Value ('[' + (Get-Date -Format 'HH:mm:ss') + '] ' + $m) }
$script:JL = @{}
function JFile([string]$item) { Join-Path $ST ('journal_' + $item + '.json') }
function JBegin([string]$item) {
    $l = New-Object System.Collections.ArrayList
    $f = JFile $item
    if (Test-Path -LiteralPath $f) {
        $raw = Get-Content -LiteralPath $f -Raw
        if ($raw) { foreach ($e in @(ConvertFrom-Json $raw)) { [void]$l.Add($e) } }
    }
    $script:JL[$item] = $l
}
function JEnd([string]$item) {
    $json = ConvertTo-Json -InputObject @($script:JL[$item]) -Depth 5
    Set-Content -LiteralPath (JFile $item) -Value $json -Encoding UTF8
    $ap = Join-Path $ST 'applied.lst'
    $has = $false
    if (Test-Path -LiteralPath $ap) { $has = [bool](Select-String -Path $ap -Pattern ('^' + $item + '$') -Quiet) }
    if (-not $has) { Add-Content -Path $ap -Value $item }
}
function JHas([string]$item, [string]$t, [string]$k1, [string]$k2) {
    foreach ($e in $script:JL[$item]) { if ($e.t -eq $t -and $e.k1 -eq $k1 -and $e.k2 -eq $k2) { return $true } }
    return $false
}
function JReg([string]$item, [string]$path, [string]$name) {
    if (JHas $item 'reg' $path $name) { return }
    $ex = $false; $kind = ''; $val = ''
    $k = Get-Item -LiteralPath $path -ErrorAction SilentlyContinue
    if ($k) {
        $v = $k.GetValue($name, $null, [Microsoft.Win32.RegistryValueOptions]::DoNotExpandEnvironmentNames)
        if ($v -ne $null) {
            $ex = $true
            $kind = $k.GetValueKind($name).ToString()
            if ($v -is [byte[]]) { $val = (($v | ForEach-Object { $_.ToString('x2') }) -join '') }
            elseif ($v -is [string[]]) { $val = ($v -join "`n") }
            else { $val = [string]$v }
        }
    }
    [void]$script:JL[$item].Add([pscustomobject]@{ t = 'reg'; k1 = $path; k2 = $name; existed = $ex; kind = $kind; value = $val })
}
function RegSet([string]$item, [string]$path, [string]$name, $value, [string]$type) {
    JReg $item $path $name
    if (-not (Test-Path -LiteralPath $path)) { New-Item -Path $path -Force | Out-Null }
    Set-ItemProperty -LiteralPath $path -Name $name -Value $value -Type $type -Force -ErrorAction SilentlyContinue
    $chk = (Get-ItemProperty -LiteralPath $path -Name $name -ErrorAction SilentlyContinue).$name
    return ($chk -ne $null)
}
function RegDel([string]$item, [string]$path, [string]$name) {
    JReg $item $path $name
    Remove-ItemProperty -LiteralPath $path -Name $name -Force -ErrorAction SilentlyContinue
}
function JUndoReg($e) {
    $p = [string]$e.k1; $n = [string]$e.k2
    try {
        if ($e.existed) {
            if (-not (Test-Path -LiteralPath $p)) { New-Item -Path $p -Force | Out-Null }
            $kind = [string]$e.kind
            if ($kind -eq 'Binary') {
                $hex = [string]$e.value
                $b = New-Object byte[] ([int]($hex.Length / 2))
                for ($i = 0; $i -lt $b.Length; $i++) { $b[$i] = [Convert]::ToByte($hex.Substring($i * 2, 2), 16) }
                Set-ItemProperty -LiteralPath $p -Name $n -Value $b -Type Binary -Force -ErrorAction Stop
            }
            elseif ($kind -eq 'DWord') { Set-ItemProperty -LiteralPath $p -Name $n -Value ([int]$e.value) -Type DWord -Force -ErrorAction Stop }
            elseif ($kind -eq 'QWord') { Set-ItemProperty -LiteralPath $p -Name $n -Value ([int64]$e.value) -Type QWord -Force -ErrorAction Stop }
            elseif ($kind -eq 'MultiString') { Set-ItemProperty -LiteralPath $p -Name $n -Value ([string[]]([string]$e.value -split "`n")) -Type MultiString -Force -ErrorAction Stop }
            elseif ($kind -eq 'ExpandString') { Set-ItemProperty -LiteralPath $p -Name $n -Value ([string]$e.value) -Type ExpandString -Force -ErrorAction Stop }
            else { Set-ItemProperty -LiteralPath $p -Name $n -Value ([string]$e.value) -Type String -Force -ErrorAction Stop }
        }
        else {
            Remove-ItemProperty -LiteralPath $p -Name $n -Force -ErrorAction SilentlyContinue
        }
        return $true
    }
    catch { return $false }
}
function OneDriveKFM {
    $u = Get-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders'
    foreach ($n in 'Desktop', 'Personal', 'My Pictures') { if ([string]$u.$n -match 'OneDrive') { return $true } }
    return $false
}
function FmtSize([int64]$b) {
    $ci = [Globalization.CultureInfo]::InvariantCulture
    if ($b -ge 1GB) { return ([math]::Round($b / 1GB, 2)).ToString('0.00', $ci) + ' GB' }
    if ($b -ge 1MB) { return ([math]::Round($b / 1MB, 1)).ToString('0.0', $ci) + ' MB' }
    return ([math]::Round($b / 1KB, 0)).ToString('0', $ci) + ' KB'
}
function BrowserCacheDirs([string]$ud) {
    $r = @()
    if (-not (Test-Path -LiteralPath $ud)) { return $r }
    foreach ($pf in @(Get-ChildItem -LiteralPath $ud -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -eq 'Default' -or $_.Name -like 'Profile *' })) {
        foreach ($sub in 'Cache', 'Code Cache', 'GPUCache') { $r += (Join-Path $pf.FullName $sub) }
    }
    return $r
}
function CleanSpec([string]$cat) {
    $dirs = @(); $age = 0; $filter = '*'
    $lad = $env:LOCALAPPDATA; $pd = $env:ProgramData; $win = $env:SystemRoot
    switch ($cat) {
        'TEMPU'   { $dirs = @($env:TEMP); $age = 1 }
        'TEMPW'   { $dirs = @((Join-Path $win 'Temp')); $age = 1 }
        'INET'    { $dirs = @((Join-Path $lad 'Microsoft\Windows\INetCache')) }
        'THUMB'   { $dirs = @((Join-Path $lad 'Microsoft\Windows\Explorer')); $filter = '*cache_*.db' }
        'WU'      { $dirs = @((Join-Path $win 'SoftwareDistribution\Download')) }
        'DO'      { $dirs = @((Join-Path $win 'ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\Cache')) }
        'WER'     { $dirs = @((Join-Path $pd 'Microsoft\Windows\WER\ReportArchive'), (Join-Path $pd 'Microsoft\Windows\WER\ReportQueue'), (Join-Path $lad 'CrashDumps'), (Join-Path $win 'Minidump')) }
        'EDGE'    { $dirs = @(BrowserCacheDirs (Join-Path $lad 'Microsoft\Edge\User Data')) }
        'CHROME'  { $dirs = @(BrowserCacheDirs (Join-Path $lad 'Google\Chrome\User Data')) }
        'FIREFOX' { $dirs = @(Get-ChildItem -LiteralPath (Join-Path $lad 'Mozilla\Firefox\Profiles') -Directory -ErrorAction SilentlyContinue | ForEach-Object { Join-Path $_.FullName 'cache2' }) }
    }
    $ok = @($dirs | Where-Object { $_ -and (Test-Path -LiteralPath $_) })
    return [pscustomobject]@{ dirs = $ok; age = $age; filter = $filter }
}
function CleanFiles($spec) {
    $cut = (Get-Date).AddDays(-1 * $spec.age)
    foreach ($d in $spec.dirs) {
        Get-ChildItem -LiteralPath $d -Recurse -File -Force -Filter $spec.filter -ErrorAction SilentlyContinue | Where-Object { $spec.age -eq 0 -or $_.LastWriteTime -lt $cut }
    }
}
function BinInfo {
    $cnt = 0; $sum = [int64]0
    foreach ($dr in [System.IO.DriveInfo]::GetDrives()) {
        if ($dr.DriveType -ne 'Fixed') { continue }
        $rb = Join-Path $dr.RootDirectory.FullName '$Recycle.Bin'
        if (-not (Test-Path -LiteralPath $rb)) { continue }
        foreach ($sid in @(Get-ChildItem -LiteralPath $rb -Force -Directory -ErrorAction SilentlyContinue)) {
            foreach ($it in @(Get-ChildItem -LiteralPath $sid.FullName -Force -ErrorAction SilentlyContinue | Where-Object { $_.Name -like '$R*' })) {
                $cnt++
                if ($it.PSIsContainer) { $sum += [int64](Get-ChildItem -LiteralPath $it.FullName -Recurse -File -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum }
                else { $sum += [int64]$it.Length }
            }
        }
    }
    return @($cnt, $sum)
}
function FindGames {
    $roots = New-Object System.Collections.ArrayList
    foreach ($dr in [System.IO.DriveInfo]::GetDrives()) {
        if ($dr.DriveType -ne 'Fixed') { continue }
        $rt = $dr.RootDirectory.FullName
        foreach ($sub in 'SteamLibrary\steamapps\common', 'Steam\steamapps\common', 'Program Files (x86)\Steam\steamapps\common', 'Program Files\Steam\steamapps\common', 'Program Files\Epic Games', 'Program Files (x86)\Epic Games', 'Epic Games', 'XboxGames', 'Games', 'GOG Games', 'Riot Games', 'Program Files\Riot Games', 'Program Files (x86)\Ubisoft\Ubisoft Game Launcher\games', 'Program Files\EA Games', 'Program Files (x86)\Origin Games') {
            $p = Join-Path $rt $sub
            if (Test-Path -LiteralPath $p) { [void]$roots.Add($p) }
        }
    }
    $sp = [string](Get-ItemProperty 'HKCU:\Software\Valve\Steam' -ErrorAction SilentlyContinue).SteamPath
    if ($sp) {
        $c = Join-Path ($sp -replace '/', '\') 'steamapps\common'
        if (Test-Path -LiteralPath $c) { [void]$roots.Add($c) }
    }
    $skip = 'unins|crash|report|redist|vcredist|dxsetup|setup|install|helper|launcher|updater|easyanticheat|battleye|webhelper|notification|bootstrap|handler|diagnos'
    $out = New-Object System.Collections.ArrayList
    foreach ($rt in @($roots | Select-Object -Unique)) {
        foreach ($f in @(Get-ChildItem -LiteralPath $rt -Recurse -Depth 3 -Filter *.exe -File -ErrorAction SilentlyContinue)) {
            if ($f.Length -lt 8MB) { continue }
            if ($f.Name -match $skip) { continue }
            [void]$out.Add($f.FullName)
            if ($out.Count -ge 80) { break }
        }
        if ($out.Count -ge 80) { break }
    }
    return @($out | Select-Object -Unique)
}
#</LIB>

#<HW>
$os = Get-CimInstance Win32_OperatingSystem
$cap = ($os.Caption -replace 'Microsoft ', '').Trim()
$cpu = [string](Get-CimInstance Win32_Processor | Select-Object -First 1).Name
$cpu = ($cpu -replace '\s+@.*$', '' -replace '(i[3579])-\w+', '$1' -replace '\s+CPU', '' -replace '\s+\d+-Core Processor', '' -replace '\s+Processor', '').Trim()
$gl = @(Get-CimInstance Win32_VideoController | Where-Object { $_.Name -notmatch 'Basic|Remote|Virtual' })
$g = $gl | Where-Object { $_.Name -match 'NVIDIA|Radeon|AMD' } | Select-Object -First 1
if (-not $g) { $g = $gl | Select-Object -First 1 }
$gpu = [string]$g.Name
$gpu = ($gpu -replace '(Graphics)\s+\d+', '$1').Trim()
$ram = [math]::Round($os.TotalVisibleMemorySize / 1MB)
$dk = Get-CimInstance Win32_LogicalDisk -Filter ("DeviceID='" + $env:SystemDrive + "'")
$dsk = [math]::Round($dk.Size / 1GB)
if ($cap.Length -gt 26) { $cap = $cap.Substring(0, 26) }
if ($cpu.Length -gt 24) { $cpu = $cpu.Substring(0, 24) }
if ($gpu.Length -gt 24) { $gpu = $gpu.Substring(0, 24) }
if (-not $cpu) { $cpu = 'N/D' }
if (-not $gpu) { $gpu = 'N/D' }
Write-Output ($cap + '|' + $cpu + '|' + $gpu + '|' + $ram + '|' + $dsk + '|' + (Get-Date -Format 'yyyyMMdd_HHmmss'))
#</HW>

#<NOW>
$ci = [Globalization.CultureInfo]::InvariantCulture
$d = Get-Date
Write-Output ($d.ToString('dd/MM/yyyy', $ci) + '|' + $d.ToString('HH:mm:ss', $ci))
#</NOW>

#<RESTOREPOINT>
$sr = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore'
$old = (Get-ItemProperty -Path $sr -Name SystemRestorePointCreationFrequency -ErrorAction SilentlyContinue).SystemRestorePointCreationFrequency
Set-ItemProperty -Path $sr -Name SystemRestorePointCreationFrequency -Value 0 -Type DWord -Force
Enable-ComputerRestore -Drive ($env:SystemDrive + '\')
Checkpoint-Computer -Description 'PRISMA HUB - backup inicial' -RestorePointType 'MODIFY_SETTINGS'
if ($old -eq $null) { Remove-ItemProperty -Path $sr -Name SystemRestorePointCreationFrequency -ErrorAction SilentlyContinue }
else { Set-ItemProperty -Path $sr -Name SystemRestorePointCreationFrequency -Value $old -Type DWord -Force }
$found = Get-ComputerRestorePoint | Where-Object { $_.Description -like 'PRISMA HUB*' }
if ($found) { exit 0 } else { exit 1 }
#</RESTOREPOINT>

#<SNAPSHOT>
New-Item -ItemType Directory -Force -Path $BK | Out-Null
Get-CimInstance Win32_Service | Select-Object Name, StartMode, State, DisplayName | Export-Csv -Path (Join-Path $BK 'services.csv') -NoTypeInformation -Encoding UTF8
$g = (powercfg /getactivescheme | Out-String).Trim()
Set-Content -Path (Join-Path $BK 'power_active.txt') -Value $g
if ($g -match '([0-9a-fA-F]{8}(-[0-9a-fA-F]{4}){3}-[0-9a-fA-F]{12})') {
    $pow = Join-Path $BK 'power_original.pow'
    Remove-Item -LiteralPath $pow -Force -ErrorAction SilentlyContinue
    powercfg /export $pow $Matches[1] | Out-Null
}
Get-AppxPackage -AllUsers | Select-Object Name, PackageFullName, Version | Export-Csv -Path (Join-Path $BK 'apps.csv') -NoTypeInformation -Encoding UTF8
Get-CimInstance Win32_StartupCommand | Select-Object Name, Command, Location, User | Export-Csv -Path (Join-Path $BK 'startup.csv') -NoTypeInformation -Encoding UTF8
Get-ScheduledTask | Select-Object TaskPath, TaskName, State | Export-Csv -Path (Join-Path $BK 'tasks.csv') -NoTypeInformation -Encoding UTF8
netsh int tcp show global | Out-File -FilePath (Join-Path $BK 'network_tcp.txt')
ipconfig /all | Out-File -FilePath (Join-Path $BK 'network_ipconfig.txt')
Get-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' | Out-File -FilePath (Join-Path $BK 'shell_folders.txt')
$s1 = Get-Item -LiteralPath (Join-Path $BK 'services.csv') -ErrorAction SilentlyContinue
$s2 = Get-Item -LiteralPath (Join-Path $BK 'power_active.txt') -ErrorAction SilentlyContinue
if ($s1 -and $s1.Length -gt 100 -and $s2 -and $s2.Length -gt 5) { exit 0 } else { exit 1 }
#</SNAPSHOT>

#<RESTARTCHK>
$pend = $false
if (Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending') { $pend = $true }
if (Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired') { $pend = $true }
$fl = Join-Path $ST 'needs_reboot.flag'
if (Test-Path -LiteralPath $fl) {
    $boot = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
    if ((Get-Item -LiteralPath $fl).LastWriteTime -gt $boot) { $pend = $true }
    else { Remove-Item -LiteralPath $fl -Force -ErrorAction SilentlyContinue }
}
if ($pend) { exit 1 } else { exit 0 }
#</RESTARTCHK>

#<PCOUNT>
$t = 0; $a = 0
try {
    Add-Type -AssemblyName Microsoft.VisualBasic
    $ci = New-Object Microsoft.VisualBasic.Devices.ComputerInfo
    $t = [int]($ci.TotalPhysicalMemory / 1MB)
    $a = [int]($ci.AvailablePhysicalMemory / 1MB)
}
catch {
    $os = Get-CimInstance Win32_OperatingSystem
    $t = [int]($os.TotalVisibleMemorySize / 1024)
    $a = [int]($os.FreePhysicalMemory / 1024)
}
Write-Output ([string]@(Get-Process).Count + '|' + ($t - $a) + '|' + $t)
#</PCOUNT>

#<FREE>
$d = Get-PSDrive -Name ($env:SystemDrive.Substring(0, 1))
Write-Output ([int64]($d.Free / 1MB))
#</FREE>

#<OPT_APPS>
$names = @(
    'Microsoft.Copilot', 'MicrosoftTeams', 'MSTeams', 'MicrosoftWindows.Client.WebExperience', 'Microsoft.YourPhone',
    'Microsoft.XboxGamingOverlay', 'Microsoft.XboxGameOverlay', 'Microsoft.XboxApp', 'Microsoft.GamingApp', 'Microsoft.XboxSpeechToTextOverlay',
    'Microsoft.549981C3F5F10', 'Clipchamp.Clipchamp', 'Microsoft.BingNews', 'Microsoft.BingWeather', 'Microsoft.WindowsMaps',
    'Microsoft.Getstarted', 'Microsoft.GetHelp', 'Microsoft.WindowsFeedbackHub', 'Microsoft.MicrosoftOfficeHub', 'Microsoft.OutlookForWindows',
    'microsoft.windowscommunicationsapps', 'Microsoft.MicrosoftSolitaireCollection', 'Microsoft.ZuneVideo', 'Microsoft.ZuneMusic', 'Microsoft.MSPaint',
    'Microsoft.Microsoft3DViewer', 'Microsoft.MixedReality.Portal', 'Microsoft.Windows.DevHome', 'MicrosoftCorporationII.QuickAssist', 'Microsoft.People',
    'Microsoft.SkypeApp', 'Microsoft.BingSearch', 'Microsoft.BingFinance', 'Microsoft.BingSports', 'Microsoft.Wallet',
    'Microsoft.OneConnect', 'Microsoft.Print3D', 'Microsoft.Messaging', 'Microsoft.PowerAutomateDesktop',
    'Microsoft.Todos', 'Microsoft.Office.OneNote', 'Microsoft.Whiteboard', 'Microsoft.MicrosoftJournal', 'Microsoft.3DBuilder',
    'Microsoft.Office.Sway', 'Microsoft.Advertising.Xaml', 'Microsoft.NetworkSpeedTest', 'Microsoft.RemoteDesktop', 'Microsoft.WindowsSoundRecorder',
    'Microsoft.WindowsAlarms', 'MicrosoftCorporationII.MicrosoftFamily', 'Microsoft.LinkedIn',
    'king.com.*', '*CandyCrush*', 'Disney.*', 'BytedancePte.Ltd.TikTok', '*Facebook*', 'Instagram*',
    '*Twitter*', 'Duolingo-*', 'HULULLC.HULUPLUS', 'AmazonVideo.PrimeVideo', 'AdobeSystemsIncorporated.AdobeCreativeCloudExpress',
    'AD2F1837.HPSupportAssistant', 'AD2F1837.HPPrivacySettings', 'AD2F1837.HPJumpStarts', 'AD2F1837.HPQuickDrop', 'AD2F1837.HPEasyClean', 'AD2F1837.myHP',
    'DellInc.DellSupportAssistforPCs', 'DellInc.DellDigitalDelivery', 'DellInc.PartnerPromo'
)
$part = 1
[void][int]::TryParse([string]$env:PH_PART, [ref]$part)
if ($part -lt 0) { $part = 0 }
$per = [int][math]::Ceiling($names.Count / 4)
if ($part -eq 0) { $slice = @($names) } else { $slice = @($names | Select-Object -Skip (($part - 1) * $per) -First $per) }
JBegin 'APPS'
$ok = 0; $no = 0
foreach ($nm in $slice) {
    $pk = @(Get-AppxPackage -AllUsers -Name $nm)
    if ($pk.Count -eq 0) { continue }
    foreach ($p in $pk) {
        if (-not (JHas 'APPS' 'app' $p.Name $p.PackageFullName)) {
            [void]$script:JL['APPS'].Add([pscustomobject]@{ t = 'app'; k1 = $p.Name; k2 = $p.PackageFullName; existed = $true; kind = ''; value = '' })
        }
        Remove-AppxPackage -Package $p.PackageFullName -AllUsers -ErrorAction SilentlyContinue
        $still = @(Get-AppxPackage -AllUsers -Name $nm | Where-Object { $_.PackageFullName -eq $p.PackageFullName })
        if ($still.Count -gt 0) { Remove-AppxPackage -Package $p.PackageFullName -ErrorAction SilentlyContinue }
    }
    if (@(Get-AppxPackage -AllUsers -Name $nm).Count -eq 0) { $ok++; Log ('App removido: ' + $nm) }
    else { $no++; Log ('App NAO removido: ' + $nm) }
}
$od = '-'
if (($part -eq 4 -or $part -eq 0) -and $env:PH_BOOT -ne '1') {
    $od = 'NONE'
    $s1 = Join-Path $env:SystemRoot 'SysWOW64\OneDriveSetup.exe'
    $s2 = Join-Path $env:SystemRoot 'System32\OneDriveSetup.exe'
    $setup = ''
    if (Test-Path -LiteralPath $s1) { $setup = $s1 } elseif (Test-Path -LiteralPath $s2) { $setup = $s2 }
    $installed = (Test-Path -LiteralPath (Join-Path $env:LOCALAPPDATA 'Microsoft\OneDrive\OneDrive.exe')) -or (Test-Path -LiteralPath (Join-Path $env:ProgramFiles 'Microsoft OneDrive\OneDrive.exe')) -or (Test-Path -LiteralPath (Join-Path ${env:ProgramFiles(x86)} 'Microsoft OneDrive\OneDrive.exe'))
    if ($installed -and $setup) {
        if (OneDriveKFM) { $od = 'KEEP'; Log 'OneDrive mantido: Desktop ou Documentos sincronizados nele' }
        else {
            Stop-Process -Name OneDrive -Force -ErrorAction SilentlyContinue
            Start-Process -FilePath $setup -ArgumentList '/uninstall' -Wait
            $od = 'REM'
            [void]$script:JL['APPS'].Add([pscustomobject]@{ t = 'od'; k1 = $setup; k2 = ''; existed = $true; kind = ''; value = '' })
            Log 'OneDrive desinstalado'
        }
    }
}
JEnd 'APPS'
Write-Output ([string]$ok + '|' + [string]$no + '|' + $od)
#</OPT_APPS>

#<OPT_START>
JBegin 'START'
$n = 0; $sk = 0
$kfm = OneDriveKFM
$runKeys = @('HKCU:\Software\Microsoft\Windows\CurrentVersion\Run', 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run', 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run')
$pat = @('OneDrive*', 'MicrosoftEdgeAutoLaunch*', 'com.squirrel.Teams*', 'Teams*', 'MSTeams*', 'YourPhone*', 'PhoneExperience*', 'Skype*', 'GameBar*', 'Cortana*', 'Adobe*', 'AcroTray*', 'SunJavaUpdateSched', 'JavaUpdate*', 'iTunesHelper', 'QuickTime*', 'CCXProcess', 'HxTsr', 'Hx*Outlook*')
foreach ($rk in $runKeys) {
    $k = Get-Item -LiteralPath $rk -ErrorAction SilentlyContinue
    if (-not $k) { continue }
    foreach ($vn in @($k.GetValueNames())) {
        foreach ($p in $pat) {
            if ($vn -like $p) {
                if ($vn -like 'OneDrive*' -and $kfm) { $sk++ }
                else { RegDel 'START' $rk $vn; $n++ }
                break
            }
        }
    }
}
if ($env:PH_BOOT -ne '1') {
    $keep = @('SecurityHealth*', 'Windows Defender*', 'WindowsDefender*', 'Rtk*', 'Realtek*', 'RAV*', 'Synaptics*', 'SynTP*', 'ELAN*', 'Touchpad*', 'TouchPad*', 'Trackpad*', 'Intel*', 'IAStor*', 'Nv*', 'NVIDIA*', 'AMD*', 'Radeon*', 'Bluetooth*', 'Avast*', 'AVG*', 'Kaspersky*', 'Norton*', 'McAfee*', 'Bitdefender*', 'ESET*', 'Malwarebytes*', 'Avira*', 'Sophos*', 'Webroot*', '*Hotkey*', '*HotKey*', 'Fn*', 'OSD*', 'Logi*', 'LGHUB*', 'Razer*', 'SteelSeries*', 'Corsair*', 'iCUE*', 'Wacom*', '1Password*', 'Bitwarden*', 'LastPass*', 'KeePass*', 'NordVPN*', 'ProtonVPN*', 'Surfshark*', 'OpenVPN*', 'WireGuard*', 'Dropbox*', 'GoogleDrive*', 'Google Drive*', 'iCloud*', 'Backblaze*', 'OneDrive*', 'PrismaHub*')
    $dis = [byte[]](3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
    $ap = 'Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\'
    $map = @(
        @('HKCU:\Software\Microsoft\Windows\CurrentVersion\Run', ('HKCU:\' + $ap + 'Run')),
        @('HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run', ('HKLM:\' + $ap + 'Run')),
        @('HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run', ('HKLM:\' + $ap + 'Run32'))
    )
    foreach ($m in $map) {
        $k = Get-Item -LiteralPath $m[0] -ErrorAction SilentlyContinue
        if (-not $k) { continue }
        foreach ($vn in @($k.GetValueNames())) {
            if (-not $vn) { continue }
            $isKeep = $false
            foreach ($kp in $keep) { if ($vn -like $kp) { $isKeep = $true; break } }
            if ($isKeep) { $sk++; continue }
            if (RegSet 'START' $m[1] $vn $dis 'Binary') { $n++ } else { $sk++ }
        }
    }
    $folders = @(
        @((Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs\Startup'), ('HKCU:\' + $ap + 'StartupFolder')),
        @((Join-Path $env:ProgramData 'Microsoft\Windows\Start Menu\Programs\Startup'), ('HKLM:\' + $ap + 'StartupFolder'))
    )
    foreach ($f in $folders) {
        foreach ($it in @(Get-ChildItem -LiteralPath $f[0] -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -ne 'desktop.ini' })) {
            $isKeep = $false
            foreach ($kp in $keep) { if ($it.BaseName -like $kp) { $isKeep = $true; break } }
            if ($isKeep) { $sk++; continue }
            if (RegSet 'START' $f[1] $it.Name $dis 'Binary') { $n++ } else { $sk++ }
        }
    }
}
$A = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
$E = 'HKLM:\SOFTWARE\Policies\Microsoft\Edge'
$regs = @(
    @($E, 'BackgroundModeEnabled', 0, 'DWord'),
    @($E, 'StartupBoostEnabled', 0, 'DWord'),
    @($E, 'HubsSidebarEnabled', 0, 'DWord'),
    @($E, 'EdgeShoppingAssistantEnabled', 0, 'DWord'),
    @($E, 'ShowMicrosoftRewards', 0, 'DWord'),
    @($E, 'EdgeFollowEnabled', 0, 'DWord'),
    @($E, 'PersonalizationReportingEnabled', 0, 'DWord'),
    @($E, 'SpotlightExperiencesAndRecommendationsEnabled', 0, 'DWord'),
    @($E, 'NewTabPageContentEnabled', 0, 'DWord'),
    @($E, 'MicrosoftEdgeInsiderPromotionEnabled', 0, 'DWord'),
    @($E, 'DiagnosticData', 0, 'DWord'),
    @($E, 'SleepingTabsEnabled', 1, 'DWord'),
    @($E, 'SleepingTabsTimeout', 300, 'DWord'),
    @('HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main', 'AllowPrelaunch', 0, 'DWord'),
    @('HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\TabPreloader', 'AllowTabPreloading', 0, 'DWord'),
    @('HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications', 'GlobalUserDisabled', 1, 'DWord'),
    @('HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy', 'LetAppsRunInBackground', 2, 'DWord'),
    @('HKLM:\SOFTWARE\Policies\Microsoft\Dsh', 'AllowNewsAndInterests', 0, 'DWord'),
    @('HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds', 'EnableFeeds', 0, 'DWord'),
    @('HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Chat', 'ChatIcon', 3, 'DWord'),
    @($A, 'TaskbarDa', 0, 'DWord'),
    @($A, 'TaskbarMn', 0, 'DWord'),
    @('HKCU:\Software\Policies\Microsoft\Windows\WindowsCopilot', 'TurnOffWindowsCopilot', 1, 'DWord'),
    @('HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot', 'TurnOffWindowsCopilot', 1, 'DWord'),
    @('HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power', 'HiberbootEnabled', 0, 'DWord'),
    @('HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize', 'StartupDelayInMSec', 0, 'DWord')
)
$chrome = (Test-Path -LiteralPath (Join-Path $env:ProgramFiles 'Google\Chrome\Application\chrome.exe')) -or (Test-Path -LiteralPath (Join-Path ${env:ProgramFiles(x86)} 'Google\Chrome\Application\chrome.exe'))
if ($chrome) {
    $regs += , @('HKLM:\SOFTWARE\Policies\Google\Chrome', 'BackgroundModeEnabled', 0, 'DWord')
    $regs += , @('HKLM:\SOFTWARE\Policies\Google\Chrome', 'HighEfficiencyModeEnabled', 1, 'DWord')
}
foreach ($r in $regs) { if (RegSet 'START' $r[0] $r[1] $r[2] $r[3]) { $n++ } else { $sk++ } }
JEnd 'START'
Write-Output ([string]$n + '|' + [string]$sk + '|-')
#</OPT_START>

#<OPT_SVC>
JBegin 'SVC'
$n = 0; $sk = 0
$svc = [ordered]@{}
foreach ($x in 'DiagTrack', 'dmwappushservice', 'MapsBroker', 'RetailDemo', 'Fax', 'WMPNetworkSvc', 'RemoteRegistry', 'PhoneSvc', 'diagnosticshub.standardcollector.service',
    'WerSvc', 'PcaSvc', 'TrkWks', 'lfsvc', 'WpcMonSvc', 'SEMgrSvc', 'icssvc', 'wisvc', 'WalletService', 'AJRouter', 'SmsRouter',
    'CDPSvc', 'CDPUserSvc', 'OneSyncSvc', 'UnistoreSvc', 'UserDataSvc', 'PimIndexMaintenanceSvc', 'MessagingService', 'cbdhsvc', 'WSearch',
    'MixedRealityOpenXRSvc', 'perceptionsimulation', 'spectrum', 'SharedRealitySvc', 'VacSvc', 'WFDSConMgrSvc', 'CscService',
    'upnphost', 'lltdsvc', 'p2pimsvc', 'p2psvc', 'PNRPsvc', 'PNRPAutoReg', 'NetTcpPortSharing',
    'DPS', 'WdiServiceHost', 'WdiSystemHost', 'InventorySvc', 'GraphicsPerfSvc', 'BcastDVRUserService', 'PrintWorkflowUserSvc', 'AppVClient', 'UevAgentService', 'ssh-agent', 'RasAuto', 'Wecsvc', 'workfolderssvc',
    'Ndu', 'lmhosts', 'NvTelemetryContainer',
    'HPTouchpointAnalyticsService', 'HPSysInfoCap', 'HPDiagsCap', 'HPNetworkCap', 'HPAppHelperCap', 'SupportAssistAgent', 'DDVDataCollector', 'DDVCollectorSvcApi', 'DDVRulesProcessor') { $svc[$x] = 4 }
foreach ($x in 'AppReadiness', 'DoSvc', 'edgeupdate', 'edgeupdatem', 'MicrosoftEdgeElevationService', 'gupdate', 'gupdatem', 'GoogleChromeElevationService', 'AdobeARMservice') { $svc[$x] = 3 }
$btPresent = $true
try {
    $bd = @(Get-PnpDevice -Class Bluetooth -PresentOnly -ErrorAction Stop | Where-Object { $_.InstanceId -match '^(USB|PCI|ACPI)' })
    $btPresent = ($bd.Count -gt 0)
}
catch { $btPresent = $true }
if (-not $btPresent) { foreach ($x in 'bthserv', 'BthAvctpSvc', 'BTAGService', 'BluetoothUserService') { $svc[$x] = 4 } }
$ssd = $false
$dl = $env:SystemDrive.Substring(0, 1)
$dn = (Get-Partition -DriveLetter $dl -ErrorAction SilentlyContinue).DiskNumber
if ($dn -ne $null) {
    $pdk = Get-PhysicalDisk -ErrorAction SilentlyContinue | Where-Object { $_.DeviceId -eq [string]$dn } | Select-Object -First 1
    if ($pdk -and [string]$pdk.MediaType -eq 'SSD') { $ssd = $true }
}
if ($ssd) { $svc['SysMain'] = 4 }
if ($ssd) {
    foreach ($pfv in 'EnablePrefetcher', 'EnableSuperfetch') {
        if (RegSet 'SVC' 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters' $pfv 0 'DWord') { $n++ } else { $sk++ }
    }
}
$shareOk = $false; $shares = @()
try { $shares = @(Get-SmbShare -ErrorAction Stop | Where-Object { -not $_.Special }); $shareOk = $true } catch { $shareOk = $false }
if ($shareOk -and $shares.Count -eq 0) { $svc['LanmanServer'] = 4 }
foreach ($name in @($svc.Keys)) {
    $p = 'HKLM:\SYSTEM\CurrentControlSet\Services\' + $name
    if (-not (Test-Path -LiteralPath $p)) { $sk++; continue }
    if (RegSet 'SVC' $p 'Start' $svc[$name] 'DWord') {
        $n++
        if ($svc[$name] -eq 4) { Stop-Service -Name $name -Force -ErrorAction SilentlyContinue }
    }
    else { $sk++ }
}
$ramKB = [int]((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1KB)
if ($ramKB -gt 0) {
    if (RegSet 'SVC' 'HKLM:\SYSTEM\CurrentControlSet\Control' 'SvcHostSplitThresholdInKB' ($ramKB + 1048576) 'DWord') { $n++ } else { $sk++ }
}
$mma = Get-MMAgent -ErrorAction SilentlyContinue
if ($mma -and $mma.ApplicationPreLaunch) {
    if (-not (JHas 'SVC' 'mmagent' 'ApplicationPreLaunch' '')) {
        [void]$script:JL['SVC'].Add([pscustomobject]@{ t = 'mmagent'; k1 = 'ApplicationPreLaunch'; k2 = ''; existed = $true; kind = ''; value = '' })
    }
    Disable-MMAgent -ApplicationPreLaunch -ErrorAction SilentlyContinue
    $n++
}
$tasks = @(
    @('\Microsoft\Windows\Application Experience\', 'Microsoft Compatibility Appraiser'),
    @('\Microsoft\Windows\Application Experience\', 'ProgramDataUpdater'),
    @('\Microsoft\Windows\Application Experience\', 'StartupAppTask'),
    @('\Microsoft\Windows\Application Experience\', 'MareBackup'),
    @('\Microsoft\Windows\Application Experience\', 'PcaPatchDbTask'),
    @('\Microsoft\Windows\Application Experience\', 'SdbinstMergeDbTask'),
    @('\Microsoft\Windows\Customer Experience Improvement Program\', 'Consolidator'),
    @('\Microsoft\Windows\Customer Experience Improvement Program\', 'UsbCeip'),
    @('\Microsoft\Windows\Customer Experience Improvement Program\', 'KernelCeipTask'),
    @('\Microsoft\Windows\Feedback\Siuf\', 'DmClient'),
    @('\Microsoft\Windows\Feedback\Siuf\', 'DmClientOnScenarioDownload'),
    @('\Microsoft\Windows\Windows Error Reporting\', 'QueueReporting'),
    @('\Microsoft\Windows\DiskDiagnostic\', 'Microsoft-Windows-DiskDiagnosticDataCollector'),
    @('\Microsoft\Windows\Autochk\', 'Proxy'),
    @('\Microsoft\Windows\Maps\', 'MapsToastTask'),
    @('\Microsoft\Windows\Maps\', 'MapsUpdateTask'),
    @('\Microsoft\XblGameSave\', 'XblGameSaveTask'),
    @('\Microsoft\Windows\NetTrace\', 'GatherNetworkInfo'),
    @('\Microsoft\Windows\Power Efficiency Diagnostics\', 'AnalyzeSystem'),
    @('\Microsoft\Windows\Shell\', 'FamilySafetyMonitor'),
    @('\Microsoft\Windows\Shell\', 'FamilySafetyRefreshTask'),
    @('\Microsoft\Windows\PI\', 'Sqm-Tasks'),
    @('\Microsoft\Windows\SettingSync\', 'BackgroundUploadTask'),
    @('\Microsoft\Windows\SettingSync\', 'NetworkStateChangeTask'),
    @('\Microsoft\Windows\Mobile Broadband Accounts\', 'MNO Metadata Parser')
)
foreach ($t in $tasks) {
    $tk = Get-ScheduledTask -TaskPath $t[0] -TaskName $t[1] -ErrorAction SilentlyContinue
    if (-not $tk) { $sk++; continue }
    if ($tk.State -eq 'Disabled') { $sk++; continue }
    if (-not (JHas 'SVC' 'task' $t[0] $t[1])) {
        [void]$script:JL['SVC'].Add([pscustomobject]@{ t = 'task'; k1 = $t[0]; k2 = $t[1]; existed = $true; kind = ''; value = '' })
    }
    Disable-ScheduledTask -TaskPath $t[0] -TaskName $t[1] -ErrorAction SilentlyContinue | Out-Null
    $n++
}
foreach ($nt in @(Get-ScheduledTask -ErrorAction SilentlyContinue | Where-Object { $_.TaskName -like 'NvTm*' })) {
    if ($nt.State -eq 'Disabled') { continue }
    if (-not (JHas 'SVC' 'task' $nt.TaskPath $nt.TaskName)) {
        [void]$script:JL['SVC'].Add([pscustomobject]@{ t = 'task'; k1 = $nt.TaskPath; k2 = $nt.TaskName; existed = $true; kind = ''; value = '' })
    }
    Disable-ScheduledTask -TaskPath $nt.TaskPath -TaskName $nt.TaskName -ErrorAction SilentlyContinue | Out-Null
    $n++
}
JEnd 'SVC'
Write-Output ([string]$n + '|' + [string]$sk + '|-')
#</OPT_SVC>

#<OPT_PRIV>
JBegin 'PRIV'
$n = 0; $sk = 0
$cdm = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager'
$adv = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
$pol = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows'
$regs = @()
foreach ($v in 'ContentDeliveryAllowed', 'OemPreInstalledAppsEnabled', 'PreInstalledAppsEnabled', 'PreInstalledAppsEverEnabled', 'SilentInstalledAppsEnabled', 'SubscribedContent-310093Enabled', 'SubscribedContent-338387Enabled', 'SubscribedContent-338388Enabled', 'SubscribedContent-338389Enabled', 'SubscribedContent-338393Enabled', 'SubscribedContent-353694Enabled', 'SubscribedContent-353696Enabled', 'SubscribedContent-353698Enabled', 'SystemPaneSuggestionsEnabled', 'SoftLandingEnabled', 'RotatingLockScreenEnabled', 'RotatingLockScreenOverlayEnabled') {
    $regs += , @($cdm, $v, 0, 'DWord')
}
$regs += , @('HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo', 'Enabled', 0, 'DWord')
$regs += , @('HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy', 'TailoredExperiencesWithDiagnosticDataEnabled', 0, 'DWord')
$regs += , @($adv, 'Start_TrackProgs', 0, 'DWord')
$regs += , @($adv, 'Start_IrisRecommendations', 0, 'DWord')
$regs += , @($adv, 'ShowSyncProviderNotifications', 0, 'DWord')
$regs += , @('HKCU:\Software\Microsoft\Windows\CurrentVersion\Search', 'BingSearchEnabled', 0, 'DWord')
$regs += , @('HKCU:\Software\Microsoft\Windows\CurrentVersion\Search', 'CortanaConsent', 0, 'DWord')
$regs += , @('HKCU:\Software\Microsoft\Siuf\Rules', 'NumberOfSIUFInPeriod', 0, 'DWord')
$regs += , @('HKCU:\Software\Microsoft\Input\TIPC', 'Enabled', 0, 'DWord')
$regs += , @($pol + '\DataCollection', 'AllowTelemetry', 0, 'DWord')
$regs += , @($pol + '\DataCollection', 'DoNotShowFeedbackNotifications', 1, 'DWord')
$regs += , @($pol + '\System', 'EnableActivityFeed', 0, 'DWord')
$regs += , @($pol + '\System', 'PublishUserActivities', 0, 'DWord')
$regs += , @($pol + '\System', 'UploadUserActivities', 0, 'DWord')
$regs += , @($pol + '\Windows Search', 'AllowCortana', 0, 'DWord')
$regs += , @($pol + '\Windows Search', 'DisableWebSearch', 1, 'DWord')
$regs += , @($pol + '\Windows Search', 'ConnectedSearchUseWeb', 0, 'DWord')
$regs += , @($pol + '\Windows Search', 'AllowCloudSearch', 0, 'DWord')
$regs += , @($pol + '\CloudContent', 'DisableWindowsConsumerFeatures', 1, 'DWord')
$regs += , @($pol + '\CloudContent', 'DisableTailoredExperiencesWithDiagnosticData', 1, 'DWord')
$regs += , @($pol + '\AdvertisingInfo', 'DisabledByGroupPolicy', 1, 'DWord')
$regs += , @('HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting', 'Disabled', 1, 'DWord')
$regs += , @($pol + '\System', 'AllowClipboardHistory', 0, 'DWord')
$regs += , @($pol + '\System', 'AllowCrossDeviceClipboard', 0, 'DWord')
$regs += , @($pol + '\LocationAndSensors', 'DisableLocation', 1, 'DWord')
$regs += , @($pol + '\Windows Search', 'AllowCortanaAboveLock', 0, 'DWord')
$regs += , @($pol + '\Windows Search', 'AllowSearchToUseLocation', 0, 'DWord')
$regs += , @($pol + '\DataCollection', 'DisableOneSettingsDownloads', 1, 'DWord')
$regs += , @($pol + '\AppCompat', 'AITEnable', 0, 'DWord')
$regs += , @($pol + '\AppCompat', 'DisableInventory', 1, 'DWord')
$regs += , @($pol + '\AppCompat', 'DisableUAR', 1, 'DWord')
$regs += , @($pol + '\PreviewBuilds', 'AllowBuildPreview', 0, 'DWord')
$regs += , @($pol + '\TabletPC', 'PreventHandwritingDataSharing', 1, 'DWord')
$regs += , @($pol + '\HandwritingErrorReports', 'PreventHandwritingErrorReports', 1, 'DWord')
$regs += , @('HKLM:\SOFTWARE\Policies\Microsoft\WindowsInkWorkspace', 'AllowWindowsInkWorkspace', 0, 'DWord')
$regs += , @('HKLM:\SOFTWARE\Policies\Microsoft\SQMClient\Windows', 'CEIPEnable', 0, 'DWord')
$regs += , @('HKCU:\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement', 'ScoobeSystemSettingEnabled', 0, 'DWord')
$regs += , @('HKCU:\Software\Microsoft\Windows\CurrentVersion\SearchSettings', 'IsDynamicSearchBoxEnabled', 0, 'DWord')
$regs += , @('HKCU:\Software\Microsoft\Windows\CurrentVersion\SearchSettings', 'IsAADCloudSearchEnabled', 0, 'DWord')
$regs += , @('HKCU:\Software\Microsoft\Windows\CurrentVersion\SearchSettings', 'IsMSACloudSearchEnabled', 0, 'DWord')
$regs += , @('HKCU:\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy', 'HasAccepted', 0, 'DWord')
$regs += , @('HKCU:\Control Panel\International\User Profile', 'HttpAcceptLanguageOptOut', 1, 'DWord')
$regs += , @('HKCU:\Software\Policies\Microsoft\Windows\CloudContent', 'DisableSpotlightCollectionOnDesktop', 1, 'DWord')
$regs += , @($adv, 'Start_TrackDocs', 0, 'DWord')
$regs += , @($adv, 'Start_AccountNotifications', 0, 'DWord')
foreach ($r in $regs) { if (RegSet 'PRIV' $r[0] $r[1] $r[2] $r[3]) { $n++ } else { $sk++ } }
JEnd 'PRIV'
Write-Output ([string]$n + '|' + [string]$sk + '|-')
#</OPT_PRIV>

#<OPT_VISUAL>
JBegin 'VISUAL'
$n = 0; $sk = 0
$adv = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
$mask = [byte[]](0x90, 0x12, 0x03, 0x80, 0x10, 0x00, 0x00, 0x00)
$regs = @(
    @('HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects', 'VisualFXSetting', 2, 'DWord'),
    @('HKCU:\Control Panel\Desktop', 'UserPreferencesMask', $mask, 'Binary'),
    @('HKCU:\Control Panel\Desktop', 'MenuShowDelay', '0', 'String'),
    @('HKCU:\Control Panel\Desktop\WindowMetrics', 'MinAnimate', '0', 'String'),
    @($adv, 'TaskbarAnimations', 0, 'DWord'),
    @($adv, 'ListviewShadow', 0, 'DWord'),
    @($adv, 'ListviewAlphaSelect', 0, 'DWord'),
    @('HKCU:\Software\Microsoft\Windows\DWM', 'EnableAeroPeek', 0, 'DWord'),
    @('HKCU:\Software\Microsoft\Windows\DWM', 'AlwaysHibernateThumbnails', 0, 'DWord'),
    @('HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize', 'EnableTransparency', 0, 'DWord'),
    @($adv, 'ShowTaskViewButton', 0, 'DWord'),
    @($adv, 'ShowCopilotButton', 0, 'DWord'),
    @($adv, 'ShowCortanaButton', 0, 'DWord')
)
foreach ($r in $regs) { if (RegSet 'VISUAL' $r[0] $r[1] $r[2] $r[3]) { $n++ } else { $sk++ } }
JEnd 'VISUAL'
Write-Output ([string]$n + '|' + [string]$sk + '|-')
#</OPT_VISUAL>

#<OPT_POWER>
JBegin 'POWER'
$guidRx = '[0-9a-fA-F]{8}(-[0-9a-fA-F]{4}){3}-[0-9a-fA-F]{12}'
$cur = ''
$o = (powercfg /getactivescheme | Out-String)
if ($o -match $guidRx) { $cur = $Matches[0] }
$new = ''
$prev = @($script:JL['POWER'] | Where-Object { $_.t -eq 'power' }) | Select-Object -First 1
if ($prev -and ((powercfg /list | Out-String) -match [regex]::Escape([string]$prev.k2))) { $new = [string]$prev.k2 }
if (-not $new) {
    $o = (powercfg -duplicatescheme 'e9a42b02-d5df-448d-aa00-03f14749eb61' | Out-String)
    if ($o -notmatch $guidRx) { $o = (powercfg -duplicatescheme '8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c' | Out-String) }
    if ($o -match $guidRx) {
        $new = $Matches[0]
        powercfg -changename $new 'PRISMA HUB - Desempenho' 'Plano criado pelo PRISMA HUB CMD' | Out-Null
        [void]$script:JL['POWER'].Add([pscustomobject]@{ t = 'power'; k1 = $cur; k2 = $new; existed = $true; kind = ''; value = '' })
    }
}
$n = 0; $sk = 0
if ($new) {
    $lap = @(Get-CimInstance Win32_Battery).Count -gt 0
    $set = @(
        @('SUB_PROCESSOR', 'PROCTHROTTLEMIN', 100), @('SUB_PROCESSOR', 'PROCTHROTTLEMAX', 100),
        @('SUB_PROCESSOR', 'PERFBOOSTMODE', 2), @('SUB_PROCESSOR', 'PERFEPP', 0), @('SUB_PROCESSOR', 'CPMAXCORES', 100), @('SUB_PROCESSOR', 'SYSCOOLPOL', 1), @('SUB_PROCESSOR', 'CPMINCORES', 100),
        @('SUB_DISK', 'DISKIDLE', 0), @('SUB_PCIEXPRESS', 'ASPM', 0),
        @('2a737441-1930-4402-8d77-b2bebba308a3', '48e6b7a6-50f5-4782-a5d4-53bb8f07e226', 0),
        @('19cbb8fa-5279-450e-9fac-8a3d5fedd0c1', '12bbebe6-58d6-4636-95bb-3217ef867c1a', 0)
    )
    foreach ($s in $set) {
        powercfg /setacvalueindex $new $s[0] $s[1] $s[2] | Out-Null
        if ($LASTEXITCODE -eq 0) { $n++ } else { $sk++ }
    }
    if ($lap) { powercfg /setdcvalueindex $new SUB_PROCESSOR PROCTHROTTLEMIN 5 | Out-Null }
    powercfg /setactive $new | Out-Null
    if ($LASTEXITCODE -eq 0) { $n++ } else { $sk++ }
}
else { $sk++ }
if (RegSet 'POWER' 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling' 'PowerThrottlingOff' 1 'DWord') { $n++ } else { $sk++ }
$mp = Get-MpPreference -ErrorAction SilentlyContinue
if ($mp) {
    if (-not (JHas 'POWER' 'mppref' 'cpu' '')) {
        [void]$script:JL['POWER'].Add([pscustomobject]@{ t = 'mppref'; k1 = 'cpu'; k2 = ''; existed = $true; kind = ''; value = ([string]$mp.ScanAvgCPULoadFactor + '|' + [string]$mp.EnableLowCpuPriority) })
    }
    Set-MpPreference -ScanAvgCPULoadFactor 20 -EnableLowCpuPriority $true -ErrorAction SilentlyContinue
    if ((Get-MpPreference -ErrorAction SilentlyContinue).ScanAvgCPULoadFactor -eq 20) { $n++ } else { $sk++ }
}
JEnd 'POWER'
Write-Output ([string]$n + '|' + [string]$sk + '|-')
#</OPT_POWER>

#<OPT_GAME>
JBegin 'GAME'
$n = 0; $sk = 0
$mm = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile'
$regs = @(
    @('HKCU:\Software\Microsoft\GameBar', 'AutoGameModeEnabled', 1, 'DWord'),
    @('HKCU:\Software\Microsoft\GameBar', 'AllowAutoGameMode', 1, 'DWord'),
    @('HKCU:\Software\Microsoft\GameBar', 'UseNexusForGameBarEnabled', 0, 'DWord'),
    @('HKCU:\Software\Microsoft\GameBar', 'ShowStartupPanel', 0, 'DWord'),
    @('HKCU:\System\GameConfigStore', 'GameDVR_Enabled', 0, 'DWord'),
    @('HKCU:\System\GameConfigStore', 'GameDVR_FSEBehaviorMode', 2, 'DWord'),
    @('HKCU:\System\GameConfigStore', 'GameDVR_HonorUserFSEBehaviorMode', 1, 'DWord'),
    @('HKCU:\System\GameConfigStore', 'GameDVR_DXGIHonorFSEWindowsCompatible', 1, 'DWord'),
    @('HKCU:\System\GameConfigStore', 'GameDVR_EFSEFeatureFlags', 0, 'DWord'),
    @('HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR', 'AppCaptureEnabled', 0, 'DWord'),
    @('HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR', 'HistoricalCaptureEnabled', 0, 'DWord'),
    @('HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR', 'AllowGameDVR', 0, 'DWord'),
    @($mm, 'NetworkThrottlingIndex', ([int]-1), 'DWord'),
    @($mm, 'SystemResponsiveness', 10, 'DWord'),
    @(($mm + '\Tasks\Games'), 'GPU Priority', 8, 'DWord'),
    @(($mm + '\Tasks\Games'), 'Priority', 6, 'DWord'),
    @(($mm + '\Tasks\Games'), 'Scheduling Category', 'High', 'String'),
    @(($mm + '\Tasks\Games'), 'SFIO Priority', 'High', 'String'),
    @('HKCU:\Software\Microsoft\DirectX\UserGpuPreferences', 'DirectXUserGlobalSettings', 'SwapEffectUpgradeEnable=1;', 'String')
)
$regs += , @('HKCU:\Control Panel\Mouse', 'MouseSpeed', '0', 'String')
$regs += , @('HKCU:\Control Panel\Mouse', 'MouseThreshold1', '0', 'String')
$regs += , @('HKCU:\Control Panel\Mouse', 'MouseThreshold2', '0', 'String')
$regs += , @('HKCU:\Control Panel\Accessibility\StickyKeys', 'Flags', '506', 'String')
$regs += , @('HKCU:\Control Panel\Accessibility\Keyboard Response', 'Flags', '122', 'String')
$regs += , @('HKCU:\Control Panel\Accessibility\ToggleKeys', 'Flags', '58', 'String')
$vc = @(Get-CimInstance Win32_VideoController | Where-Object { $_.Name -notmatch 'Basic|Remote|Virtual|Parsec|Meta' })
if ($vc | Where-Object { $_.Name -match 'Intel' }) {
    $ramGB = [int]((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
    $seg = 1024
    if ($ramGB -le 8) { $seg = 512 }
    if ($ramGB -le 4) { $seg = 256 }
    $regs += , @('HKLM:\SOFTWARE\Intel\GMM', 'DedicatedSegmentSize', $seg, 'DWord')
}
foreach ($r in $regs) { if (RegSet 'GAME' $r[0] $r[1] $r[2] $r[3]) { $n++ } else { $sk++ } }
$gn = (@(Get-CimInstance Win32_VideoController) | ForEach-Object { $_.Name }) -join ' '
if ($gn -match 'NVIDIA|Radeon|AMD' -and [Environment]::OSVersion.Version.Build -ge 19041) {
    if (RegSet 'GAME' 'HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers' 'HwSchMode' 2 'DWord') { $n++ } else { $sk++ }
}
$info = '-'
$hybrid = ($vc.Count -ge 2) -and [bool]($vc | Where-Object { $_.Name -match 'NVIDIA|GeForce|Radeon RX|Radeon Pro|Arc' })
if ($hybrid) {
    $gp = 'HKCU:\Software\Microsoft\DirectX\UserGpuPreferences'
    $gc = 0
    foreach ($gx in @(FindGames)) { if (RegSet 'GAME' $gp $gx 'GpuPreference=2;' 'String') { $gc++ } }
    $n += $gc
    if ($gc -gt 0) { $info = 'GPU dedicada em ' + $gc + ' jogos' }
}
JEnd 'GAME'
Write-Output ([string]$n + '|' + [string]$sk + '|' + $info)
#</OPT_GAME>

#<OPT_NET>
JBegin 'NET'
$n = 0; $sk = 0
$base = 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces'
foreach ($k in @(Get-ChildItem -LiteralPath $base -ErrorAction SilentlyContinue)) {
    $pr = Get-ItemProperty -LiteralPath $k.PSPath -ErrorAction SilentlyContinue
    $ip = @($pr.DhcpIPAddress) + @($pr.IPAddress) | Where-Object { $_ -and $_ -ne '0.0.0.0' }
    if (-not $ip) { continue }
    $a = RegSet 'NET' $k.PSPath 'TcpAckFrequency' 1 'DWord'
    $b = RegSet 'NET' $k.PSPath 'TCPNoDelay' 1 'DWord'
    if ($a -and $b) { $n++ } else { $sk++ }
}
foreach ($k in @(Get-ChildItem -LiteralPath $base -ErrorAction SilentlyContinue)) {
    $nb = 'HKLM:\SYSTEM\CurrentControlSet\Services\NetBT\Parameters\Interfaces\Tcpip_' + $k.PSChildName
    if (Test-Path -LiteralPath $nb) { if (RegSet 'NET' $nb 'NetbiosOptions' 2 'DWord') { $n++ } else { $sk++ } }
}
if (RegSet 'NET' 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient' 'EnableMulticast' 0 'DWord') { $n++ } else { $sk++ }
if (RegSet 'NET' 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization' 'DODownloadMode' 0 'DWord') { $n++ } else { $sk++ }
foreach ($na in @(Get-NetAdapter -Physical -ErrorAction SilentlyContinue)) {
    $pm = Get-NetAdapterPowerManagement -Name $na.Name -ErrorAction SilentlyContinue
    if ($pm -and [string]$pm.AllowComputerToTurnOffDevice -eq 'Enabled') {
        if (-not (JHas 'NET' 'netpm' $na.Name '')) {
            [void]$script:JL['NET'].Add([pscustomobject]@{ t = 'netpm'; k1 = $na.Name; k2 = ''; existed = $true; kind = ''; value = '' })
        }
        Set-NetAdapterPowerManagement -Name $na.Name -AllowComputerToTurnOffDevice Disabled -ErrorAction SilentlyContinue
        $n++
    }
}
$cls = 'HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}'
foreach ($ck in @(Get-ChildItem -LiteralPath $cls -ErrorAction SilentlyContinue)) {
    if ($ck.PSChildName -notmatch '^\d{4}$') { continue }
    $pr = Get-ItemProperty -LiteralPath $ck.PSPath -ErrorAction SilentlyContinue
    foreach ($nm in '*EEE', 'EEELinkAdvertisement', 'GreenEthernet', 'EnableGreenEthernet', 'PowerSavingMode', 'ULPMode', 'AdvancedEEE', 'EEEPlus') {
        if ($pr.PSObject.Properties[$nm] -and [string]$pr.$nm -ne '0') {
            if (RegSet 'NET' $ck.PSPath $nm '0' 'String') { $n++ } else { $sk++ }
        }
    }
}
ipconfig /flushdns | Out-Null
JEnd 'NET'
Write-Output ([string]$n + '|' + [string]$sk + '|-')
#</OPT_NET>

#<OPT_KILL>
$names = @('Widgets', 'WidgetService', 'WidgetBoard', 'PhoneExperienceHost', 'YourPhone', 'GameBar', 'GameBarFTServer', 'GameBarPresenceWriter', 'Cortana', 'Teams', 'ms-teams', 'XboxPcApp', 'XboxPcAppFT', 'CompatTelRunner', 'Copilot', 'SkypeApp', 'SkypeBackgroundHost', 'HxOutlook', 'HxTsr', 'GoogleUpdate', 'MicrosoftEdgeUpdate', 'OneDriveStandaloneUpdater', 'AdobeIPCBroker', 'CCXProcess', 'AdobeUpdateService', 'armsvc', 'jusched', 'SearchIndexer', 'wsqmcons', 'DeviceCensus', 'backgroundTaskHost', 'WerFault')
if ($env:PH_BOOT -ne '1' -and -not (OneDriveKFM)) { $names += 'OneDrive' }
$k = 0
foreach ($nm in $names) {
    $pr = @(Get-Process -Name $nm -ErrorAction SilentlyContinue)
    foreach ($p in $pr) { Stop-Process -Id $p.Id -Force -ErrorAction SilentlyContinue; $k++ }
}
foreach ($bn in 'msedge', 'chrome') {
    $bp = @(Get-Process -Name $bn -ErrorAction SilentlyContinue)
    if ($bp.Count -gt 0 -and -not ($bp | Where-Object { $_.MainWindowHandle -ne 0 })) {
        foreach ($p in $bp) { Stop-Process -Id $p.Id -Force -ErrorAction SilentlyContinue; $k++ }
    }
}
try {
    Add-Type -Namespace PH -Name Ws -MemberDefinition '[System.Runtime.InteropServices.DllImport("psapi.dll")] public static extern bool EmptyWorkingSet(System.IntPtr h);'
    foreach ($pr in @(Get-Process)) {
        try { [void][PH.Ws]::EmptyWorkingSet($pr.Handle) } catch { }
    }
}
catch { }
Write-Output ([string]$k + '|0|-')
#</OPT_KILL>

#<CLEAN_SCAN>
$ids = 'TEMPU', 'TEMPW', 'INET', 'THUMB', 'WU', 'DO', 'WER', 'EDGE', 'CHROME', 'FIREFOX'
$totB = [int64]0; $totC = 0
foreach ($id in $ids) {
    $spec = CleanSpec $id
    $b = [int64]0; $c = 0
    foreach ($f in @(CleanFiles $spec)) { $b += [int64]$f.Length; $c++ }
    $totB += $b; $totC += $c
    Write-Output ($id + '|' + $b + '|' + $c + '|' + (FmtSize $b))
}
$bi = BinInfo
$totB += [int64]$bi[1]; $totC += [int]$bi[0]
Write-Output ('BIN|' + $bi[1] + '|' + $bi[0] + '|' + (FmtSize ([int64]$bi[1])))
Write-Output ('TOTAL|' + $totB + '|' + $totC + '|' + (FmtSize $totB))
#</CLEAN_SCAN>

#<CLEAN_RUN>
$cat = [string]$env:PH_CAT
$rm = 0; $fl = 0; $bytes = [int64]0
$failLog = Join-Path $LG 'limpeza_falhas.txt'
if ($cat -eq 'BIN') {
    $before = BinInfo
    Clear-RecycleBin -Force -ErrorAction SilentlyContinue
    $after = BinInfo
    $rm = [int]($before[0] - $after[0]); $fl = [int]$after[0]; $bytes = [int64]($before[1] - $after[1])
}
else {
    $spec = CleanSpec $cat
    $wasRunning = $false
    if ($cat -eq 'WU') {
        $sv = Get-Service -Name wuauserv -ErrorAction SilentlyContinue
        if ($sv -and $sv.Status -eq 'Running') { $wasRunning = $true }
        Stop-Service -Name wuauserv -Force -ErrorAction SilentlyContinue
    }
    foreach ($f in @(CleanFiles $spec)) {
        $len = [int64]$f.Length
        Remove-Item -LiteralPath $f.FullName -Force -ErrorAction SilentlyContinue
        if (Test-Path -LiteralPath $f.FullName) { $fl++; Add-Content -Path $failLog -Value ($cat + ' ' + $f.FullName) }
        else { $rm++; $bytes += $len }
    }
    if ($spec.filter -eq '*') {
        foreach ($d in $spec.dirs) {
            $subs = @(Get-ChildItem -LiteralPath $d -Recurse -Directory -Force -ErrorAction SilentlyContinue | Sort-Object { $_.FullName.Length } -Descending)
            foreach ($s in $subs) {
                if (-not (Get-ChildItem -LiteralPath $s.FullName -Force -ErrorAction SilentlyContinue)) { Remove-Item -LiteralPath $s.FullName -Force -ErrorAction SilentlyContinue }
            }
        }
    }
    if ($cat -eq 'WU' -and $wasRunning) { Start-Service -Name wuauserv -ErrorAction SilentlyContinue }
}
if ($bytes -lt 0) { $bytes = [int64]0 }
Write-Output ($cat + '|' + $rm + '|' + $fl + '|' + [int64]($bytes / 1KB) + '|' + (FmtSize $bytes))
#</CLEAN_RUN>

#<BOOTON>
$bat = Join-Path $PH 'PrismaHub.bat'
if (-not (Test-Path -LiteralPath $bat)) { exit 1 }
$tn = 'PrismaHub-Reaplicar'
$usr = $env:USERDOMAIN + '\' + $env:USERNAME
$arg = 'cmd.exe /c call "' + $bat + '" --boot'
$act = New-ScheduledTaskAction -Execute 'conhost.exe' -Argument $arg
$trg = New-ScheduledTaskTrigger -AtLogOn -User $usr
$trg.Delay = 'PT10S'
$pri = New-ScheduledTaskPrincipal -UserId $usr -LogonType Interactive -RunLevel Highest
$stg = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -ExecutionTimeLimit (New-TimeSpan -Minutes 30)
Unregister-ScheduledTask -TaskName $tn -Confirm:$false -ErrorAction SilentlyContinue
Register-ScheduledTask -TaskName $tn -Action $act -Trigger $trg -Principal $pri -Settings $stg -Description 'PRISMA HUB CMD: reaplica as otimizacoes ao entrar no Windows' | Out-Null
if (Get-ScheduledTask -TaskName $tn -ErrorAction SilentlyContinue) {
    JBegin 'BOOT'
    if (-not (JHas 'BOOT' 'boottask' $tn $bat)) {
        [void]$script:JL['BOOT'].Add([pscustomobject]@{ t = 'boottask'; k1 = $tn; k2 = $bat; existed = $true; kind = ''; value = '' })
    }
    JEnd 'BOOT'
    Log 'Tarefa PrismaHub-Reaplicar criada (login do usuario)'
    Write-Output 'OK'
    exit 0
}
exit 1
#</BOOTON>

#<UNDO>
$item = [string]$env:PH_ITEM
$jf = JFile $item
$ok = 0; $fail = 0; $manual = 0
$entries = @()
if (Test-Path -LiteralPath $jf) {
    $raw = Get-Content -LiteralPath $jf -Raw
    if ($raw) { $entries = @(ConvertFrom-Json $raw) }
}
[array]::Reverse($entries)
$seen = @{}
foreach ($e in $entries) {
    if ($e.t -eq 'reg') {
        if (JUndoReg $e) { $ok++ } else { $fail++ }
    }
    elseif ($e.t -eq 'task') {
        Enable-ScheduledTask -TaskPath $e.k1 -TaskName $e.k2 -ErrorAction SilentlyContinue | Out-Null
        $ok++
    }
    elseif ($e.t -eq 'power') {
        $oldG = [string]$e.k1; $newG = [string]$e.k2
        $lst = (powercfg /list | Out-String)
        if ($oldG -and ($lst -match [regex]::Escape($oldG))) { powercfg /setactive $oldG | Out-Null }
        else { powercfg /setactive '381b4222-f694-41f0-9685-ff5bb260df2e' | Out-Null }
        powercfg /delete $newG | Out-Null
        $ok++
    }
    elseif ($e.t -eq 'app') {
        $name = [string]$e.k1
        if ($seen.ContainsKey($name)) { continue }
        $seen[$name] = $true
        if (@(Get-AppxPackage -AllUsers -Name $name).Count -eq 0) {
            $wa = Join-Path $env:ProgramFiles 'WindowsApps'
            foreach ($d in @(Get-ChildItem -LiteralPath $wa -Directory -Filter ($name + '_*') -ErrorAction SilentlyContinue)) {
                $mf = Join-Path $d.FullName 'AppxManifest.xml'
                if (Test-Path -LiteralPath $mf) { Add-AppxPackage -DisableDevelopmentMode -Register $mf -ErrorAction SilentlyContinue }
            }
        }
        if (@(Get-AppxPackage -AllUsers -Name $name).Count -gt 0) { $ok++ } else { $manual++ }
    }
    elseif ($e.t -eq 'netpm') {
        Set-NetAdapterPowerManagement -Name ([string]$e.k1) -AllowComputerToTurnOffDevice Enabled -ErrorAction SilentlyContinue
        $ok++
    }
    elseif ($e.t -eq 'mppref') {
        $pv = ([string]$e.value).Split('|')
        if ($pv.Count -ge 2) { Set-MpPreference -ScanAvgCPULoadFactor ([int]$pv[0]) -EnableLowCpuPriority ([System.Convert]::ToBoolean($pv[1])) -ErrorAction SilentlyContinue }
        $ok++
    }
    elseif ($e.t -eq 'mmagent') {
        Enable-MMAgent -ApplicationPreLaunch -ErrorAction SilentlyContinue
        $ok++
    }
    elseif ($e.t -eq 'boottask') {
        Unregister-ScheduledTask -TaskName ([string]$e.k1) -Confirm:$false -ErrorAction SilentlyContinue
        if ([string]$e.k2 -ne [string]$env:PH_SELF) { Remove-Item -LiteralPath ([string]$e.k2) -Force -ErrorAction SilentlyContinue }
        if (Get-ScheduledTask -TaskName ([string]$e.k1) -ErrorAction SilentlyContinue) { $fail++ } else { $ok++ }
    }
    elseif ($e.t -eq 'od') {
        if (Test-Path -LiteralPath ([string]$e.k1)) { Start-Process -FilePath ([string]$e.k1) -Wait; $ok++ } else { $manual++ }
    }
}
if ($fail -eq 0) {
    Remove-Item -LiteralPath $jf -Force -ErrorAction SilentlyContinue
    $ap = Join-Path $ST 'applied.lst'
    if (Test-Path -LiteralPath $ap) {
        $left = @(Get-Content -LiteralPath $ap | Where-Object { $_ -and $_ -ne $item })
        if ($left.Count -gt 0) { Set-Content -LiteralPath $ap -Value $left } else { Remove-Item -LiteralPath $ap -Force -ErrorAction SilentlyContinue }
    }
}
Log ('UNDO ' + $item + ': ok=' + $ok + ' falhas=' + $fail + ' manual=' + $manual)
Write-Output ([string]$ok + '|' + [string]$fail + '|' + [string]$manual)
#</UNDO>
