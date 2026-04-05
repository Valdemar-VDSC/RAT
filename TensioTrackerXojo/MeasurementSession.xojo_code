#tag Class
Protected Class MeasurementSession

  #tag Method, Flags = &h0
    Sub Constructor()
      mCreatedAt = DateTime.Now

      For i As Integer = 0 To 2
        mDays.Add(New DayMeasurement)
      Next
    End Sub
  #tag EndMethod

  #tag Method, Flags = &h0
    Function ToJSON() As JSONItem
      Var j As New JSONItem
      j.Value("createdAt") = mCreatedAt.SQLDateTime

      Var daysArr As New JSONItem
      For Each d As DayMeasurement In mDays
        daysArr.Add(d.ToJSON)
      Next
      j.Value("days") = daysArr

      Return j
    End Function
  #tag EndMethod

  #tag Method, Flags = &h0
    Sub FromJSON(j As JSONItem)
      Var dateStr As String = j.Value("createdAt").StringValue
      If dateStr <> "" Then
        mCreatedAt = DateTime.FromString(dateStr)
      End If

      Var daysArr As JSONItem = j.Value("days")
      For i As Integer = 0 To daysArr.LastRowIndex
        If i <= 2 Then
          mDays(i).FromJSON(daysArr.ChildAt(i))
        End If
      Next
    End Sub
  #tag EndMethod

  #tag Property, Flags = &h0
    mCreatedAt As DateTime
  #tag EndProperty

  #tag Property, Flags = &h0
    mDays() As DayMeasurement
  #tag EndProperty

End Class
#tag EndClass
