#tag Class
Protected Class ProfilScreen
  Inherits MobileScreen

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
    Sub SaveUIToProfile()
      If DataManager.CurrentProfile = Nil Then Return
      DataManager.CurrentProfile.mLastName = tfNom.Text
      DataManager.CurrentProfile.mFirstName = tfPrenom.Text
      DataManager.CurrentProfile.mMedications = taMeds.Text
    End Sub
  #tag EndMethod

  #tag Method, Flags = &h0
    Sub OnSaveProfilePressed()
      SaveUIToProfile
      DataManager.SaveData
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

  // --- Properties: controls to link in IDE ---

  #tag Property, Flags = &h0
    tfNom As MobileTextField
  #tag EndProperty
  #tag Property, Flags = &h0
    tfPrenom As MobileTextField
  #tag EndProperty
  #tag Property, Flags = &h0
    taMeds As MobileTextArea
  #tag EndProperty

End Class
#tag EndClass
