#tag MobileScreen
Begin MobileScreen ProfilScreen
   BackButtonCaption=   ""
   BackgroundColor =   
   Compatibility   =   ""
   ControlCount    =   0
   Device = 7
   HasNavigationBar=   True
   LargeTitleDisplayMode=   2
   Left            =   0
   NavigationBarColor=   
   NavigationBarTextColor=   
   Orientation = 0
   ScaleFactor     =   0.0
   TabBarVisible   =   True
   TabIcon         =   0
   TintColor       =   
   Title           =   "Untitled"
   Top             =   0
   _mTabBarVisible =   False
   Begin MobileLabel lblNomLabel
      Enabled = True
      Height = 20
      Left = 20
      Text = "Nom"
      Top = 75
      Visible = True
      Width = 335
   End
   Begin MobileTextField tfNom
      Enabled = True
      Height = 35
      Left = 20
      Top = 95
      Visible = True
      Width = 335
   End
   Begin MobileLabel lblPrenomLabel
      Enabled = True
      Height = 20
      Left = 20
      Text = "Prenom"
      Top = 140
      Visible = True
      Width = 335
   End
   Begin MobileTextField tfPrenom
      Enabled = True
      Height = 35
      Left = 20
      Top = 160
      Visible = True
      Width = 335
   End
   Begin MobileLabel lblMedsLabel
      Enabled = True
      Height = 20
      Left = 20
      Text = "Medicaments"
      Top = 205
      Visible = True
      Width = 335
   End
   Begin MobileTextArea taMeds
      Enabled = True
      Height = 80
      Left = 20
      Top = 225
      Visible = True
      Width = 335
   End
   Begin MobileButton btnSaveProfile
      Enabled = True
      Height = 40
      Left = 20
      Caption = "Enregistrer"
      Top = 320
      Visible = True
      Width = 335
   End
   Begin MobileButton btnExportPDF
      Enabled = True
      Height = 44
      Left = 20
      Caption = "Exporter le releve en PDF"
      Top = 370
      Visible = True
      Width = 335
   End
   Begin MobileButton btnNewSession
      Enabled = True
      Height = 40
      Left = 20
      Caption = "Nouvelle session"
      Top = 425
      Visible = True
      Width = 335
   End
End
#tag EndMobileScreen

#tag WindowCode
	#tag Event
		Sub Opening()
		  Self.Title = "Profil"
		  DataManager.LoadData
		  LoadProfileToUI
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub LoadProfileToUI()
		  If DataManager.CurrentProfile = Nil Then Return
		  tfNom.Text = DataManager.CurrentProfile.mLastName
		  tfPrenom.Text = DataManager.CurrentProfile.mFirstName
		  taMeds.Text = DataManager.CurrentProfile.mMedications
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub OnExportPressed()
		  SaveUIToProfile
		  DataManager.SaveData
		  
		  Var pic As Picture = DataManager.GeneratePDFPicture()
		  If pic <> Nil Then
		    Var share As New MobileSharingPanel
		    share.AddPicture(pic)
		    share.Show
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub OnNewSessionPressed()
		  DataManager.SaveData
		  DataManager.CurrentSession = New MeasurementSession
		  DataManager.SaveData
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub OnSaveProfilePressed()
		  SaveUIToProfile
		  DataManager.SaveData
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SaveUIToProfile()
		  If DataManager.CurrentProfile = Nil Then Return
		  DataManager.CurrentProfile.mLastName = tfNom.Text
		  DataManager.CurrentProfile.mFirstName = tfPrenom.Text
		  DataManager.CurrentProfile.mMedications = taMeds.Text
		End Sub
	#tag EndMethod



#tag EndWindowCode

#tag Events btnSaveProfile
	#tag Event
		Sub Pressed()
		  OnSaveProfilePressed
		End Sub
	#tag EndEvent
#tag EndEvents

#tag Events btnExportPDF
	#tag Event
		Sub Pressed()
		  OnExportPressed
		End Sub
	#tag EndEvent
#tag EndEvents

#tag Events btnNewSession
	#tag Event
		Sub Pressed()
		  OnNewSessionPressed
		End Sub
	#tag EndEvent
#tag EndEvents

