# TensioTracker - Version Xojo iOS

Application iOS de suivi d'automesure tensionnelle en Xojo.

## Prerequis

- Xojo IDE 2021r3+ avec licence iOS
- macOS avec Xcode installe
- Simulateur iOS ou appareil iOS

## Mise en place dans Xojo IDE

### 1. Ouvrir le projet
`Fichier > Ouvrir` -> `TensioTracker.xojo_project`

### 2. Importer les fichiers
Glisser dans le navigateur du projet :
- `BloodPressureReading.xojo_code`
- `DayMeasurement.xojo_code`
- `MeasurementSession.xojo_code`
- `PatientProfile.xojo_code`
- `DataManager.xojo_code`
- `ConsignesScreen.xojo_code`
- `MesuresScreen.xojo_code`
- `ProfilScreen.xojo_code`

### 3. Configurer les ecrans dans l'IDE

Les fichiers `.xojo_code` contiennent la logique. Les controles
doivent etre ajoutes visuellement dans l'IDE Xojo.

#### ConsignesScreen
Ajouter :
- 1 `MobileTextArea` nommee `txtConsignes` (plein ecran, ReadOnly)
- Dans l'evenement `Opening`, appeler `PopulateConsignes()`

#### MesuresScreen
Ajouter :
- 1 `MobileSegmentedControl` nomme `segDay` (3 segments: Jour 1, Jour 2, Jour 3)
- 18 `MobileTextField` pour les mesures (clavier numerique) :
  - Matin : `tfMS1`, `tfMD1`, `tfMP1`, `tfMS2`, `tfMD2`, `tfMP2`, `tfMS3`, `tfMD3`, `tfMP3`
  - Soir  : `tfES1`, `tfED1`, `tfEP1`, `tfES2`, `tfED2`, `tfEP2`, `tfES3`, `tfED3`, `tfEP3`
- 4 `MobileLabel` : `lblAvgMatin`, `lblAvgSoir`, `lblAvgGeneral`, `lblStatus`
- 1 `MobileButton` -> appeler `OnSavePressed()` dans Pressed
- Connecter `segDay.ValueChanged` -> appeler `OnDayChanged()`

#### ProfilScreen
Ajouter :
- 2 `MobileTextField` : `tfNom`, `tfPrenom`
- 1 `MobileTextArea` : `taMeds`
- 3 `MobileButton` :
  - Enregistrer -> appeler `OnSaveProfilePressed()`
  - Exporter PDF -> appeler `OnExportPressed()`
  - Nouvelle session -> appeler `OnNewSessionPressed()`

### 4. Configurer le TabBar
Dans App, ajouter les 3 ecrans au TabBar :
1. ConsignesScreen
2. MesuresScreen
3. ProfilScreen

### 5. Compiler
`Cmd+R` pour lancer sur simulateur iOS.

## Structure des fichiers

```
TensioTrackerXojo/
  TensioTracker.xojo_project       # Projet iOS
  BloodPressureReading.xojo_code   # Modele SYS/DIA/Pouls
  DayMeasurement.xojo_code         # 3 matin + 3 soir
  MeasurementSession.xojo_code     # Session 3 jours
  PatientProfile.xojo_code         # Profil patient
  DataManager.xojo_code            # Persistance + moyennes + export
  ConsignesScreen.xojo_code        # Ecran consignes
  MesuresScreen.xojo_code          # Ecran saisie mesures
  ProfilScreen.xojo_code           # Ecran profil + export
```

## Notes

- Les controles sont declares comme proprietes dans les classes.
  Ils doivent etre crees dans l'IDE et connectes aux proprietes.
- L'export genere une image Picture partagee via MobileSharingPanel.
- Persistance JSON dans Documents (sandbox iOS).
- Les caracteres speciaux (accents) ont ete retires du code source
  pour eviter les problemes d'encodage dans certaines versions de Xojo.
