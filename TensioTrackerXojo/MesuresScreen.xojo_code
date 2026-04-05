#tag MobileScreen
Protected Class MesuresScreen
  Inherits MobileScreen

  #tag Event
    Sub Opening()
      Self.Title = "Mesures"
      Self.TabIcon = MobileScreen.SystemIconFeatured

      // Populate day selector
      segDay.Segments.Add("Jour 1")
      segDay.Segments.Add("Jour 2")
      segDay.Segments.Add("Jour 3")
      segDay.SelectedSegment = 0

      DataManager.LoadData
      LoadDayToUI(0)
      UpdateAverages
    End Sub
  #tag EndEvent

  #tag Method, Flags = &h0
    Sub LoadDayToUI(dayIndex As Integer)
      If DataManager.CurrentSession = Nil Then Return
      Var day As DayMeasurement = DataManager.CurrentSession.mDays(dayIndex)

      // Morning Mesure 1
      tfMS1.Text = If(day.mMorningReadings(0).mSystolic > 0, Str(day.mMorningReadings(0).mSystolic), "")
      tfMD1.Text = If(day.mMorningReadings(0).mDiastolic > 0, Str(day.mMorningReadings(0).mDiastolic), "")
      tfMP1.Text = If(day.mMorningReadings(0).mPulse > 0, Str(day.mMorningReadings(0).mPulse), "")

      // Morning Mesure 2
      tfMS2.Text = If(day.mMorningReadings(1).mSystolic > 0, Str(day.mMorningReadings(1).mSystolic), "")
      tfMD2.Text = If(day.mMorningReadings(1).mDiastolic > 0, Str(day.mMorningReadings(1).mDiastolic), "")
      tfMP2.Text = If(day.mMorningReadings(1).mPulse > 0, Str(day.mMorningReadings(1).mPulse), "")

      // Morning Mesure 3
      tfMS3.Text = If(day.mMorningReadings(2).mSystolic > 0, Str(day.mMorningReadings(2).mSystolic), "")
      tfMD3.Text = If(day.mMorningReadings(2).mDiastolic > 0, Str(day.mMorningReadings(2).mDiastolic), "")
      tfMP3.Text = If(day.mMorningReadings(2).mPulse > 0, Str(day.mMorningReadings(2).mPulse), "")

      // Evening Mesure 1
      tfES1.Text = If(day.mEveningReadings(0).mSystolic > 0, Str(day.mEveningReadings(0).mSystolic), "")
      tfED1.Text = If(day.mEveningReadings(0).mDiastolic > 0, Str(day.mEveningReadings(0).mDiastolic), "")
      tfEP1.Text = If(day.mEveningReadings(0).mPulse > 0, Str(day.mEveningReadings(0).mPulse), "")

      // Evening Mesure 2
      tfES2.Text = If(day.mEveningReadings(1).mSystolic > 0, Str(day.mEveningReadings(1).mSystolic), "")
      tfED2.Text = If(day.mEveningReadings(1).mDiastolic > 0, Str(day.mEveningReadings(1).mDiastolic), "")
      tfEP2.Text = If(day.mEveningReadings(1).mPulse > 0, Str(day.mEveningReadings(1).mPulse), "")

      // Evening Mesure 3
      tfES3.Text = If(day.mEveningReadings(2).mSystolic > 0, Str(day.mEveningReadings(2).mSystolic), "")
      tfED3.Text = If(day.mEveningReadings(2).mDiastolic > 0, Str(day.mEveningReadings(2).mDiastolic), "")
      tfEP3.Text = If(day.mEveningReadings(2).mPulse > 0, Str(day.mEveningReadings(2).mPulse), "")
    End Sub
  #tag EndMethod

  #tag Method, Flags = &h0
    Sub SaveUIToDay(dayIndex As Integer)
      If DataManager.CurrentSession = Nil Then Return
      Var day As DayMeasurement = DataManager.CurrentSession.mDays(dayIndex)

      day.mDate = DateTime.Now

      // Morning
      day.mMorningReadings(0).mSystolic = Val(tfMS1.Text)
      day.mMorningReadings(0).mDiastolic = Val(tfMD1.Text)
      day.mMorningReadings(0).mPulse = Val(tfMP1.Text)

      day.mMorningReadings(1).mSystolic = Val(tfMS2.Text)
      day.mMorningReadings(1).mDiastolic = Val(tfMD2.Text)
      day.mMorningReadings(1).mPulse = Val(tfMP2.Text)

      day.mMorningReadings(2).mSystolic = Val(tfMS3.Text)
      day.mMorningReadings(2).mDiastolic = Val(tfMD3.Text)
      day.mMorningReadings(2).mPulse = Val(tfMP3.Text)

      // Evening
      day.mEveningReadings(0).mSystolic = Val(tfES1.Text)
      day.mEveningReadings(0).mDiastolic = Val(tfED1.Text)
      day.mEveningReadings(0).mPulse = Val(tfEP1.Text)

      day.mEveningReadings(1).mSystolic = Val(tfES2.Text)
      day.mEveningReadings(1).mDiastolic = Val(tfED2.Text)
      day.mEveningReadings(1).mPulse = Val(tfEP2.Text)

      day.mEveningReadings(2).mSystolic = Val(tfES3.Text)
      day.mEveningReadings(2).mDiastolic = Val(tfED3.Text)
      day.mEveningReadings(2).mPulse = Val(tfEP3.Text)
    End Sub
  #tag EndMethod

  #tag Method, Flags = &h0
    Sub UpdateAverages()
      Var mSys As String = DataManager.FormatAverage(DataManager.MorningAverageSys())
      Var mDia As String = DataManager.FormatAverage(DataManager.MorningAverageDia())
      lblAvgMatin.Text = "Matin : " + mSys + " / " + mDia + " mmHg"

      Var eSys As String = DataManager.FormatAverage(DataManager.EveningAverageSys())
      Var eDia As String = DataManager.FormatAverage(DataManager.EveningAverageDia())
      lblAvgSoir.Text = "Soir : " + eSys + " / " + eDia + " mmHg"

      Var gSys As Double = DataManager.GeneralAverageSys()
      Var gDia As Double = DataManager.GeneralAverageDia()
      lblAvgGeneral.Text = "Générale : " + DataManager.FormatAverage(gSys) + " / " + DataManager.FormatAverage(gDia) + " mmHg"

      If gSys > 0 And gDia > 0 Then
        If gSys < 135 And gDia < 85 Then
          lblStatus.Text = "Normal (< 135/85)"
          lblStatus.TextColor = &h008000
        Else
          lblStatus.Text = "Élevée (objectif < 135/85)"
          lblStatus.TextColor = &hCC0000
        End If
      Else
        lblStatus.Text = "Objectif : < 135/85 mmHg"
        lblStatus.TextColor = Color.Black
      End If
    End Sub
  #tag EndMethod

  // === Event Handlers ===

  #tag EventHandler
    Sub segDay.ValueChanged()
      LoadDayToUI(segDay.SelectedSegment)
    End Sub
  #tag EndEventHandler

  #tag EventHandler
    Sub btnSave.Pressed()
      SaveUIToDay(segDay.SelectedSegment)
      DataManager.SaveData
      UpdateAverages
    End Sub
  #tag EndEventHandler

  // === Controls ===

  #tag Control
    Begin MobileSegmentedControl segDay
      Left            =   10
      Top             =   10
      Width           =   300
      Height          =   30
      LockLeft        =   True
      LockTop         =   True
      LockRight       =   True
    End
  #tag EndControl

  // --- MATIN header ---
  #tag Control
    Begin MobileLabel lblMatinHeader
      Left            =   10
      Top             =   50
      Width           =   300
      Height          =   20
      Text            =   "MATIN — Avant petit-déjeuner"
      Bold            =   True
      TextColor       =   &h1A5276
    End
  #tag EndControl

  // Column headers
  #tag Control
    Begin MobileLabel lblHdrS
      Left            =   90
      Top             =   72
      Width           =   70
      Text            =   "SYS"
      TextAlignment   =   1
      Bold            =   True
      FontSize        =   12
    End
  #tag EndControl
  #tag Control
    Begin MobileLabel lblHdrD
      Left            =   165
      Top             =   72
      Width           =   70
      Text            =   "DIA"
      TextAlignment   =   1
      Bold            =   True
      FontSize        =   12
    End
  #tag EndControl
  #tag Control
    Begin MobileLabel lblHdrP
      Left            =   240
      Top             =   72
      Width           =   70
      Text            =   "Pouls"
      TextAlignment   =   1
      Bold            =   True
      FontSize        =   12
    End
  #tag EndControl

  // Morning row 1
  #tag Control
    Begin MobileLabel lblM1
      Left            =   10
      Top             =   95
      Width           =   75
      Text            =   "Mesure 1"
      FontSize        =   13
    End
  #tag EndControl
  #tag Control
    Begin MobileTextField tfMS1
      Left            =   90
      Top             =   90
      Width           =   65
      Height          =   30
      KeyboardType    =   1
      Hint            =   "SYS"
    End
  #tag EndControl
  #tag Control
    Begin MobileTextField tfMD1
      Left            =   165
      Top             =   90
      Width           =   65
      Height          =   30
      KeyboardType    =   1
      Hint            =   "DIA"
    End
  #tag EndControl
  #tag Control
    Begin MobileTextField tfMP1
      Left            =   240
      Top             =   90
      Width           =   65
      Height          =   30
      KeyboardType    =   1
      Hint            =   "Pouls"
    End
  #tag EndControl

  // Morning row 2
  #tag Control
    Begin MobileLabel lblM2
      Left            =   10
      Top             =   130
      Width           =   75
      Text            =   "Mesure 2"
      FontSize        =   13
    End
  #tag EndControl
  #tag Control
    Begin MobileTextField tfMS2
      Left            =   90
      Top             =   125
      Width           =   65
      Height          =   30
      KeyboardType    =   1
    End
  #tag EndControl
  #tag Control
    Begin MobileTextField tfMD2
      Left            =   165
      Top             =   125
      Width           =   65
      Height          =   30
      KeyboardType    =   1
    End
  #tag EndControl
  #tag Control
    Begin MobileTextField tfMP2
      Left            =   240
      Top             =   125
      Width           =   65
      Height          =   30
      KeyboardType    =   1
    End
  #tag EndControl

  // Morning row 3
  #tag Control
    Begin MobileLabel lblM3
      Left            =   10
      Top             =   165
      Width           =   75
      Text            =   "Mesure 3"
      FontSize        =   13
    End
  #tag EndControl
  #tag Control
    Begin MobileTextField tfMS3
      Left            =   90
      Top             =   160
      Width           =   65
      Height          =   30
      KeyboardType    =   1
    End
  #tag EndControl
  #tag Control
    Begin MobileTextField tfMD3
      Left            =   165
      Top             =   160
      Width           =   65
      Height          =   30
      KeyboardType    =   1
    End
  #tag EndControl
  #tag Control
    Begin MobileTextField tfMP3
      Left            =   240
      Top             =   160
      Width           =   65
      Height          =   30
      KeyboardType    =   1
    End
  #tag EndControl

  // --- SOIR header ---
  #tag Control
    Begin MobileLabel lblSoirHeader
      Left            =   10
      Top             =   200
      Width           =   300
      Height          =   20
      Text            =   "SOIR — Avant le coucher"
      Bold            =   True
      TextColor       =   &h1A5276
    End
  #tag EndControl

  // Evening row 1
  #tag Control
    Begin MobileLabel lblE1
      Left            =   10
      Top             =   230
      Width           =   75
      Text            =   "Mesure 1"
      FontSize        =   13
    End
  #tag EndControl
  #tag Control
    Begin MobileTextField tfES1
      Left            =   90
      Top             =   225
      Width           =   65
      Height          =   30
      KeyboardType    =   1
    End
  #tag EndControl
  #tag Control
    Begin MobileTextField tfED1
      Left            =   165
      Top             =   225
      Width           =   65
      Height          =   30
      KeyboardType    =   1
    End
  #tag EndControl
  #tag Control
    Begin MobileTextField tfEP1
      Left            =   240
      Top             =   225
      Width           =   65
      Height          =   30
      KeyboardType    =   1
    End
  #tag EndControl

  // Evening row 2
  #tag Control
    Begin MobileLabel lblE2
      Left            =   10
      Top             =   265
      Width           =   75
      Text            =   "Mesure 2"
      FontSize        =   13
    End
  #tag EndControl
  #tag Control
    Begin MobileTextField tfES2
      Left            =   90
      Top             =   260
      Width           =   65
      Height          =   30
      KeyboardType    =   1
    End
  #tag EndControl
  #tag Control
    Begin MobileTextField tfED2
      Left            =   165
      Top             =   260
      Width           =   65
      Height          =   30
      KeyboardType    =   1
    End
  #tag EndControl
  #tag Control
    Begin MobileTextField tfEP2
      Left            =   240
      Top             =   260
      Width           =   65
      Height          =   30
      KeyboardType    =   1
    End
  #tag EndControl

  // Evening row 3
  #tag Control
    Begin MobileLabel lblE3
      Left            =   10
      Top             =   300
      Width           =   75
      Text            =   "Mesure 3"
      FontSize        =   13
    End
  #tag EndControl
  #tag Control
    Begin MobileTextField tfES3
      Left            =   90
      Top             =   295
      Width           =   65
      Height          =   30
      KeyboardType    =   1
    End
  #tag EndControl
  #tag Control
    Begin MobileTextField tfED3
      Left            =   165
      Top             =   295
      Width           =   65
      Height          =   30
      KeyboardType    =   1
    End
  #tag EndControl
  #tag Control
    Begin MobileTextField tfEP3
      Left            =   240
      Top             =   295
      Width           =   65
      Height          =   30
      KeyboardType    =   1
    End
  #tag EndControl

  // --- Averages ---
  #tag Control
    Begin MobileLabel lblAvgTitle
      Left            =   10
      Top             =   340
      Width           =   300
      Text            =   "Moyennes de la session"
      Bold            =   True
      FontSize        =   15
      TextColor       =   &h1A5276
    End
  #tag EndControl
  #tag Control
    Begin MobileLabel lblAvgMatin
      Left            =   10
      Top             =   365
      Width           =   300
      Text            =   "Matin : — / — mmHg"
      FontSize        =   13
    End
  #tag EndControl
  #tag Control
    Begin MobileLabel lblAvgSoir
      Left            =   10
      Top             =   388
      Width           =   300
      Text            =   "Soir : — / — mmHg"
      FontSize        =   13
    End
  #tag EndControl
  #tag Control
    Begin MobileLabel lblAvgGeneral
      Left            =   10
      Top             =   415
      Width           =   300
      Text            =   "Générale : — / — mmHg"
      Bold            =   True
      FontSize        =   15
    End
  #tag EndControl
  #tag Control
    Begin MobileLabel lblStatus
      Left            =   10
      Top             =   442
      Width           =   300
      Text            =   "Objectif : < 135/85 mmHg"
      FontSize        =   12
    End
  #tag EndControl

  // Save button
  #tag Control
    Begin MobileButton btnSave
      Left            =   10
      Top             =   475
      Width           =   300
      Height          =   40
      Caption         =   "Sauvegarder"
    End
  #tag EndControl

End Class
#tag EndMobileScreen
