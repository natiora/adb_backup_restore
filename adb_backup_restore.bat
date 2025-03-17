@echo off

:: Verification si ADB est installe
adb version >nul 2>&1
if %errorlevel% neq 0 (
    echo ADB n'est pas installe. Installez-le d'abord.
    pause
    exit /b 1
)

:: Verification si un appareil Android est connecte
adb devices | findstr "device$" >nul
if %errorlevel% neq 0 (
    echo Aucun appareil detecte ! Activez le mode Debogage USB et reconnectez l'appareil.
    pause
    exit /b 1
)

set /p BACKUP_DIR=Entrez le chemin du dossier de sauvegarde sur le PC (ex: D:\Backup_ADB) : 
:: Verification si le dossier existe, sinon le creer
if not exist "%BACKUP_DIR%" (
    echo Creation du dossier de sauvegarde...
    mkdir "%BACKUP_DIR%/sdcard"
    echo Dossier de sauvegarde cree avec succes !
)

:MENU
cls
echo ================================
echo         Menu Principal
echo ================================
echo 1. Sauvegarde (Android vers PC)
echo 2. Restauration (PC vers Android)
echo 3. Synchronisation (bidirectionnelle)
echo 4. Quitter
echo ================================
set /p action=Entrez votre choix (1-4) : 

if "%action%"=="1" goto SAUVEGARDE
if "%action%"=="2" goto RESTAURATION
if "%action%"=="3" goto SYNCHRONISATION
if "%action%"=="4" exit /b 0

echo Choix invalide. Veuillez reessayer.
pause
goto MENU

:SAUVEGARDE
cls
echo ================================
echo        Sauvegarde de donnees
echo ================================
echo 1. Applications
echo 2. Photos
echo 3. Videos
echo 4. Musique
echo 5. Documents
echo 6. Tout
echo ================================
set /p backup_choice=Entrez votre choix (1-6) : 

if "%backup_choice%"=="1" (
    adb backup -apk -shared -all -f "%BACKUP_DIR%/sdcard/applications.ab"
    echo Sauvegarde des applications terminee !
)
if "%backup_choice%"=="2" (
    adb pull /sdcard/DCIM/ "%BACKUP_DIR%/sdcard/"
    echo Sauvegarde des photos terminee !
)
if "%backup_choice%"=="3" (
    adb pull /sdcard/Videos/ "%BACKUP_DIR%/sdcard/"
    echo Sauvegarde des videos terminee !
)
if "%backup_choice%"=="4" (
    adb pull /sdcard/Music/ "%BACKUP_DIR%/sdcard/"
    echo Sauvegarde de la musique terminee !
)
if "%backup_choice%"=="5" (
    adb pull /sdcard/Documents/ "%BACKUP_DIR%/sdcard/"
    echo Sauvegarde des documents terminee !
)
if "%backup_choice%"=="6" (
    adb pull /sdcard/ "%BACKUP_DIR%/sdcard/"
    echo Sauvegarde de tout terminee !
)

pause
goto MENU

:RESTAURATION
cls
echo ================================
echo        Restauration de donnees
echo ================================
echo 1. Applications
echo 2. Photos
echo 3. Videos
echo 4. Musique
echo 5. Documents
echo 6. Tout
echo ================================
set /p restore_choice=Entrez votre choix (1-6) : 

if "%restore_choice%"=="1" (
    adb restore "%BACKUP_DIR%/sdcard/applications.ab"
    echo Restauration des applications terminee !
)
if "%restore_choice%"=="2" (
    adb push "%BACKUP_DIR%/sdcard/photos" /sdcard/
    echo Restauration des photos terminee !
)
if "%restore_choice%"=="3" (
    adb push "%BACKUP_DIR%/sdcard/videos" /sdcard/
    echo Restauration des videos terminee !
)
if "%restore_choice%"=="4" (
    adb push "%BACKUP_DIR%/sdcard/Music" /sdcard/
    echo Restauration de la musique terminee !
)
if "%restore_choice%"=="5" (
    adb push "%BACKUP_DIR%/sdcard/Documents" /sdcard/
    echo Restauration des documents terminee !
)
if "%restore_choice%"=="6" (
    adb push "%BACKUP_DIR%/sdcard/" /sdcard/
    echo Restauration de tout terminee !
)

pause
goto MENU

:SYNCHRONISATION
cls
echo Choisissez ce que vous voulez synchroniser :
echo 1. Photos
echo 2. Videos
echo 3. Musique
echo 4. Documents
echo 5. Tout
set /p sync_choice=Entrez votre choix (1-5) : 

:: Synchronisation des photos
if "%sync_choice%"=="1" (
    echo Synchronisation des photos en cours...

    :: Suppression des photos supprimees sur le PC
    for /f "delims=" %%f in ('dir "%BACKUP_DIR%/sdcard/photos" /b /a-d') do (
        if not exist "%BACKUP_DIR%/sdcard/photos/%%f" (
            echo Suppression de la photo %%f sur le telephone...
            adb shell rm -rf /sdcard/DCIM/%%f
        )
    )

    :: Suppression des photos supprimees sur le telephone
    adb shell "for f in $(ls /sdcard/DCIM/); do if [ ! -f '%BACKUP_DIR%/sdcard/photos/$f' ]; then rm -rf /sdcard/DCIM/$f; fi; done"

    :: Recuperation des nouvelles photos du telephone
    adb pull /sdcard/DCIM/ "%BACKUP_DIR%/sdcard/"

    :: Envoi des nouvelles photos du PC vers le telephone
    adb push "%BACKUP_DIR%/sdcard/photos" /sdcard/

    echo Synchronisation des photos terminee ! 📸
)

:: Synchronisation des videos
if "%sync_choice%"=="2" (
    echo Synchronisation des videos en cours...

    :: Suppression des videos supprimees sur le PC
    for /f "delims=" %%f in ('dir "%BACKUP_DIR%/sdcard/Videos" /b /a-d') do (
        if not exist "%BACKUP_DIR%/sdcard/Videos/%%f" (
            echo Suppression de la video %%f sur le telephone...
            adb shell rm -rf /sdcard/Videos/%%f
        )
    )

    :: Suppression des videos supprimees sur le telephone
    adb shell "for f in $(ls /sdcard/Videos/); do if [ ! -f '%BACKUP_DIR%/sdcard/Videos/$f' ]; then rm -rf /sdcard/Videos/$f; fi; done"

    :: Recuperation des nouvelles videos du telephone
    adb pull /sdcard/Videos/ "%BACKUP_DIR%/sdcard/"

    :: Envoi des nouvelles videos du PC vers le telephone
    adb push "%BACKUP_DIR%/sdcard/Videos" /sdcard/

    echo Synchronisation des videos terminee ! 🎬
)

:: Synchronisation de la musique
if "%sync_choice%"=="3" (
    echo Synchronisation de la musique en cours...

    :: Suppression de la musique supprimee sur le PC
    for /f "delims=" %%f in ('dir "%BACKUP_DIR%/sdcard/Music" /b /a-d') do (
        if not exist "%BACKUP_DIR%/sdcard/Music/%%f" (
            echo Suppression de la musique %%f sur le telephone...
            adb shell rm -rf /sdcard/Music/%%f
        )
    )

    :: Suppression de la musique supprimee sur le telephone
    adb shell "for f in $(ls /sdcard/Music/); do if [ ! -f '%BACKUP_DIR%/sdcard/Music/$f' ]; then rm -rf /sdcard/Music/$f; fi; done"

    :: Recuperation de la musique du telephone
    adb pull /sdcard/Music/ "%BACKUP_DIR%/sdcard/"

    :: Envoi de la musique du PC vers le telephone
    adb push "%BACKUP_DIR%/sdcard/Music" /sdcard/

    echo Synchronisation de la musique terminee !
)

:: Synchronisation des documents
if "%sync_choice%"=="4" (
    echo Synchronisation des documents en cours...

    :: Suppression des documents supprimes sur le PC
    for /f "delims=" %%f in ('dir "%BACKUP_DIR%/sdcard/Documents" /b /a-d') do (
        if not exist "%BACKUP_DIR%/sdcard/Documents/%%f" (
            echo Suppression du fichier %%f sur le telephone...
            adb shell rm -rf /sdcard/Documents/%%f
        )
    )

    :: Suppression des documents supprimes sur le telephone
    adb shell "for f in $(ls /sdcard/Documents/); do if [ ! -f '%BACKUP_DIR%/sdcard/Documents/$f' ]; then rm -rf /sdcard/Documents/$f; fi; done"

    :: Recuperation des nouveaux documents du telephone
    adb pull /sdcard/Documents/ "%BACKUP_DIR%/sdcard/"

    :: Envoi des nouveaux documents du PC vers le telephone
    adb push "%BACKUP_DIR%/sdcard/Documents" /sdcard/

    echo Synchronisation des documents terminee ! 📄
)

:: Synchronisation de tout
if "%sync_choice%"=="5" (
    echo Synchronisation de tout en cours...

    :: Synchronisation des photos
    adb pull /sdcard/DCIM/ "%BACKUP_DIR%/sdcard/photos"
    adb push "%BACKUP_DIR%/sdcard/photos" /sdcard/DCIM/

    :: Synchronisation des videos
    adb pull /sdcard/Videos/ "%BACKUP_DIR%/sdcard/Videos"
    adb push "%BACKUP_DIR%/sdcard/Videos" /sdcard/Videos/

    :: Synchronisation de la musique
    adb pull /sdcard/Music/ "%BACKUP_DIR%/sdcard/Music"
    adb push "%BACKUP_DIR%/sdcard/Music" /sdcard/Music/

    :: Synchronisation des documents
    adb pull /sdcard/Documents/ "%BACKUP_DIR%/sdcard/Documents"
    adb push "%BACKUP_DIR%/sdcard/Documents" /sdcard/Documents/

    echo Synchronisation de tout terminee ! 🔄
)

pause
goto MENU