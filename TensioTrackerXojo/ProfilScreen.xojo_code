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


	#tag Property, Flags = &h0
		taMeds As MobileTextArea
	#tag EndProperty

	#tag Property, Flags = &h0
		tfNom As MobileTextField
	#tag EndProperty

	#tag Property, Flags = &h0
		tfPrenom As MobileTextField
	#tag EndProperty


#tag EndWindowCode

