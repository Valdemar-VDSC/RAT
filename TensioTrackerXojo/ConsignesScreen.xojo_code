#tag MobileScreen
Begin MobileScreen ConsignesScreen
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
   Begin MobileTextArea txtConsigne
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      Alignment       =   0
      AllowAutoCorrection=   False
      AllowSpellChecking=   False
      AutoCapitalizationType=   0
      AutoLayout      =   txtConsigne, 1, <Parent>, 1, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   txtConsigne, 2, <Parent>, 2, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   txtConsigne, 3, TopLayoutGuide, 4, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   txtConsigne, 4, BottomLayoutGuide, 4, False, +1.00, 4, 1, 0, , True
      BorderStyle     =   0
      ControlCount    =   0
      Enabled         =   True
      Height          =   747
      Left            =   0
      LockedInPosition=   False
      maximumCharactersAllowed=   0
      ReadOnly        =   False
      Scope           =   0
      SelectedText    =   ""
      SelectionLength =   0
      SelectionStart  =   0
      Text            =   "Untitled"
      TextColor       =   &c000000
      TextFont        =   ""
      TextSize        =   0
      TintColor       =   
      Top             =   65
      Visible         =   True
      Width           =   375
      _ClosingFired   =   False
   End
End
#tag EndMobileScreen

#tag WindowCode
	#tag Event
		Sub Opening()
		  Self.Title = "Consignes"
		End Sub
	#tag EndEvent

	#tag Event
		Sub Resized()
		  If txtConsignes <> Nil Then
		    txtConsignes.Width = Self.Width
		    txtConsignes.Height = Self.Height
		  End If
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub PopulateConsignes()
		  Var t As String
		  
		  t = "CONSIGNES DE MESURE" + EndOfLine
		  t = t + "===========================================" + EndOfLine + EndOfLine
		  
		  t = t + "AVANT LA MESURE" + EndOfLine
		  t = t + "- Pas de tabac, cafeine, nourriture, exercice 30 min avant" + EndOfLine
		  t = t + "- Etre seul dans un endroit calme" + EndOfLine
		  t = t + "- Temperature confortable" + EndOfLine
		  t = t + "- Se reposer 3 a 5 min avant la premiere mesure" + EndOfLine
		  t = t + "- Ne pas parler ni utiliser d'ecran" + EndOfLine + EndOfLine
		  
		  t = t + "POSITION" + EndOfLine
		  t = t + "- Dos soutenu (appuye contre le dossier)" + EndOfLine
		  t = t + "- Bras nu sur la table, brassard a mi-bras" + EndOfLine
		  t = t + "- Pieds a plat sur le sol" + EndOfLine
		  t = t + "- Taille de brassard adaptee" + EndOfLine + EndOfLine
		  
		  t = t + "MATERIEL" + EndOfLine
		  t = t + "- Tensiometre valide avec brassard au bras" + EndOfLine
		  t = t + "- www.stridebp.org/fr/" + EndOfLine + EndOfLine
		  
		  t = t + "PROTOCOLE" + EndOfLine
		  t = t + "===========================================" + EndOfLine
		  t = t + "- 3 jours consecutifs" + EndOfLine
		  t = t + "- 3 mesures le matin (avant petit-dejeuner)" + EndOfLine
		  t = t + "- 3 mesures le soir (avant le coucher)" + EndOfLine
		  t = t + "- Toujours le meme bras" + EndOfLine
		  t = t + "- 1 minute entre chaque mesure" + EndOfLine + EndOfLine
		  
		  t = t + "OBJECTIF TENSIONNEL" + EndOfLine
		  t = t + "< 135 / 85 mmHg en automesure." + EndOfLine
		  t = t + "Consultez votre medecin."
		  
		  txtConsignes.Text = t
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		txtConsignes As MobileTextArea
	#tag EndProperty


#tag EndWindowCode

#tag Events txtConsigne
	#tag Event
		Sub Opening()
		  PopulateConsignes
		End Sub
	#tag EndEvent
#tag EndEvents
