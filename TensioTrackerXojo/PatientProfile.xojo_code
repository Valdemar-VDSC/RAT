#tag Class
Protected Class PatientProfile
	#tag Method, Flags = &h0
		Sub Constructor()
		  mFirstName = ""
		  mLastName = ""
		  mBirthDate = Nil
		  mMedications = ""
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FromJSON(j As JSONItem)
		  If j.HasName("firstName") Then mFirstName = j.Value("firstName").StringValue
		  If j.HasName("lastName") Then mLastName = j.Value("lastName").StringValue
		  If j.HasName("medications") Then mMedications = j.Value("medications").StringValue
		  If j.HasName("birthDate") Then
		    Var dateStr As String = j.Value("birthDate").StringValue
		    If dateStr <> "" Then
		      mBirthDate = DateTime.FromString(dateStr)
		    End If
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FullName() As String
		  Var n As String = mLastName + " " + mFirstName
		  Return n.Trim
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToJSON() As JSONItem
		  Var j As New JSONItem
		  j.Value("firstName") = mFirstName
		  j.Value("lastName") = mLastName
		  j.Value("medications") = mMedications
		  If mBirthDate <> Nil Then
		    j.Value("birthDate") = mBirthDate.SQLDateTime
		  Else
		    j.Value("birthDate") = ""
		  End If
		  Return j
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		mBirthDate As DateTime
	#tag EndProperty

	#tag Property, Flags = &h0
		mFirstName As String
	#tag EndProperty

	#tag Property, Flags = &h0
		mLastName As String
	#tag EndProperty

	#tag Property, Flags = &h0
		mMedications As String
	#tag EndProperty


End Class
#tag EndClass
