#tag Class
Protected Class BloodPressureReading
	#tag Method, Flags = &h0
		Sub Constructor()
		  mSystolic = -1
		  mDiastolic = -1
		  mPulse = -1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FromJSON(j As JSONItem)
		  If j.HasName("systolic") Then mSystolic = j.Value("systolic").IntegerValue
		  If j.HasName("diastolic") Then mDiastolic = j.Value("diastolic").IntegerValue
		  If j.HasName("pulse") Then mPulse = j.Value("pulse").IntegerValue
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsComplete() As Boolean
		  Return mSystolic > 0 And mDiastolic > 0 And mPulse > 0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToJSON() As JSONItem
		  Var j As New JSONItem
		  j.Value("systolic") = mSystolic
		  j.Value("diastolic") = mDiastolic
		  j.Value("pulse") = mPulse
		  Return j
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		mDiastolic As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		mPulse As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		mSystolic As Integer
	#tag EndProperty


End Class
#tag EndClass
