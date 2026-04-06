#tag Module
Protected Module DataManager
	#tag Method, Flags = &h21
		Private Function ComputeAverage(period As String, metric As String) As Double
		  Var total As Double = 0
		  Var count As Integer = 0
		  For Each d As DayMeasurement In CurrentSession.mDays
		    Var readings() As BloodPressureReading
		    If period = "morning" Then
		      readings = d.mMorningReadings
		    Else
		      readings = d.mEveningReadings
		    End If
		    For Each r As BloodPressureReading In readings
		      Var val As Integer
		      If metric = "sys" Then
		        val = r.mSystolic
		      Else
		        val = r.mDiastolic
		      End If
		      If val > 0 Then
		        total = total + val
		        count = count + 1
		      End If
		    Next
		  Next
		  If count = 0 Then Return -1
		  Return total / count
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function DataFilePath() As FolderItem
		  Var appSupport As FolderItem = SpecialFolder.Documents
		  If appSupport = Nil Then Return Nil
		  Return appSupport.Child("tensiotracker_data.json")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function EveningAverageDia() As Double
		  Return ComputeAverage("evening", "dia")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function EveningAverageSys() As Double
		  Return ComputeAverage("evening", "sys")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FormatAverage(val As Double) As String
		  If val < 0 Then Return "—"
		  Return Str(Round(val))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GeneralAverageDia() As Double
		  Var total As Double = 0
		  Var count As Integer = 0
		  For Each d As DayMeasurement In CurrentSession.mDays
		    For Each r As BloodPressureReading In d.mMorningReadings
		      If r.mDiastolic > 0 Then
		        total = total + r.mDiastolic
		        count = count + 1
		      End If
		    Next
		    For Each r As BloodPressureReading In d.mEveningReadings
		      If r.mDiastolic > 0 Then
		        total = total + r.mDiastolic
		        count = count + 1
		      End If
		    Next
		  Next
		  If count = 0 Then Return -1
		  Return total / count
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GeneralAverageSys() As Double
		  Var total As Double = 0
		  Var count As Integer = 0
		  For Each d As DayMeasurement In CurrentSession.mDays
		    For Each r As BloodPressureReading In d.mMorningReadings
		      If r.mSystolic > 0 Then
		        total = total + r.mSystolic
		        count = count + 1
		      End If
		    Next
		    For Each r As BloodPressureReading In d.mEveningReadings
		      If r.mSystolic > 0 Then
		        total = total + r.mSystolic
		        count = count + 1
		      End If
		    Next
		  Next
		  If count = 0 Then Return -1
		  Return total / count
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GeneratePDFPicture() As Picture
		  // A4 dimensions in points (scaled x2 for retina)
		  Const kPageW = 1190
		  Const kPageH = 1684
		  Const kMargin = 56
		  
		  Var p As New Picture(kPageW, kPageH)
		  Var pg As Graphics = p.Graphics
		  
		  // Colors
		  Var blueBorder, greenTitle, greenDark, darkBlue, lightBlue, lightGreen  As Color
		  blueBorder=&c3366BF
		  greenTitle = &c008033
		  greenDark = &c007326
		  darkBlue = &c264080
		  lightBlue = &cD9E6FF
		  lightGreen = &cD9FFD9
		  
		  Var contentW As Double = kPageW - 2 * kMargin
		  Var y As Double = kMargin
		  
		  pg.DrawingColor = Color.White
		  pg.FillRectangle(0, 0, kPageW, kPageH)
		  
		  // --- 1. Patient Info Box ---
		  pg.DrawingColor = blueBorder
		  pg.PenSize = 1.5
		  pg.DrawRectangle(kMargin, y, contentW, 58)
		  
		  pg.DrawingColor = Color.Black
		  pg.Font.Size = 9
		  pg.Font.BoldSystemFont = False
		  Var px As Double = kMargin + 8
		  Var py As Double = y + 10
		  
		  pg.DrawText("Nom : ", px, py)
		  Var nameX As Double = px + pg.TextWidth("Nom : ")
		  If CurrentProfile.mLastName <> "" Then
		    pg.Bold = True
		    pg.DrawText(CurrentProfile.mLastName, nameX, py)
		    pg.Bold = False
		  End If
		  
		  Var prenomLabel As String = "   Prénom : "
		  Var prenomX As Double = nameX + pg.TextWidth(CurrentProfile.mLastName) + pg.TextWidth(prenomLabel)
		  pg.DrawText(prenomLabel, nameX + pg.TextWidth(CurrentProfile.mLastName), py)
		  If CurrentProfile.mFirstName <> "" Then
		    pg.Bold = True
		    pg.DrawText(CurrentProfile.mFirstName, prenomX, py)
		    pg.Bold = False
		  End If
		  
		  py = py + 16
		  pg.DrawText("Période du relevé : du ", px, py)
		  Var periodX As Double = px + pg.TextWidth("Période du relevé : du ")
		  Var d1 As DayMeasurement = CurrentSession.mDays(0)
		  Var d3 As DayMeasurement = CurrentSession.mDays(2)
		  If d1.mDate <> Nil Then
		    pg.Bold = True
		    pg.DrawText(d1.mDate.ToString(DateTime.FormatStyles.Short, DateTime.FormatStyles.None), periodX, py)
		    pg.Bold = False
		  Else
		    pg.DrawText("……………", periodX, py)
		  End If
		  
		  py = py + 16
		  pg.DrawText("Traitement : ", px, py)
		  Var treatX As Double = px + pg.TextWidth("Traitement : ")
		  If CurrentProfile.mMedications <> "" Then
		    pg.Bold = True
		    Var medText As String = CurrentProfile.mMedications.ReplaceAll(EndOfLine, ", ")
		    pg.DrawText(medText, treatX, py)
		    pg.Bold = False
		  End If
		  
		  y = y + 62
		  
		  // --- 2. Important Notice ---
		  pg.FontSize = 9
		  pg.DrawingColor = darkBlue
		  pg.Bold = True
		  pg.DrawText("Important : Montrer ce document", kMargin + 12, y)
		  y = y + 14
		  pg.Bold = False
		  pg.DrawText("     - au pharmacien lors de votre venue à l'officine", kMargin + 12, y)
		  y = y + 14
		  pg.DrawText("     - au médecin à la prochaine consultation", kMargin + 12, y)
		  y = y + 18
		  
		  // --- 3. Title Bar ---
		  pg.DrawingColor = greenTitle
		  pg.FillRoundRectangle(kMargin, y, contentW, 30, 4, 4)
		  pg.DrawingColor = Color.White
		  pg.Bold = True
		  pg.FontSize = 15
		  Var titleText As String = "RELEVÉ D'AUTOMESURE TENSIONNELLE"
		  Var titleW As Double = pg.TextWidth(titleText)
		  pg.DrawText(titleText, kMargin + (contentW - titleW) / 2, y + 20)
		  y = y + 36
		  
		  // --- 4. Protocol Bullets ---
		  pg.DrawingColor = Color.Black
		  pg.FontSize = 8.5
		  pg.Bold = False
		  
		  Var bullets() As String
		  bullets.Add("3 mesures consécutives (à quelques minutes d'intervalle) le matin avant de prendre ses médicaments")
		  bullets.Add("3 mesures consécutives (à quelques minutes d'intervalle) le soir entre le dîner et le coucher")
		  bullets.Add("3 jours de suite")
		  
		  For Each bullet As String In bullets
		    pg.DrawText("•  " + bullet, kMargin + 12, y + 10)
		    y = y + 14
		  Next
		  y = y + 6
		  
		  // --- 5. Day Tables ---
		  Var labelColW As Double = 70
		  Var dataColW As Double = (contentW - labelColW) / 6.0
		  Var rowH As Double = 20
		  Var headerH As Double = 22
		  Var subHeaderH As Double = 16
		  
		  For dayIdx As Integer = 0 To 2
		    Var day As DayMeasurement = CurrentSession.mDays(dayIdx)
		    
		    // Jour N header
		    pg.DrawingColor = blueBorder
		    pg.FillRectangle(kMargin, y, contentW, headerH)
		    pg.DrawingColor = Color.White
		    pg.Bold = True
		    pg.FontSize = 11
		    pg.DrawText("Jour " + Str(dayIdx + 1), kMargin + 10, y + 16)
		    
		    // Matin / Soir labels
		    pg.FontSize = 10
		    Var matinLabelW As Double = pg.TextWidth("Matin")
		    Var matinCenterX As Double = kMargin + labelColW + (3 * dataColW - matinLabelW) / 2
		    pg.DrawText("Matin", matinCenterX, y + 16)
		    
		    Var soirLabelW As Double = pg.TextWidth("Soir")
		    Var soirCenterX As Double = kMargin + labelColW + 3 * dataColW + (3 * dataColW - soirLabelW) / 2
		    pg.DrawText("Soir", soirCenterX, y + 16)
		    y = y + headerH
		    
		    // Sub-header
		    pg.DrawingColor = lightBlue
		    pg.FillRectangle(kMargin, y, contentW, subHeaderH)
		    pg.DrawingColor = blueBorder
		    pg.PenSize = 0.5
		    pg.DrawRectangle(kMargin, y, contentW, subHeaderH)
		    
		    pg.DrawingColor = Color.DarkGray
		    pg.Bold = False
		    pg.FontSize = 7.5
		    Var colHeaders() As String = Array("systolique", "diastolique", "pouls")
		    
		    For i As Integer = 0 To 2
		      Var cx As Double = kMargin + labelColW + i * dataColW
		      Var tw As Double = pg.TextWidth(colHeaders(i))
		      pg.DrawText(colHeaders(i), cx + (dataColW - tw) / 2, y + 11)
		      
		      Var cx2 As Double = kMargin + labelColW + 3 * dataColW + i * dataColW
		      pg.DrawText(colHeaders(i), cx2 + (dataColW - tw) / 2, y + 11)
		    Next
		    
		    // Vertical lines in subheader
		    For i As Integer = 0 To 6
		      Var lx As Double = kMargin + labelColW + i * dataColW
		      pg.DrawingColor = blueBorder
		      pg.DrawLine(lx, y, lx, y + subHeaderH)
		    Next
		    y = y + subHeaderH
		    
		    // 3 measurement rows
		    For rowIdx As Integer = 0 To 2
		      If rowIdx Mod 2 = 0 Then
		        pg.DrawingColor = Color.White
		      Else
		        pg.DrawingColor = New Color(&hF7F7F7)
		      End If
		      pg.FillRectangle(kMargin, y, contentW, rowH)
		      
		      pg.DrawingColor = blueBorder
		      pg.PenSize = 0.5
		      pg.DrawRectangle(kMargin, y, contentW, rowH)
		      
		      // Mesure label
		      pg.DrawingColor = darkBlue
		      pg.Bold = True
		      pg.FontSize = 8.5
		      Var mesureLabel As String = "Mesure " + Str(rowIdx + 1)
		      Var mlW As Double = pg.TextWidth(mesureLabel)
		      pg.DrawText(mesureLabel, kMargin + (labelColW - mlW) / 2, y + 14)
		      
		      // Morning values
		      Var mr As BloodPressureReading = day.mMorningReadings(rowIdx)
		      Var mVals() As Integer = Array(mr.mSystolic, mr.mDiastolic, mr.mPulse)
		      pg.FontSize = 10
		      For i As Integer = 0 To 2
		        Var cx As Double = kMargin + labelColW + i * dataColW
		        Var valText As String
		        If mVals(i) > 0 Then
		          pg.DrawingColor = Color.Black
		          pg.Bold = True
		          valText = Str(mVals(i))
		        Else
		          pg.DrawingColor = Color.LightGray
		          pg.Bold = False
		          valText = "– – –"
		        End If
		        Var vw As Double = pg.TextWidth(valText)
		        pg.DrawText(valText, cx + (dataColW - vw) / 2, y + 14)
		      Next
		      
		      // Evening values
		      Var er As BloodPressureReading = day.mEveningReadings(rowIdx)
		      Var eVals() As Integer = Array(er.mSystolic, er.mDiastolic, er.mPulse)
		      For i As Integer = 0 To 2
		        Var cx As Double = kMargin + labelColW + 3 * dataColW + i * dataColW
		        Var valText As String
		        If eVals(i) > 0 Then
		          pg.DrawingColor = Color.Black
		          pg.Bold = True
		          valText = Str(eVals(i))
		        Else
		          pg.DrawingColor = Color.LightGray
		          pg.Bold = False
		          valText = "– – –"
		        End If
		        Var vw As Double = pg.TextWidth(valText)
		        pg.DrawText(valText, cx + (dataColW - vw) / 2, y + 14)
		      Next
		      
		      // Vertical lines
		      pg.DrawingColor = blueBorder
		      pg.PenSize = 0.5
		      For i As Integer = 0 To 6
		        Var lx As Double = kMargin + labelColW + i * dataColW
		        pg.DrawLine(lx, y, lx, y + rowH)
		      Next
		      
		      // Thick separator matin/soir
		      pg.PenSize = 1.5
		      Var midX As Double = kMargin + labelColW + 3 * dataColW
		      pg.DrawLine(midX, y, midX, y + rowH)
		      
		      y = y + rowH
		    Next
		    y = y + 6
		  Next
		  
		  // --- 6. Averages ---
		  Var avgBoxH As Double = 50
		  pg.DrawingColor = lightGreen
		  pg.FillRectangle(kMargin, y, contentW, avgBoxH)
		  pg.DrawingColor = greenDark
		  pg.PenSize = 1.5
		  pg.DrawRectangle(kMargin, y, contentW, avgBoxH)
		  
		  Var avgColW As Double = contentW / 2.0
		  
		  // Moyenne Systolique
		  pg.DrawingColor = Color.Black
		  pg.Bold = True
		  pg.FontSize = 8
		  pg.DrawText("MOYENNE", kMargin + 8, y + 12)
		  pg.DrawText("SYSTOLIQUE *", kMargin + 8, y + 22)
		  
		  Var sysAvg As String = FormatAverage(GeneralAverageSys())
		  pg.DrawingColor = greenDark
		  pg.FontSize = 14
		  pg.Bold = True
		  Var sysW As Double = pg.TextWidth(sysAvg)
		  pg.DrawText(sysAvg, kMargin + (avgColW - sysW) / 2, y + 42)
		  
		  // Separator
		  pg.DrawingColor = greenDark
		  pg.PenSize = 0.5
		  pg.DrawLine(kMargin + avgColW, y + 4, kMargin + avgColW, y + avgBoxH - 4)
		  
		  // Moyenne Diastolique
		  pg.DrawingColor = Color.Black
		  pg.FontSize = 8
		  pg.DrawText("MOYENNE", kMargin + avgColW + 8, y + 12)
		  pg.DrawText("DIASTOLIQUE *", kMargin + avgColW + 8, y + 22)
		  
		  Var diaAvg As String = FormatAverage(GeneralAverageDia())
		  pg.DrawingColor = greenDark
		  pg.FontSize = 14
		  pg.Bold = True
		  Var diaW As Double = pg.TextWidth(diaAvg)
		  pg.DrawText(diaAvg, kMargin + avgColW + (avgColW - diaW) / 2, y + 42)
		  
		  y = y + avgBoxH + 6
		  
		  // --- 7. Footer Note ---
		  pg.DrawingColor = Color.DarkGray
		  pg.FontSize = 7
		  pg.Bold = False
		  pg.DrawText("* additionner toutes les mesures, systoliques ou diastoliques, et diviser par 18", kMargin, y + 8)
		  
		  Return p
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LoadData()
		  CurrentProfile = New PatientProfile
		  CurrentSession = New MeasurementSession
		  
		  Var f As FolderItem = DataFilePath()
		  If f = Nil Or Not f.Exists Then Return
		  
		  Var t As TextInputStream = TextInputStream.Open(f)
		  Var content As String = t.ReadAll
		  t.Close
		  
		  If content = "" Then Return
		  
		  Try
		    Var j As New JSONItem(content)
		    If j.HasName("profile") Then
		      CurrentProfile.FromJSON(j.Value("profile"))
		    End If
		    If j.HasName("currentSession") Then
		      CurrentSession.FromJSON(j.Value("currentSession"))
		    End If
		  Catch e As JSONException
		    // Ignore corrupt data
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function MorningAverageDia() As Double
		  Return ComputeAverage("morning", "dia")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function MorningAverageSys() As Double
		  Return ComputeAverage("morning", "sys")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SaveData()
		  Var j As New JSONItem
		  
		  // Profile
		  j.Value("profile") = CurrentProfile.ToJSON
		  
		  // Session
		  j.Value("currentSession") = CurrentSession.ToJSON
		  
		  Var f As FolderItem = DataFilePath()
		  Var t As TextOutputStream = TextOutputStream.Create(f)
		  t.Write(j.ToString)
		  t.Close
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		CurrentProfile As PatientProfile
	#tag EndProperty

	#tag Property, Flags = &h0
		CurrentSession As MeasurementSession
	#tag EndProperty


End Module
#tag EndModule
