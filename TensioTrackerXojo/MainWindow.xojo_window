#tag Window
Begin DesktopWindow MainWindow
   Title           =   "TensioTracker - Relevé d'automesure tensionnelle"
   Width           =   800
   Height          =   650
   MinimumWidth    =   700
   MinimumHeight   =   600

   Begin DesktopTabPanel TabPanel1
      Left            =   0
      Top             =   0
      Width           =   800
      Height          =   650
      LockLeft        =   True
      LockTop         =   True
      LockRight       =   True
      LockBottom      =   True
      PanelCount      =   3
      Value           =   0

      // Tab 0: Consignes
      // Tab 1: Mesures
      // Tab 2: Profil
   End

   // ===== TAB 0: CONSIGNES =====
   Begin DesktopTextArea txtConsignes
      Left            =   20
      Top             =   50
      Width           =   760
      Height          =   560
      LockLeft        =   True
      LockTop         =   True
      LockRight       =   True
      LockBottom      =   True
      ReadOnly        =   True
      ScrollbarType   =   3
      Text            =   ""
   End

   // ===== TAB 1: MESURES =====
   // Day selector
   Begin DesktopPopupMenu popDay
      Left            =   20
      Top             =   50
      Width           =   150
   End

   Begin DesktopDateTimePicker dtpDate
      Left            =   190
      Top             =   50
      Width           =   180
   End

   // Morning labels
   Begin DesktopLabel lblMatin
      Left            =   20
      Top             =   90
      Text            =   "MATIN - Avant le petit-déjeuner et les médicaments"
      Bold            =   True
   End

   Begin DesktopLabel lblMSys1
      Left            =   20
      Top             =   120
      Text            =   "Mesure 1"
   End
   Begin DesktopTextField tfMSys1
      Left            =   100
      Top             =   118
      Width           =   60
      Hint            =   "SYS"
   End
   Begin DesktopTextField tfMDia1
      Left            =   170
      Top             =   118
      Width           =   60
      Hint            =   "DIA"
   End
   Begin DesktopTextField tfMPulse1
      Left            =   240
      Top             =   118
      Width           =   60
      Hint            =   "Pouls"
   End

   Begin DesktopLabel lblMSys2
      Left            =   20
      Top             =   150
      Text            =   "Mesure 2"
   End
   Begin DesktopTextField tfMSys2
      Left            =   100
      Top             =   148
      Width           =   60
      Hint            =   "SYS"
   End
   Begin DesktopTextField tfMDia2
      Left            =   170
      Top             =   148
      Width           =   60
      Hint            =   "DIA"
   End
   Begin DesktopTextField tfMPulse2
      Left            =   240
      Top             =   148
      Width           =   60
      Hint            =   "Pouls"
   End

   Begin DesktopLabel lblMSys3
      Left            =   20
      Top             =   180
      Text            =   "Mesure 3"
   End
   Begin DesktopTextField tfMSys3
      Left            =   100
      Top             =   178
      Width           =   60
      Hint            =   "SYS"
   End
   Begin DesktopTextField tfMDia3
      Left            =   170
      Top             =   178
      Width           =   60
      Hint            =   "DIA"
   End
   Begin DesktopTextField tfMPulse3
      Left            =   240
      Top             =   178
      Width           =   60
      Hint            =   "Pouls"
   End

   // Evening labels
   Begin DesktopLabel lblSoir
      Left            =   20
      Top             =   230
      Text            =   "SOIR - Avant le coucher"
      Bold            =   True
   End

   Begin DesktopLabel lblSSys1
      Left            =   20
      Top             =   260
      Text            =   "Mesure 1"
   End
   Begin DesktopTextField tfSSys1
      Left            =   100
      Top             =   258
      Width           =   60
      Hint            =   "SYS"
   End
   Begin DesktopTextField tfSDia1
      Left            =   170
      Top             =   258
      Width           =   60
      Hint            =   "DIA"
   End
   Begin DesktopTextField tfSPulse1
      Left            =   240
      Top             =   258
      Width           =   60
      Hint            =   "Pouls"
   End

   Begin DesktopLabel lblSSys2
      Left            =   20
      Top             =   290
      Text            =   "Mesure 2"
   End
   Begin DesktopTextField tfSSys2
      Left            =   100
      Top             =   288
      Width           =   60
      Hint            =   "SYS"
   End
   Begin DesktopTextField tfSDia2
      Left            =   170
      Top             =   288
      Width           =   60
      Hint            =   "DIA"
   End
   Begin DesktopTextField tfSPulse2
      Left            =   240
      Top             =   288
      Width           =   60
      Hint            =   "Pouls"
   End

   Begin DesktopLabel lblSSys3
      Left            =   20
      Top             =   320
      Text            =   "Mesure 3"
   End
   Begin DesktopTextField tfSSys3
      Left            =   100
      Top             =   318
      Width           =   60
      Hint            =   "SYS"
   End
   Begin DesktopTextField tfSDia3
      Left            =   170
      Top             =   318
      Width           =   60
      Hint            =   "DIA"
   End
   Begin DesktopTextField tfSPulse3
      Left            =   240
      Top             =   318
      Width           =   60
      Hint            =   "Pouls"
   End

   // Column headers
   Begin DesktopLabel lblHdrSys
      Left            =   100
      Top             =   100
      Width           =   60
      Text            =   "SYS"
      TextAlignment   =   1
      Bold            =   True
   End
   Begin DesktopLabel lblHdrDia
      Left            =   170
      Top             =   100
      Width           =   60
      Text            =   "DIA"
      TextAlignment   =   1
      Bold            =   True
   End
   Begin DesktopLabel lblHdrPulse
      Left            =   240
      Top             =   100
      Width           =   60
      Text            =   "Pouls"
      TextAlignment   =   1
      Bold            =   True
   End

   // Averages display
   Begin DesktopGroupBox grpAverages
      Left            =   400
      Top             =   80
      Width           =   370
      Height          =   280
      Caption         =   "Moyennes de la session"
   End

   Begin DesktopLabel lblAvgMorning
      Left            =   420
      Top             =   110
      Width           =   330
      Text            =   "Moyenne du matin : — / — mmHg"
   End
   Begin DesktopLabel lblAvgEvening
      Left            =   420
      Top             =   140
      Width           =   330
      Text            =   "Moyenne du soir : — / — mmHg"
   End
   Begin DesktopLabel lblAvgGeneral
      Left            =   420
      Top             =   180
      Width           =   330
      Height          =   30
      Text            =   "Moyenne générale : — / — mmHg"
      Bold            =   True
      FontSize        =   14
   End
   Begin DesktopLabel lblStatus
      Left            =   420
      Top             =   220
      Width           =   330
      Text            =   "Objectif : < 135 / 85 mmHg"
   End

   Begin DesktopButton btnSave
      Left            =   420
      Top             =   290
      Width           =   150
      Caption         =   "Sauvegarder"
   End

   Begin DesktopButton btnNewSession
      Left            =   590
      Top             =   290
      Width           =   150
      Caption         =   "Nouvelle session"
   End

   // ===== TAB 2: PROFIL =====
   Begin DesktopLabel lblNom
      Left            =   20
      Top             =   60
      Text            =   "Nom :"
   End
   Begin DesktopTextField tfNom
      Left            =   120
      Top             =   58
      Width           =   250
   End

   Begin DesktopLabel lblPrenom
      Left            =   20
      Top             =   95
      Text            =   "Prénom :"
   End
   Begin DesktopTextField tfPrenom
      Left            =   120
      Top             =   93
      Width           =   250
   End

   Begin DesktopLabel lblDateNaiss
      Left            =   20
      Top             =   130
      Text            =   "Date de naissance :"
   End
   Begin DesktopDateTimePicker dtpBirthDate
      Left            =   160
      Top             =   128
      Width           =   200
   End

   Begin DesktopLabel lblMeds
      Left            =   20
      Top             =   170
      Text            =   "Médicaments antihypertenseurs :"
   End
   Begin DesktopTextArea taMeds
      Left            =   20
      Top             =   195
      Width           =   350
      Height          =   100
   End

   Begin DesktopButton btnExportPDF
      Left            =   420
      Top             =   60
      Width           =   200
      Height          =   40
      Caption         =   "Exporter le relevé en PDF"
   End

   Begin DesktopButton btnSaveProfile
      Left            =   420
      Top             =   120
      Width           =   200
      Caption         =   "Enregistrer le profil"
   End

   #tag Event
     Sub Opening()
       // Set tab titles
       TabPanel1.PanelAt(0).Caption = "Consignes"
       TabPanel1.PanelAt(1).Caption = "Mesures"
       TabPanel1.PanelAt(2).Caption = "Profil"

       // Populate day selector
       popDay.AddRow("Jour 1")
       popDay.AddRow("Jour 2")
       popDay.AddRow("Jour 3")
       popDay.SelectedRowIndex = 0

       // Load data
       DataManager.LoadData

       // Populate consignes
       PopulateConsignes

       // Populate profile fields
       LoadProfileToUI

       // Load measurements for day 1
       LoadDayToUI(0)

       // Update averages
       UpdateAverages
     End Sub
   #tag EndEvent

   #tag Method, Flags = &h1
     Private Sub PopulateConsignes()
       Var text As String

       text = "CONSIGNES DE MESURE" + EndOfLine
       text = text + "===========================================" + EndOfLine + EndOfLine

       text = text + "AVANT LA MESURE" + EndOfLine
       text = text + "• Pas de tabac, caféine, nourriture, exercice 30 minutes avant" + EndOfLine
       text = text + "• Être seul dans un endroit calme" + EndOfLine
       text = text + "• Température confortable" + EndOfLine
       text = text + "• Se reposer 3 à 5 minutes avant la première mesure" + EndOfLine
       text = text + "• Ne pas parler ni utiliser d'écran avant, pendant et entre les mesures" + EndOfLine + EndOfLine

       text = text + "POSITION" + EndOfLine
       text = text + "• Dos soutenu (appuyé contre le dossier)" + EndOfLine
       text = text + "• Bras nu reposant sur la table, brassard à mi-bras au niveau du cœur" + EndOfLine
       text = text + "• Pieds à plat sur le sol" + EndOfLine
       text = text + "• Taille de brassard adaptée (petit, moyen, grand)" + EndOfLine + EndOfLine

       text = text + "MATÉRIEL" + EndOfLine
       text = text + "• Tensiomètre validé avec brassard au bras" + EndOfLine
       text = text + "• Liste des appareils recommandés : www.stridebp.org/fr/" + EndOfLine + EndOfLine

       text = text + "PROTOCOLE" + EndOfLine
       text = text + "===========================================" + EndOfLine
       text = text + "• 3 jours consécutifs de mesures" + EndOfLine
       text = text + "• 3 mesures le matin, avant le petit-déjeuner et la prise de médicaments" + EndOfLine
       text = text + "• 3 mesures le soir, avant le coucher" + EndOfLine
       text = text + "• Toujours le même bras" + EndOfLine
       text = text + "• Attendre 1 minute entre chaque mesure" + EndOfLine + EndOfLine

       text = text + "OBJECTIF TENSIONNEL" + EndOfLine
       text = text + "< 135 / 85 mmHg en automesure dans la plupart des cas." + EndOfLine
       text = text + "Consultez votre médecin pour un objectif personnalisé."

       txtConsignes.Text = text
     End Sub
   #tag EndMethod

   #tag Method, Flags = &h1
     Private Sub LoadProfileToUI()
       tfNom.Text = DataManager.CurrentProfile.mLastName
       tfPrenom.Text = DataManager.CurrentProfile.mFirstName
       taMeds.Text = DataManager.CurrentProfile.mMedications
       If DataManager.CurrentProfile.mBirthDate <> Nil Then
         dtpBirthDate.SelectedDate = DataManager.CurrentProfile.mBirthDate
       End If
     End Sub
   #tag EndMethod

   #tag Method, Flags = &h1
     Private Sub SaveUIToProfile()
       DataManager.CurrentProfile.mLastName = tfNom.Text
       DataManager.CurrentProfile.mFirstName = tfPrenom.Text
       DataManager.CurrentProfile.mMedications = taMeds.Text
       DataManager.CurrentProfile.mBirthDate = dtpBirthDate.SelectedDate
     End Sub
   #tag EndMethod

   #tag Method, Flags = &h0
     Sub LoadDayToUI(dayIndex As Integer)
       Var day As DayMeasurement = DataManager.CurrentSession.mDays(dayIndex)

       If day.mDate <> Nil Then
         dtpDate.SelectedDate = day.mDate
       Else
         dtpDate.SelectedDate = DateTime.Now
       End If

       // Morning
       tfMSys1.Text = If(day.mMorningReadings(0).mSystolic > 0, Str(day.mMorningReadings(0).mSystolic), "")
       tfMDia1.Text = If(day.mMorningReadings(0).mDiastolic > 0, Str(day.mMorningReadings(0).mDiastolic), "")
       tfMPulse1.Text = If(day.mMorningReadings(0).mPulse > 0, Str(day.mMorningReadings(0).mPulse), "")

       tfMSys2.Text = If(day.mMorningReadings(1).mSystolic > 0, Str(day.mMorningReadings(1).mSystolic), "")
       tfMDia2.Text = If(day.mMorningReadings(1).mDiastolic > 0, Str(day.mMorningReadings(1).mDiastolic), "")
       tfMPulse2.Text = If(day.mMorningReadings(1).mPulse > 0, Str(day.mMorningReadings(1).mPulse), "")

       tfMSys3.Text = If(day.mMorningReadings(2).mSystolic > 0, Str(day.mMorningReadings(2).mSystolic), "")
       tfMDia3.Text = If(day.mMorningReadings(2).mDiastolic > 0, Str(day.mMorningReadings(2).mDiastolic), "")
       tfMPulse3.Text = If(day.mMorningReadings(2).mPulse > 0, Str(day.mMorningReadings(2).mPulse), "")

       // Evening
       tfSSys1.Text = If(day.mEveningReadings(0).mSystolic > 0, Str(day.mEveningReadings(0).mSystolic), "")
       tfSDia1.Text = If(day.mEveningReadings(0).mDiastolic > 0, Str(day.mEveningReadings(0).mDiastolic), "")
       tfSPulse1.Text = If(day.mEveningReadings(0).mPulse > 0, Str(day.mEveningReadings(0).mPulse), "")

       tfSSys2.Text = If(day.mEveningReadings(1).mSystolic > 0, Str(day.mEveningReadings(1).mSystolic), "")
       tfSDia2.Text = If(day.mEveningReadings(1).mDiastolic > 0, Str(day.mEveningReadings(1).mDiastolic), "")
       tfSPulse2.Text = If(day.mEveningReadings(1).mPulse > 0, Str(day.mEveningReadings(1).mPulse), "")

       tfSSys3.Text = If(day.mEveningReadings(2).mSystolic > 0, Str(day.mEveningReadings(2).mSystolic), "")
       tfSDia3.Text = If(day.mEveningReadings(2).mDiastolic > 0, Str(day.mEveningReadings(2).mDiastolic), "")
       tfSPulse3.Text = If(day.mEveningReadings(2).mPulse > 0, Str(day.mEveningReadings(2).mPulse), "")
     End Sub
   #tag EndMethod

   #tag Method, Flags = &h0
     Sub SaveUIToDay(dayIndex As Integer)
       Var day As DayMeasurement = DataManager.CurrentSession.mDays(dayIndex)

       day.mDate = dtpDate.SelectedDate

       // Morning
       day.mMorningReadings(0).mSystolic = Val(tfMSys1.Text)
       day.mMorningReadings(0).mDiastolic = Val(tfMDia1.Text)
       day.mMorningReadings(0).mPulse = Val(tfMPulse1.Text)

       day.mMorningReadings(1).mSystolic = Val(tfMSys2.Text)
       day.mMorningReadings(1).mDiastolic = Val(tfMDia2.Text)
       day.mMorningReadings(1).mPulse = Val(tfMPulse2.Text)

       day.mMorningReadings(2).mSystolic = Val(tfMSys3.Text)
       day.mMorningReadings(2).mDiastolic = Val(tfMDia3.Text)
       day.mMorningReadings(2).mPulse = Val(tfMPulse3.Text)

       // Evening
       day.mEveningReadings(0).mSystolic = Val(tfSSys1.Text)
       day.mEveningReadings(0).mDiastolic = Val(tfSDia1.Text)
       day.mEveningReadings(0).mPulse = Val(tfSPulse1.Text)

       day.mEveningReadings(1).mSystolic = Val(tfSSys2.Text)
       day.mEveningReadings(1).mDiastolic = Val(tfSDia2.Text)
       day.mEveningReadings(1).mPulse = Val(tfSPulse2.Text)

       day.mEveningReadings(2).mSystolic = Val(tfSSys3.Text)
       day.mEveningReadings(2).mDiastolic = Val(tfSDia3.Text)
       day.mEveningReadings(2).mPulse = Val(tfSPulse3.Text)
     End Sub
   #tag EndMethod

   #tag Method, Flags = &h0
     Sub UpdateAverages()
       Var mSys As String = DataManager.FormatAverage(DataManager.MorningAverageSys())
       Var mDia As String = DataManager.FormatAverage(DataManager.MorningAverageDia())
       lblAvgMorning.Text = "Moyenne du matin : " + mSys + " / " + mDia + " mmHg"

       Var eSys As String = DataManager.FormatAverage(DataManager.EveningAverageSys())
       Var eDia As String = DataManager.FormatAverage(DataManager.EveningAverageDia())
       lblAvgEvening.Text = "Moyenne du soir : " + eSys + " / " + eDia + " mmHg"

       Var gSys As Double = DataManager.GeneralAverageSys()
       Var gDia As Double = DataManager.GeneralAverageDia()
       lblAvgGeneral.Text = "Moyenne générale : " + DataManager.FormatAverage(gSys) + " / " + DataManager.FormatAverage(gDia) + " mmHg"

       If gSys > 0 And gDia > 0 Then
         If gSys < 135 And gDia < 85 Then
           lblStatus.Text = "✓ Normal (objectif < 135 / 85 mmHg)"
           lblStatus.TextColor = &h008000
         Else
           lblStatus.Text = "⚠ Élevée (objectif < 135 / 85 mmHg)"
           lblStatus.TextColor = &hCC0000
         End If
       Else
         lblStatus.Text = "Objectif : < 135 / 85 mmHg"
         lblStatus.TextColor = Color.Black
       End If
     End Sub
   #tag EndMethod

   // === Event Handlers ===

   #tag EventHandler
     Sub popDay.SelectionChanged(item As DesktopMenuItem)
       // Save current day before switching
       Var prevDay As Integer = 0
       // Load new day
       LoadDayToUI(popDay.SelectedRowIndex)
     End Sub
   #tag EndEventHandler

   #tag EventHandler
     Sub btnSave.Pressed()
       SaveUIToDay(popDay.SelectedRowIndex)
       SaveUIToProfile
       DataManager.SaveData
       UpdateAverages
       MessageBox("Données sauvegardées.")
     End Sub
   #tag EndEventHandler

   #tag EventHandler
     Sub btnNewSession.Pressed()
       If MessageBox("Créer une nouvelle session ? La session actuelle sera sauvegardée.", _
         MessageBoxButton.OKCancel, MessageBoxType.Question) = MessageBoxResult.OK Then
         SaveUIToDay(popDay.SelectedRowIndex)
         DataManager.SaveData
         DataManager.CurrentSession = New MeasurementSession
         popDay.SelectedRowIndex = 0
         LoadDayToUI(0)
         UpdateAverages
       End If
     End Sub
   #tag EndEventHandler

   #tag EventHandler
     Sub btnSaveProfile.Pressed()
       SaveUIToProfile
       DataManager.SaveData
       MessageBox("Profil enregistré.")
     End Sub
   #tag EndEventHandler

   #tag EventHandler
     Sub btnExportPDF.Pressed()
       SaveUIToDay(popDay.SelectedRowIndex)
       SaveUIToProfile

       Var dlg As New SaveFileDialog
       dlg.Title = "Exporter le relevé"
       dlg.SuggestedFileName = "Releve_tensionnel_" + DataManager.CurrentProfile.mLastName + "_" + _
         DataManager.CurrentProfile.mFirstName + ".png"
       dlg.Filter = FileTypeGroup1.AllTypes

       Var f As FolderItem = dlg.ShowModal
       If f <> Nil Then
         DataManager.GeneratePDF(f)
         MessageBox("Relevé exporté avec succès.")
       End If
     End Sub
   #tag EndEventHandler

End DesktopWindow
#tag EndWindow
