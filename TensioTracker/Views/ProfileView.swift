import SwiftUI

struct ProfileView: View {
    @Environment(MeasurementViewModel.self) private var viewModel
    @State private var showShareSheet = false
    @State private var exportText = ""

    private let themeColor = Color(red: 0.102, green: 0.322, blue: 0.463)

    var body: some View {
        @Bindable var vm = viewModel

        NavigationStack {
            Form {
                // Patient Info
                Section {
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundStyle(themeColor)
                        TextField("Prénom", text: $vm.profile.firstName)
                    }
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundStyle(themeColor)
                        TextField("Nom", text: $vm.profile.lastName)
                    }
                    DatePicker(
                        "Date de naissance",
                        selection: Binding(
                            get: { vm.profile.birthDate ?? Date() },
                            set: { vm.profile.birthDate = $0 }
                        ),
                        displayedComponents: .date
                    )
                    .environment(\.locale, Locale(identifier: "fr_FR"))
                } header: {
                    Label("Informations du patient", systemImage: "person.text.rectangle")
                }

                // Medications
                Section {
                    TextEditor(text: $vm.profile.medications)
                        .frame(minHeight: 80)
                } header: {
                    Label("Traitements antihypertenseurs", systemImage: "pills.fill")
                } footer: {
                    Text("Indiquez vos médicaments et doses actuels.")
                }

                // Export
                Section {
                    Button {
                        exportText = viewModel.exportSessionText()
                        showShareSheet = true
                    } label: {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Exporter la session actuelle")
                        }
                    }
                } header: {
                    Label("Partage", systemImage: "paperplane")
                }

                // History
                Section {
                    if viewModel.sessions.isEmpty {
                        Text("Aucune session enregistrée")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(viewModel.sessions) { session in
                            SessionRowView(session: session, viewModel: viewModel)
                        }
                    }
                } header: {
                    Label("Historique des sessions", systemImage: "clock.arrow.circlepath")
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("Profil")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("OK") {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                }
            }
            .onDisappear {
                viewModel.saveData()
            }
            .sheet(isPresented: $showShareSheet) {
                ShareSheet(items: [exportText])
            }
        }
    }
}

// MARK: - Session Row

private struct SessionRowView: View {
    let session: MeasurementSession
    let viewModel: MeasurementViewModel

    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.locale = Locale(identifier: "fr_FR")
        return f
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(dateFormatter.string(from: session.createdAt))
                .font(.subheadline.weight(.semibold))

            let avgSys = viewModel.sessionAverageSys(session)
            let avgDia = viewModel.sessionAverageDia(session)

            if avgSys != nil || avgDia != nil {
                HStack(spacing: 4) {
                    Image(systemName: "heart.fill")
                        .font(.caption)
                        .foregroundStyle(.red)
                    Text("Moyenne : \(viewModel.formatAverage(avgSys))/\(viewModel.formatAverage(avgDia)) mmHg")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            } else {
                Text("Pas de données")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }

            // Show how many readings were entered
            let totalReadings = session.days.flatMap { $0.morningReadings + $0.eveningReadings }.filter { $0.isComplete }.count
            Text("\(totalReadings)/18 mesures complétées")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 2)
    }
}

// MARK: - Share Sheet

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    ProfileView()
        .environment(MeasurementViewModel())
}
