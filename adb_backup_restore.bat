@echo off
:: Vérifier si le script est exécuté en mode Administrateur
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Demande d'élévation...
    powershell -Command "Start-Process cmd -ArgumentList '/c %~s0' -Verb RunAs"
    exit
)

:: Vérifier si ADB est installé
adb version >nul 2>&1
if %errorlevel% neq 0 (
    echo ADB n'est pas installé. Installez-le d'abord.
    pause
    exit /b 1
)

:: Vérifier si un appareil Android est connecté
adb devices | findstr "device$" >nul
if %errorlevel% neq 0 (
    echo Aucun appareil détecté ! Activez le mode Debug USB et reconnectez l'appareil.
    pause
    exit /b 1
)

:: Demander le dossier de sauvegarde sur le PC
set /p BACKUP_DIR=Entrez le chemin du dossier de sauvegarde sur le PC (ex: D:\Backup_ADB) : 

:: Vérifier si le dossier existe, sinon le créer
if not exist "%BACKUP_DIR%" (
    echo Création du dossier de sauvegarde...
    mkdir "%BACKUP_DIR%"
    if %errorlevel% neq 0 (
        echo Erreur lors de la création du dossier de sauvegarde.
        pause
        exit /b 1
    )
    echo Dossier de sauvegarde créé avec succès !
)

:MENU
cls
echo Choisissez une option :
echo 1. Sauvegarde (Android vers PC)
echo 2. Restauration (PC vers Android)
echo 3. Synchronisation (bidirectionnelle)
echo 4. Quitter
set /p action=Entrez votre choix (1-4) : 

if "%action%"=="1" goto SAUVEGARDE
if "%action%"=="2" goto RESTAURATION
if "%action%"=="3" goto SYNCHRONISATION
if "%action%"=="4" exit /b 0

echo Choix invalide. Veuillez réessayer.
pause
goto MENU

:SAUVEGARDE
cls
echo Choisissez ce que vous voulez sauvegarder :
echo 1. Applications
echo 2. Photos
echo 3. Vidéos
echo 4. Musique
echo 5. Documents
echo 6. Tout
set /p backup_choice=Entrez votre choix (1-6) : 

if "%backup_choice%"=="1" (
    mkdir "%BACKUP_DIR%\applications" 2>nul
    cd "%BACKUP_DIR%\applications"
    adb backup -apk -shared -all -f "%BACKUP_DIR%\applications.ab"
    if %errorlevel% neq 0 (
        echo Erreur lors de la sauvegarde des applications.
    ) else (
        echo Sauvegarde des applications terminée !
    )
)
if "%backup_choice%"=="2" (
    mkdir "%BACKUP_DIR%\photos" 2>nul
    cd "%BACKUP_DIR%\photos"
    adb pull /sdcard/DCIM/ "%BACKUP_DIR%\photos"
    if %errorlevel% neq 0 (
        echo Erreur lors de la sauvegarde des photos.
    ) else (
        echo Sauvegarde des photos terminée !
    )
)
if "%backup_choice%"=="3" (
    mkdir "%BACKUP_DIR%\videos" 2>nul
    cd "%BACKUP_DIR%\videos"
    adb pull /sdcard/Movies/ "%BACKUP_DIR%\videos"
    if %errorlevel% neq 0 (
        echo Erreur lors de la sauvegarde des vidéos.
    ) else (
        echo Sauvegarde des vidéos terminée !
    )
)
if "%backup_choice%"=="4" (
    mkdir "%BACKUP_DIR%\music" 2>nul
    cd "%BACKUP_DIR%\music"
    adb pull /sdcard/Music/ "%BACKUP_DIR%\music"
    if %errorlevel% neq 0 (
        echo Erreur lors de la sauvegarde de la musique.
    ) else (
        echo Sauvegarde de la musique terminée !
    )
)
if "%backup_choice%"=="5" (
    mkdir "%BACKUP_DIR%\documents" 2>nul
    cd "%BACKUP_DIR%\documents"
    adb pull /sdcard/Documents/ "%BACKUP_DIR%\documents"
    if %errorlevel% neq 0 (
        echo Erreur lors de la sauvegarde des documents.
    ) else (
        echo Sauvegarde des documents terminée !
    )
)
if "%backup_choice%"=="6" (
    adb pull /sdcard/ "%BACKUP_DIR%\"
    if %errorlevel% neq 0 (
        echo Erreur lors de la sauvegarde de tout.
    ) else (
        echo Sauvegarde de tout terminée !
    )
)

pause
goto MENU

:RESTAURATION
cls
echo Choisissez ce que vous voulez restaurer :
echo 1. Applications
echo 2. Photos
echo 3. Vidéos
echo 4. Musique
echo 5. Documents
echo 6. Tout
set /p restore_choice=Entrez votre choix (1-6) : 

if "%restore_choice%"=="1" (
    adb restore "%BACKUP_DIR%\applications.ab"
    if %errorlevel% neq 0 (
        echo Erreur lors de la restauration des applications.
    ) else (
        echo Restauration des applications terminée !
    )
)
if "%restore_choice%"=="2" (
    adb push "%BACKUP_DIR%\photos" /sdcard/DCIM/
    if %errorlevel% neq 0 (
        echo Erreur lors de la restauration des photos.
    ) else (
        echo Restauration des photos terminée !
    )
)
if "%restore_choice%"=="3" (
    adb push "%BACKUP_DIR%\videos" /sdcard/Movies/
    if %errorlevel% neq 0 (
        echo Erreur lors de la restauration des vidéos.
    ) else (
        echo Restauration des vidéos terminée !
    )
)
if "%restore_choice%"=="4" (
    adb push "%BACKUP_DIR%\music" /sdcard/Music/
    if %errorlevel% neq 0 (
        echo Erreur lors de la restauration de la musique.
    ) else (
        echo Restauration de la musique terminée !
    )
)
if "%restore_choice%"=="5" (
    adb push "%BACKUP_DIR%\documents" /sdcard/Documents/
    if %errorlevel% neq 0 (
        echo Erreur lors de la restauration des documents.
    ) else (
        echo Restauration des documents terminée !
    )
)
if "%restore_choice%"=="6" (
    adb push "%BACKUP_DIR%\" /sdcard/
    if %errorlevel% neq 0 (
        echo Erreur lors de la restauration de tout.
    ) else (
        echo Restauration de tout terminée !
    )
)

pause
goto MENU

:SYNCHRONISATION
cls
echo Choisissez ce que vous voulez synchroniser :
echo 1. Photos
echo 2. Vidéos
echo 3. Musique
echo 4. Documents
echo 5. Tout
set /p sync_choice=Entrez votre choix (1-5) : 

if "%sync_choice%"=="1" (
    echo Synchronisation des photos en cours...
    adb pull /sdcard/DCIM/ "%BACKUP_DIR%\photos"
    adb push "%BACKUP_DIR%\photos" /sdcard/DCIM/
    if %errorlevel% neq 0 (
        echo Erreur lors de la synchronisation des photos.
    ) else (
        echo Synchronisation des photos terminée !
    )
)
if "%sync_choice%"=="2" (
    echo Synchronisation des vidéos en cours...
    adb pull /sdcard/Movies/ "%BACKUP_DIR%\videos"
    adb push "%BACKUP_DIR%\videos" /sdcard/Movies/
    if %errorlevel% neq 0 (
        echo Erreur lors de la synchronisation des vidéos.
    ) else (
        echo Synchronisation des vidéos terminée !
    )
)
if "%sync_choice%"=="3" (
    echo Synchronisation de la musique en cours...
    adb pull /sdcard/Music/ "%BACKUP_DIR%\music"
    adb push "%BACKUP_DIR%\music" /sdcard/Music/
    if %errorlevel% neq 0 (
        echo Erreur lors de la synchronisation de la musique.
    ) else (
        echo Synchronisation de la musique terminée !
    )
)
if "%sync_choice%"=="4" (
    echo Synchronisation des documents en cours...
    adb pull /sdcard/Documents/ "%BACKUP_DIR%\documents"
    adb push "%BACKUP_DIR%\documents" /sdcard/Documents/
    if %errorlevel% neq 0 (
        echo Erreur lors de la synchronisation des documents.
    ) else (
        echo Synchronisation des documents terminée !
    )
)
if "%sync_choice%"=="5" (
    echo Synchronisation de tout en cours...
    adb pull /sdcard/ "%BACKUP_DIR%\"
    adb push "%BACKUP_DIR%\" /sdcard/
    if %errorlevel% neq 0 (
        echo Erreur lors de la synchronisation de tout.
    ) else (
        echo Synchronisation de tout terminée !
    )
)

pause
goto MENU
