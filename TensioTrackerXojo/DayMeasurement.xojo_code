#tag Class
Protected Class DayMeasurement

  #tag Method, Flags = &h0
    Sub Constructor()
      mDate = Nil

      // 3 morning readings
      For i As Integer = 0 To 2
        mMorningReadings.Add(New BloodPressureReading)
      Next

      // 3 evening readings
      For i As Integer = 0 To 2
        mEveningReadings.Add(New BloodPressureReading)
      Next
    End Sub
  #tag EndMethod

  #tag Method, Flags = &h0
    Function ToJSON() As JSONItem
      Var j As New JSONItem

      If mDate <> Nil Then
        j.Value("date") = mDate.SQLDateTime
      Else
        j.Value("date") = ""
      End If

      Var morningArr As New JSONItem
      For Each r As BloodPressureReading In mMorningReadings
        morningArr.Add(r.ToJSON)
      Next
      j.Value("morning") = morningArr

      Var eveningArr As New JSONItem
      For Each r As BloodPressureReading In mEveningReadings
        eveningArr.Add(r.ToJSON)
      Next
      j.Value("evening") = eveningArr

      Return j
    End Function
  #tag EndMethod

  #tag Method, Flags = &h0
    Sub FromJSON(j As JSONItem)
      Var dateStr As String = j.Value("date").StringValue
      If dateStr <> "" Then
        mDate = DateTime.FromString(dateStr)
      End If

      Var morningArr As JSONItem = j.Value("morning")
      For i As Integer = 0 To morningArr.LastRowIndex
        If i <= 2 Then
          mMorningReadings(i).FromJSON(morningArr.ChildAt(i))
        End If
      Next

      Var eveningArr As JSONItem = j.Value("evening")
      For i As Integer = 0 To eveningArr.LastRowIndex
        If i <= 2 Then
          mEveningReadings(i).FromJSON(eveningArr.ChildAt(i))
        End If
      Next
    End Sub
  #tag EndMethod

  #tag Property, Flags = &h0
    mDate As DateTime
  #tag EndProperty

  #tag Property, Flags = &h0
    mMorningReadings() As BloodPressureReading
  #tag EndProperty

  #tag Property, Flags = &h0
    mEveningReadings() As BloodPressureReading
  #tag EndProperty

End Class
#tag EndClass
