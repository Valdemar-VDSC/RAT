#tag Class
Protected Class ConsignesScreen
  Inherits MobileScreen

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

End Class
#tag EndClass
