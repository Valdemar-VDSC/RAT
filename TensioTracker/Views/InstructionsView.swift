import SwiftUI

struct InstructionsView: View {
    private let themeColor = Color(red: 0.102, green: 0.322, blue: 0.463)

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "heart.circle.fill")
                            .font(.system(size: 56))
                            .foregroundStyle(themeColor)
                        Text("Consignes de mesure")
                            .font(.title.bold())
                            .foregroundStyle(themeColor)
                        Text("Relevé d'automesure tensionnelle")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 8)

                    // Before measurement section
                    SectionHeader(title: "Avant la mesure", icon: "clock.badge.checkmark")

                    GuidelineCard(
                        icon: "nosign",
                        title: "Pas de tabac ni de caféine",
                        description: "Ne pas fumer, ni consommer de caféine, d'aliments ou faire de l'exercice dans les 30 minutes précédant la mesure."
                    )

                    GuidelineCard(
                        icon: "person.fill",
                        title: "Seul et au calme",
                        description: "Être seul dans un endroit calme, à une température confortable."
                    )

                    GuidelineCard(
                        icon: "timer",
                        title: "Repos préalable",
                        description: "Se reposer 3 à 5 minutes avant la première mesure."
                    )

                    GuidelineCard(
                        icon: "iphone.slash",
                        title: "Pas d'écran ni de parole",
                        description: "Ne pas parler ni utiliser d'écran avant, pendant et entre les mesures."
                    )

                    // Position section
                    SectionHeader(title: "Position", icon: "figure.seated.seatbelt")

                    GuidelineCard(
                        icon: "chair.fill",
                        title: "Dos soutenu",
                        description: "S'asseoir avec le dos bien appuyé contre le dossier de la chaise."
                    )

                    GuidelineCard(
                        icon: "hand.raised.fill",
                        title: "Bras sur la table",
                        description: "Bras nu posé sur la table, brassard au milieu du bras, au niveau du coeur."
                    )

                    GuidelineCard(
                        icon: "shoe.fill",
                        title: "Pieds à plat",
                        description: "Les pieds doivent être à plat sur le sol, jambes non croisées."
                    )

                    // Equipment section
                    SectionHeader(title: "Matériel", icon: "stethoscope")

                    GuidelineCard(
                        icon: "circle.dotted",
                        title: "Taille du brassard adaptée",
                        description: "Utiliser un brassard adapté à votre bras : petit (17-22 cm), moyen (22-32 cm) ou grand (32-42 cm)."
                    )

                    GuidelineCard(
                        icon: "checkmark.seal.fill",
                        title: "Appareil validé",
                        description: "Utiliser un tensiomètre brassard validé. Consultez www.stridebp.org/fr/ pour la liste des appareils recommandés."
                    )

                    // Protocol section
                    protocolCard

                    // Target section
                    targetCard
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var protocolCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "calendar.badge.clock")
                    .font(.title2)
                    .foregroundStyle(.white)
                Text("Protocole de mesure")
                    .font(.headline)
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 8) {
                protocolRow(icon: "3.circle.fill", text: "3 jours consécutifs de mesures")
                protocolRow(icon: "sunrise.fill", text: "3 mesures le matin, avant le petit-déjeuner et la prise de médicaments")
                protocolRow(icon: "moon.fill", text: "3 mesures le soir, avant le coucher")
                protocolRow(icon: "arrow.left.arrow.right", text: "Toujours le même bras")
                protocolRow(icon: "clock.fill", text: "Attendre 1 minute entre chaque mesure")
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [themeColor, themeColor.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .padding(.top, 8)
    }

    private func protocolRow(icon: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.9))
                .frame(width: 20)
            Text(text)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.95))
        }
    }

    private var targetCard: some View {
        HStack(spacing: 12) {
            Image(systemName: "target")
                .font(.title)
                .foregroundStyle(.green)
            VStack(alignment: .leading, spacing: 4) {
                Text("Objectif tensionnel")
                    .font(.headline)
                Text("< 135 / 85 mmHg en automesure dans la plupart des cas. Consultez votre médecin pour un objectif personnalisé.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.06), radius: 4, y: 2)
        )
        .padding(.top, 4)
        .padding(.bottom, 8)
    }
}

// MARK: - Subviews

private struct SectionHeader: View {
    let title: String
    let icon: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(Color(red: 0.102, green: 0.322, blue: 0.463))
            Text(title)
                .font(.title3.bold())
            Spacer()
        }
        .padding(.top, 12)
    }
}

private struct GuidelineCard: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(Color(red: 0.102, green: 0.322, blue: 0.463))
                .frame(width: 32, height: 32)
                .background(
                    Circle()
                        .fill(Color(red: 0.102, green: 0.322, blue: 0.463).opacity(0.1))
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.bold())
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 3, y: 1)
        )
    }
}

#Preview {
    InstructionsView()
}
