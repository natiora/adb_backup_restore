@echo off
:: Demander à l'utilisateur de saisir le chemin du dossier de sauvegarde
set /p BACKUP_DIR="Entrez le chemin du dossier de sauvegarde (ex: D:\Backup_ADB) : "

:: Vérifier si ADB est installé
adb version >nul 2>&1
if %errorlevel% neq 0 (
    echo ADB n'est pas installé. Installez-le d'abord.
    pause
    exit /b 1
)

:: Vérifier si le téléphone est connecté
adb devices | findstr "device$" >nul
if %errorlevel% neq 0 (
    echo Aucun appareil trouvé. Assurez-vous que le mode Debug USB est activé.
    pause
    exit /b 1
)

:: Vérifier si le dossier de sauvegarde existe, sinon le créer
if not exist "%BACKUP_DIR%" (
    echo Création du dossier...
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
echo 1. Sauvegarde
echo 2. Restauration
echo 3. Synchronisation
echo 4. Quitter
set /p action="Entrez votre choix (1-4) : "

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
echo 4. MP3
echo 5. Documents
echo 6. Tout
set /p backup_choice="Entrez votre choix (1-6) : "

if "%backup_choice%"=="1" (
    mkdir "%BACKUP_DIR%\applications" 2>nul
    cd "%BACKUP_DIR%\applications"
    adb backup -apk -shared -all -f "%BACKUP_DIR%\applications.ab"
    echo Sauvegarde des applications terminée !
)
if "%backup_choice%"=="2" (
    mkdir "%BACKUP_DIR%\photos" 2>nul
    cd "%BACKUP_DIR%\photos"
    adb pull /sdcard/DCIM/ "%BACKUP_DIR%\photos"
    echo Sauvegarde des photos terminée !
)
if "%backup_choice%"=="3" (
    mkdir "%BACKUP_DIR%\videos" 2>nul
    cd "%BACKUP_DIR%\videos"
    adb pull /sdcard/Movies/ "%BACKUP_DIR%\videos"
    echo Sauvegarde des vidéos terminée !
)
if "%backup_choice%"=="4" (
    mkdir "%BACKUP_DIR%\mp3" 2>nul
    cd "%BACKUP_DIR%\mp3"
    adb pull /sdcard/Music/ "%BACKUP_DIR%\mp3"
    echo Sauvegarde des MP3 terminée !
)
if "%backup_choice%"=="5" (
    mkdir "%BACKUP_DIR%\documents" 2>nul
    cd "%BACKUP_DIR%\documents"
    adb pull /sdcard/Documents/ "%BACKUP_DIR%\documents"
    echo Sauvegarde des documents terminée !
)
if "%backup_choice%"=="6" (
    mkdir "%BACKUP_DIR%\tout" 2>nul
    cd
    adb pull /sdcard/ "%BACKUP_DIR%\tout"
    echo Sauvegarde de tout terminée !
)

pause
goto MENU

:RESTAURATION
cls
echo Choisissez ce que vous voulez restaurer :
echo 1. Applications
echo 2. Photos
echo 3. Vidéos
echo 4. MP3
echo 5. Documents
echo 6. Tout
set /p restore_choice="Entrez votre choix (1-6) : "

if "%restore_choice%"=="1" (
    adb restore "%BACKUP_DIR%\applications.ab"
    echo Restauration des applications terminée !
)
if "%restore_choice%"=="2" (
    adb push "%BACKUP_DIR%\photos" /sdcard/DCIM/
    echo Restauration des photos terminée !
)
if "%restore_choice%"=="3" (
    adb push "%BACKUP_DIR%\videos" /sdcard/Movies/
    echo Restauration des vidéos terminée !
)
if "%restore_choice%"=="4" (
    adb push "%BACKUP_DIR%\mp3" /sdcard/Music/
    echo Restauration des MP3 terminée !
)
if "%restore_choice%"=="5" (
    adb push "%BACKUP_DIR%\documents" /sdcard/Documents/
    echo Restauration des documents terminée !
)
if "%restore_choice%"=="6" (
    adb push "%BACKUP_DIR%\tout" /sdcard/
    echo Restauration de tout terminée !
)

pause
goto MENU

:SYNCHRONISATION
cls
echo Synchronisation en cours...
    robocopy %BACKUP_DIR% /sdcard/ /MIR /COPYALL
echo Synchronisation terminée !
pause
goto MENU