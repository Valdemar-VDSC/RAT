# TensioTracker - Version Xojo

Application de suivi d'automesure tensionnelle développée en Xojo (Desktop).

## Prérequis

- **Xojo IDE** 2020r2 ou supérieur (https://www.xojo.com)
- Fonctionne sur macOS, Windows et Linux

## Installation

1. Ouvrir **Xojo IDE**
2. `Fichier > Ouvrir...` → sélectionner `TensioTracker.xojo_project`
3. Ajouter les fichiers sources au projet :
   - `BloodPressureReading.xojo_code`
   - `DayMeasurement.xojo_code`
   - `MeasurementSession.xojo_code`
   - `PatientProfile.xojo_code`
   - `DataManager.xojo_code`
   - `MainWindow.xojo_window`
4. Compiler et exécuter (`Cmd+R` / `Ctrl+R`)

## Structure

```
TensioTrackerXojo/
├── TensioTracker.xojo_project    # Projet Xojo
├── BloodPressureReading.xojo_code  # Modèle de lecture tensionnelle
├── DayMeasurement.xojo_code      # Mesures d'un jour (3 matin + 3 soir)
├── MeasurementSession.xojo_code  # Session de 3 jours
├── PatientProfile.xojo_code      # Profil patient
├── DataManager.xojo_code         # Persistance JSON + calcul moyennes + export
└── MainWindow.xojo_window        # Fenêtre principale avec 3 onglets
```

## Fonctionnalités

### Onglet Consignes
- Recommandations de mesure conformes aux directives françaises
- Protocole (3 jours, 3 mesures matin/soir, 1 min entre chaque)

### Onglet Mesures
- Sélection Jour 1/2/3 avec date
- Saisie SYS/DIA/Pouls pour 3 mesures matin + 3 mesures soir
- Calcul automatique des moyennes (matin, soir, générale)
- Indicateur coloré : vert si < 135/85, rouge si élevé

### Onglet Profil
- Nom, prénom, date de naissance
- Médicaments antihypertenseurs
- Export du relevé au format image (PNG)
- Sauvegarde du profil

### Persistance
- Données sauvegardées en JSON dans `~/Application Support/TensioTracker/data.json`

### Export
- Génération d'un relevé reproduisant la fiche officielle
- Tableau 3 jours × Matin/Soir avec valeurs
- Moyennes systolique et diastolique calculées

## Notes

- L'export utilise `Picture.Save` en PNG. Pour un vrai PDF, utiliser 
  une bibliothèque PDF Xojo (comme DynaPDF ou le module `PDFDocument`
  disponible dans Xojo 2021r3+).
- Les données sont stockées localement en JSON.
