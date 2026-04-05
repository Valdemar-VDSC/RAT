# TensioTracker - Version Xojo iOS

Application iOS de suivi d'automesure tensionnelle développée en Xojo.

## Prérequis

- **Xojo IDE** 2021r3 ou supérieur avec licence iOS
- macOS avec Xcode installé
- Simulateur iOS ou appareil iOS

## Installation

1. Ouvrir **Xojo IDE**
2. `Fichier > Ouvrir...` → sélectionner `TensioTracker.xojo_project`
3. Ajouter les fichiers sources au projet si nécessaire :
   - `BloodPressureReading.xojo_code`
   - `DayMeasurement.xojo_code`
   - `MeasurementSession.xojo_code`
   - `PatientProfile.xojo_code`
   - `DataManager.xojo_code`
   - `ConsignesScreen.xojo_code`
   - `MesuresScreen.xojo_code`
   - `ProfilScreen.xojo_code`
4. Configurer le TabBar dans l'App :
   - Tab 1 : ConsignesScreen
   - Tab 2 : MesuresScreen
   - Tab 3 : ProfilScreen
5. Compiler et exécuter (`Cmd+R`)

## Structure

```
TensioTrackerXojo/
├── TensioTracker.xojo_project       # Projet Xojo iOS
├── BloodPressureReading.xojo_code   # Lecture SYS/DIA/Pouls
├── DayMeasurement.xojo_code         # 3 mesures matin + 3 soir
├── MeasurementSession.xojo_code     # Session de 3 jours
├── PatientProfile.xojo_code         # Profil patient
├── DataManager.xojo_code            # Persistance JSON + moyennes + export
├── ConsignesScreen.xojo_code        # Écran Consignes
├── MesuresScreen.xojo_code          # Écran Saisie des mesures
└── ProfilScreen.xojo_code           # Écran Profil + Export
```

## Fonctionnalités

### Écran Consignes
- Recommandations de mesure (protocole français)

### Écran Mesures
- Sélection Jour 1/2/3 via SegmentedControl
- Saisie SYS/DIA/Pouls (clavier numérique)
- 3 mesures matin + 3 mesures soir
- Moyennes automatiques (matin, soir, générale)
- Indicateur coloré selon seuil 135/85

### Écran Profil
- Nom, prénom, médicaments
- Export du relevé via MobileSharingPanel
- Nouvelle session

### Persistance
- JSON dans Documents (`tensiotracker_data.json`)
