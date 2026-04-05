#tag MobileScreen
Begin MobileScreen MesuresScreen
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
   Begin MobileSegmentedButton SegmentedButton1
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      AutoLayout      =   SegmentedButton1, 1, <Parent>, 1, False, +1.00, 4, 1, *kStdGapCtlToViewH, , True
      AutoLayout      =   SegmentedButton1, 2, <Parent>, 2, False, +1.00, 4, 1, -*kStdGapCtlToViewH, , True
      AutoLayout      =   SegmentedButton1, 3, TopLayoutGuide, 4, False, +1.00, 4, 1, *kStdControlGapV, , True
      AutoLayout      =   SegmentedButton1, 8, , 0, True, +1.00, 4, 1, 29, , True
      ControlCount    =   0
      Enabled         =   True
      Height          =   29
      LastSegmentIndex=   0
      Left            =   20
      LockedInPosition=   False
      Scope           =   0
      SegmentCount    =   0
      Segments        =   "Jour 1\n\nTrue\rJour 2\n\nFalse\rJour 3\n\nFalse"
      SelectedSegmentIndex=   0
      TintColor       =   
      Top             =   73
      Visible         =   True
      Width           =   335
      _ClosingFired   =   False
   End
End
#tag EndMobileScreen

#tag WindowCode
	#tag Event
		Sub Opening()
		  Self.Title = "Mesures"
		  mCurrentDay = 0
		  DataManager.LoadData
		  LoadDayToUI(0)
		  UpdateAverages
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub LoadDayToUI(dayIndex As Integer)
		  If DataManager.CurrentSession = Nil Then Return
		  Var day As DayMeasurement = DataManager.CurrentSession.mDays(dayIndex)
		  
		  SetFieldValue(tfMS1, day.mMorningReadings(0).mSystolic)
		  SetFieldValue(tfMD1, day.mMorningReadings(0).mDiastolic)
		  SetFieldValue(tfMP1, day.mMorningReadings(0).mPulse)
		  
		  SetFieldValue(tfMS2, day.mMorningReadings(1).mSystolic)
		  SetFieldValue(tfMD2, day.mMorningReadings(1).mDiastolic)
		  SetFieldValue(tfMP2, day.mMorningReadings(1).mPulse)
		  
		  SetFieldValue(tfMS3, day.mMorningReadings(2).mSystolic)
		  SetFieldValue(tfMD3, day.mMorningReadings(2).mDiastolic)
		  SetFieldValue(tfMP3, day.mMorningReadings(2).mPulse)
		  
		  SetFieldValue(tfES1, day.mEveningReadings(0).mSystolic)
		  SetFieldValue(tfED1, day.mEveningReadings(0).mDiastolic)
		  SetFieldValue(tfEP1, day.mEveningReadings(0).mPulse)
		  
		  SetFieldValue(tfES2, day.mEveningReadings(1).mSystolic)
		  SetFieldValue(tfED2, day.mEveningReadings(1).mDiastolic)
		  SetFieldValue(tfEP2, day.mEveningReadings(1).mPulse)
		  
		  SetFieldValue(tfES3, day.mEveningReadings(2).mSystolic)
		  SetFieldValue(tfED3, day.mEveningReadings(2).mDiastolic)
		  SetFieldValue(tfEP3, day.mEveningReadings(2).mPulse)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub OnDayChanged()
		  // Called when segDay.ValueChanged
		  SaveUIToDay(mCurrentDay)
		  mCurrentDay = segDay.SelectedSegment
		  LoadDayToUI(mCurrentDay)
		  UpdateAverages
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub OnSavePressed()
		  SaveUIToDay(mCurrentDay)
		  DataManager.SaveData
		  UpdateAverages
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SaveUIToDay(dayIndex As Integer)
		  If DataManager.CurrentSession = Nil Then Return
		  Var day As DayMeasurement = DataManager.CurrentSession.mDays(dayIndex)
		  day.mDate = DateTime.Now
		  
		  day.mMorningReadings(0).mSystolic = Val(tfMS1.Text)
		  day.mMorningReadings(0).mDiastolic = Val(tfMD1.Text)
		  day.mMorningReadings(0).mPulse = Val(tfMP1.Text)
		  
		  day.mMorningReadings(1).mSystolic = Val(tfMS2.Text)
		  day.mMorningReadings(1).mDiastolic = Val(tfMD2.Text)
		  day.mMorningReadings(1).mPulse = Val(tfMP2.Text)
		  
		  day.mMorningReadings(2).mSystolic = Val(tfMS3.Text)
		  day.mMorningReadings(2).mDiastolic = Val(tfMD3.Text)
		  day.mMorningReadings(2).mPulse = Val(tfMP3.Text)
		  
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

	#tag Method, Flags = &h21
		Private Sub SetFieldValue(field As MobileTextField, val As Integer)
		  If val > 0 Then
		    field.Text = Str(val)
		  Else
		    field.Text = ""
		  End If
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
		  lblAvgGeneral.Text = "Generale : " + DataManager.FormatAverage(gSys) + " / " + DataManager.FormatAverage(gDia) + " mmHg"
		  
		  If gSys > 0 And gDia > 0 Then
		    If gSys < 135 And gDia < 85 Then
		      lblStatus.Text = "Normal (< 135/85)"
		      lblStatus.TextColor = Color.Green
		    Else
		      lblStatus.Text = "Elevee (objectif < 135/85)"
		      lblStatus.TextColor = Color.Red
		    End If
		  Else
		    lblStatus.Text = "Objectif : < 135/85 mmHg"
		    lblStatus.TextColor = Color.Black
		  End If
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		lblAvgGeneral As MobileLabel
	#tag EndProperty

	#tag Property, Flags = &h0
		lblAvgMatin As MobileLabel
	#tag EndProperty

	#tag Property, Flags = &h0
		lblAvgSoir As MobileLabel
	#tag EndProperty

	#tag Property, Flags = &h0
		lblStatus As MobileLabel
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCurrentDay As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		segDay As MobileSegmentedControl
	#tag EndProperty

	#tag Property, Flags = &h0
		tfED1 As MobileTextField
	#tag EndProperty

	#tag Property, Flags = &h0
		tfED2 As MobileTextField
	#tag EndProperty

	#tag Property, Flags = &h0
		tfED3 As MobileTextField
	#tag EndProperty

	#tag Property, Flags = &h0
		tfEP1 As MobileTextField
	#tag EndProperty

	#tag Property, Flags = &h0
		tfEP2 As MobileTextField
	#tag EndProperty

	#tag Property, Flags = &h0
		tfEP3 As MobileTextField
	#tag EndProperty

	#tag Property, Flags = &h0
		tfES1 As MobileTextField
	#tag EndProperty

	#tag Property, Flags = &h0
		tfES2 As MobileTextField
	#tag EndProperty

	#tag Property, Flags = &h0
		tfES3 As MobileTextField
	#tag EndProperty

	#tag Property, Flags = &h0
		tfMD1 As MobileTextField
	#tag EndProperty

	#tag Property, Flags = &h0
		tfMD2 As MobileTextField
	#tag EndProperty

	#tag Property, Flags = &h0
		tfMD3 As MobileTextField
	#tag EndProperty

	#tag Property, Flags = &h0
		tfMP1 As MobileTextField
	#tag EndProperty

	#tag Property, Flags = &h0
		tfMP2 As MobileTextField
	#tag EndProperty

	#tag Property, Flags = &h0
		tfMP3 As MobileTextField
	#tag EndProperty

	#tag Property, Flags = &h0
		tfMS1 As MobileTextField
	#tag EndProperty

	#tag Property, Flags = &h0
		tfMS2 As MobileTextField
	#tag EndProperty

	#tag Property, Flags = &h0
		tfMS3 As MobileTextField
	#tag EndProperty


#tag EndWindowCode

