#tag MobileScreen
Protected Class ProfilScreen
  Inherits MobileScreen

  #tag Event
    Sub Opening()
      Self.Title = "Profil"
      Self.TabIcon = MobileScreen.SystemIconContacts

      DataManager.LoadData
      LoadProfileToUI
    End Sub
  #tag EndEvent

  #tag Method, Flags = &h1
    Private Sub LoadProfileToUI()
      If DataManager.CurrentProfile = Nil Then Return
      tfNom.Text = DataManager.CurrentProfile.mLastName
      tfPrenom.Text = DataManager.CurrentProfile.mFirstName
      taMeds.Text = DataManager.CurrentProfile.mMedications
    End Sub
  #tag EndMethod

  #tag Method, Flags = &h1
    Private Sub SaveUIToProfile()
      If DataManager.CurrentProfile = Nil Then Return
      DataManager.CurrentProfile.mLastName = tfNom.Text
      DataManager.CurrentProfile.mFirstName = tfPrenom.Text
      DataManager.CurrentProfile.mMedications = taMeds.Text
    End Sub
  #tag EndMethod

  // === Event Handlers ===

  #tag EventHandler
    Sub btnSaveProfile.Pressed()
      SaveUIToProfile
      DataManager.SaveData
      MobileMessageBox("Profil enregistré.")
    End Sub
  #tag EndEventHandler

  #tag EventHandler
    Sub btnExportPDF.Pressed()
      SaveUIToProfile
      DataManager.SaveData

      // Generate PDF as image and share
      Var pic As Picture = DataManager.GeneratePDFPicture()
      If pic <> Nil Then
        Var share As New MobileSharingPanel
        share.AddPicture(pic)
        share.Show
      End If
    End Sub
  #tag EndEventHandler

  #tag EventHandler
    Sub btnNewSession.Pressed()
      DataManager.SaveData
      DataManager.CurrentSession = New MeasurementSession
      DataManager.SaveData
      MobileMessageBox("Nouvelle session créée.")
    End Sub
  #tag EndEventHandler

  // === Controls ===

  #tag Control
    Begin MobileLabel lblNomLabel
      Left            =   10
      Top             =   15
      Width           =   300
      Text            =   "Nom"
      FontSize        =   13
      TextColor       =   &h888888
    End
  #tag EndControl
  #tag Control
    Begin MobileTextField tfNom
      Left            =   10
      Top             =   35
      Width           =   300
      Height          =   35
      Hint            =   "Nom de famille"
    End
  #tag EndControl

  #tag Control
    Begin MobileLabel lblPrenomLabel
      Left            =   10
      Top             =   80
      Width           =   300
      Text            =   "Prénom"
      FontSize        =   13
      TextColor       =   &h888888
    End
  #tag EndControl
  #tag Control
    Begin MobileTextField tfPrenom
      Left            =   10
      Top             =   100
      Width           =   300
      Height          =   35
      Hint            =   "Prénom"
    End
  #tag EndControl

  #tag Control
    Begin MobileLabel lblMedsLabel
      Left            =   10
      Top             =   145
      Width           =   300
      Text            =   "Médicaments antihypertenseurs"
      FontSize        =   13
      TextColor       =   &h888888
    End
  #tag EndControl
  #tag Control
    Begin MobileTextArea taMeds
      Left            =   10
      Top             =   165
      Width           =   300
      Height          =   80
      Hint            =   "Médicaments et doses"
    End
  #tag EndControl

  #tag Control
    Begin MobileButton btnSaveProfile
      Left            =   10
      Top             =   260
      Width           =   300
      Height          =   40
      Caption         =   "Enregistrer le profil"
    End
  #tag EndControl

  #tag Control
    Begin MobileButton btnExportPDF
      Left            =   10
      Top             =   310
      Width           =   300
      Height          =   44
      Caption         =   "Exporter le relevé en PDF"
    End
  #tag EndControl

  #tag Control
    Begin MobileButton btnNewSession
      Left            =   10
      Top             =   365
      Width           =   300
      Height          =   40
      Caption         =   "Nouvelle session"
    End
  #tag EndControl

End Class
#tag EndMobileScreen
