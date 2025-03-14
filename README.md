# Script de Sauvegarde et Restauration Android via ADB

Ce script permet de réaliser des sauvegardes et des restaurations de données d'un appareil Android à l'aide d'ADB (Android Debug Bridge). Vous pouvez sauvegarder et restaurer des applications, des photos, des vidéos, des MP3, des documents, ou effectuer une synchronisation de votre appareil.

---

## Prérequis

1. **Installation d'ADB** :
   - Vous devez avoir [ADB installé sur votre machine](https://developer.android.com/studio/command-line/adb).
   - Téléchargez et installez les outils ADB (Android SDK Platform Tools) depuis le site officiel ou via un gestionnaire de paquets comme `apt` (sur Linux) ou `choco` (sur Windows).

2. **Activer le Débogage USB sur votre appareil Android** :
   - Allez dans les paramètres de votre téléphone Android.
   - Accédez à **Options pour les développeurs** et activez **Débogage USB**.
     - Si les options pour les développeurs ne sont pas visibles, allez dans **À propos du téléphone** et tapez 7 fois sur **Numéro de build** pour les activer.
   - Connectez votre téléphone à votre PC via un câble USB.

3. **Permissions ADB** :
   - Assurez-vous que votre appareil est correctement autorisé à se connecter à ADB. Lors de la première connexion, un message de confirmation apparaîtra sur votre appareil. Acceptez la connexion.

4. **Dossier de Sauvegarde** :
   - Le script vous demandera de spécifier un dossier de sauvegarde sur votre ordinateur. Ce dossier sera utilisé pour stocker les fichiers de sauvegarde et de restauration.

---

## Fonctionnalités du Script

1. **Sauvegarde** :
   - Vous pouvez choisir de sauvegarder les éléments suivants :
     - **Applications** (avec ou sans données).
     - **Photos**.
     - **Vidéos**.
     - **MP3**.
     - **Documents**.
     - **Tout** (sauvegarde complète).

2. **Restauration** :
   - Vous pouvez restaurer les éléments suivants :
     - **Applications**.
     - **Photos**.
     - **Vidéos**.
     - **MP3**.
     - **Documents**.
     - **Tout** (Restauration complète).

3. **Synchronisation** :
   - Une option de synchronisation est ajoutée pour synchroniser les fichiers entre votre appareil et votre PC.

---

## Instructions d'Utilisation

### 1. Télécharger le Script
   - Téléchargez le script depuis le dépôt Git :
     ```bash
     git clone https://github.com/natiora/adb_backup_restore.git
     ```
   - Accédez au dossier du script :
     ```bash
     cd adb_backup_restore
     ```

### 2. Exécuter le Script
   - Sur **Windows** :
     - Double-cliquez sur le fichier `adb_backup_restore_android.bat` pour l'exécuter.
   - Sur **Linux/macOS** :
     - Ouvrez un terminal dans le dossier du script et exécutez :
       ```bash
       bash adb_backup_restore_android.sh
       ```

### 3. Interaction avec le Script
   - **Dossier de Sauvegarde** :
     - Le script vous demandera d'entrer le chemin du dossier où vous souhaitez sauvegarder vos fichiers.
   - **Choisir l'Action** :
     - Le script vous demandera de choisir entre **sauvegarde**, **restauration**, ou **synchronisation**.

### 4. Sauvegarde
   - Vous serez invité à choisir ce que vous souhaitez sauvegarder (applications, photos, vidéos, etc.).
   - Le script créera automatiquement les dossiers nécessaires et exécutera les commandes ADB correspondantes pour la sauvegarde.

### 5. Restauration
   - Vous serez invité à choisir ce que vous souhaitez restaurer.
   - Le script restaurera les fichiers depuis le dossier de sauvegarde en utilisant les commandes ADB appropriées.

### 6. Synchronisation
   - Vous pouvez synchroniser les éléments de votre choix entre votre appareil et votre PC.

---

## Exemples de Commandes

### Sauvegarde des Photos
   - Sélectionnez l'option **Sauvegarde**.
   - Choisissez **Photos**.
   - Le script sauvegardera les photos dans le dossier spécifié.

### Restauration des Applications
   - Sélectionnez l'option **Restauration**.
   - Choisissez **Applications**.
   - Le script restaurera les applications depuis le dossier de sauvegarde.

### Synchronisation des Documents
   - Sélectionnez l'option **Synchronisation**.
   - Choisissez **Documents**.
   - Le script synchronisera les documents entre votre appareil et votre PC.

---

## Téléchargement
   - Vous pouvez télécharger le script depuis le dépôt Git :
     ```bash
     git clone https://github.com/natiora/adb_backup_restore.git
     ```

---

## Contribution
   - Si vous souhaitez contribuer à ce projet, n'hésitez pas à ouvrir une **issue** ou à soumettre une **pull request** sur le dépôt Git.

---

## Licence
   - Ce projet est sous licence MIT. Consultez le fichier [LICENSE](LICENSE) pour plus de détails.

---
