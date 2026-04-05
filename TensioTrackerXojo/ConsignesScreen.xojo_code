#tag MobileScreen
Protected Class ConsignesScreen
  Inherits MobileScreen

  #tag Event
    Sub Opening()
      Self.Title = "Consignes"
      Self.TabIcon = MobileScreen.SystemIconBookmark

      PopulateConsignes
    End Sub
  #tag EndEvent

  #tag Method, Flags = &h1
    Private Sub PopulateConsignes()
      Var text As String

      text = "CONSIGNES DE MESURE" + EndOfLine
      text = text + "===========================================" + EndOfLine + EndOfLine

      text = text + "AVANT LA MESURE" + EndOfLine
      text = text + "• Pas de tabac, caféine, nourriture, exercice 30 min avant" + EndOfLine
      text = text + "• Être seul dans un endroit calme" + EndOfLine
      text = text + "• Température confortable" + EndOfLine
      text = text + "• Se reposer 3 à 5 min avant la première mesure" + EndOfLine
      text = text + "• Ne pas parler ni utiliser d'écran avant, pendant et entre les mesures" + EndOfLine + EndOfLine

      text = text + "POSITION" + EndOfLine
      text = text + "• Dos soutenu (appuyé contre le dossier)" + EndOfLine
      text = text + "• Bras nu sur la table, brassard à mi-bras au niveau du cœur" + EndOfLine
      text = text + "• Pieds à plat sur le sol" + EndOfLine
      text = text + "• Taille de brassard adaptée (petit, moyen, grand)" + EndOfLine + EndOfLine

      text = text + "MATÉRIEL" + EndOfLine
      text = text + "• Tensiomètre validé avec brassard au bras" + EndOfLine
      text = text + "• www.stridebp.org/fr/" + EndOfLine + EndOfLine

      text = text + "PROTOCOLE" + EndOfLine
      text = text + "===========================================" + EndOfLine
      text = text + "• 3 jours consécutifs" + EndOfLine
      text = text + "• 3 mesures le matin (avant petit-déjeuner et médicaments)" + EndOfLine
      text = text + "• 3 mesures le soir (avant le coucher)" + EndOfLine
      text = text + "• Toujours le même bras" + EndOfLine
      text = text + "• 1 minute entre chaque mesure" + EndOfLine + EndOfLine

      text = text + "OBJECTIF TENSIONNEL" + EndOfLine
      text = text + "< 135 / 85 mmHg en automesure." + EndOfLine
      text = text + "Consultez votre médecin pour un objectif personnalisé."

      txtConsignes.Text = text
    End Sub
  #tag EndMethod

  // Controls
  #tag Control
    Begin MobileTextArea txtConsignes
      Left            =   0
      Top             =   0
      Width           =   320
      Height          =   568
      LockLeft        =   True
      LockTop         =   True
      LockRight       =   True
      LockBottom      =   True
      ReadOnly        =   True
      Text            =   ""
      FontSize        =   14
    End
  #tag EndControl

End Class
#tag EndMobileScreen
