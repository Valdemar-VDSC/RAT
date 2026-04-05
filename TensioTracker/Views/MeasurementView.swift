import SwiftUI

struct MeasurementView: View {
    @Environment(MeasurementViewModel.self) private var viewModel
    @State private var selectedDay: Int = 0
    @State private var showNewSessionAlert = false

    private let themeColor = Color(red: 0.102, green: 0.322, blue: 0.463)

    var body: some View {
        @Bindable var vm = viewModel

        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Day Picker
                    Picker("Jour", selection: $selectedDay) {
                        Text("Jour 1").tag(0)
                        Text("Jour 2").tag(1)
                        Text("Jour 3").tag(2)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)

                    // Date Picker
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundStyle(themeColor)
                        DatePicker(
                            "Date",
                            selection: Binding(
                                get: { vm.currentSession.days[selectedDay].date ?? Date() },
                                set: { vm.currentSession.days[selectedDay].date = $0 }
                            ),
                            displayedComponents: .date
                        )
                        .environment(\.locale, Locale(identifier: "fr_FR"))
                    }
                    .padding(.horizontal)

                    // Morning Section
                    measurementSection(
                        title: "MATIN",
                        subtitle: "Avant le petit-déjeuner et les médicaments",
                        icon: "sunrise.fill",
                        readings: bindingForReadings(period: .morning)
                    )

                    // Evening Section
                    measurementSection(
                        title: "SOIR",
                        subtitle: "Avant le coucher",
                        icon: "moon.fill",
                        readings: bindingForReadings(period: .evening)
                    )

                    // Averages
                    VStack(spacing: 12) {
                        Text("Moyennes de la session")
                            .font(.headline)
                            .foregroundStyle(themeColor)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        AverageCardView(
                            title: "Moyenne du matin",
                            sysValue: viewModel.formatAverage(viewModel.morningAverageSys),
                            diaValue: viewModel.formatAverage(viewModel.morningAverageDia),
                            pulseValue: viewModel.formatAverage(viewModel.morningAveragePulse),
                            status: viewModel.bpStatus(sys: viewModel.morningAverageSys, dia: viewModel.morningAverageDia)
                        )

                        AverageCardView(
                            title: "Moyenne du soir",
                            sysValue: viewModel.formatAverage(viewModel.eveningAverageSys),
                            diaValue: viewModel.formatAverage(viewModel.eveningAverageDia),
                            pulseValue: viewModel.formatAverage(viewModel.eveningAveragePulse),
                            status: viewModel.bpStatus(sys: viewModel.eveningAverageSys, dia: viewModel.eveningAverageDia)
                        )

                        AverageCardView(
                            title: "Moyenne générale",
                            sysValue: viewModel.formatAverage(viewModel.generalAverageSys),
                            diaValue: viewModel.formatAverage(viewModel.generalAverageDia),
                            pulseValue: viewModel.formatAverage(viewModel.generalAveragePulse),
                            status: viewModel.bpStatus(sys: viewModel.generalAverageSys, dia: viewModel.generalAverageDia)
                        )
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 24)
                }
                .padding(.top, 8)
            }
            .background(Color(.systemGroupedBackground))
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("Mesures")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showNewSessionAlert = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(themeColor)
                    }
                }

                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        viewModel.saveData()
                    } label: {
                        Image(systemName: "square.and.arrow.down")
                            .foregroundStyle(themeColor)
                    }
                }

                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("OK") {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                }
            }
            .alert("Nouvelle session", isPresented: $showNewSessionAlert) {
                Button("Annuler", role: .cancel) {}
                Button("Créer") {
                    viewModel.startNewSession()
                    selectedDay = 0
                }
            } message: {
                Text("Voulez-vous commencer une nouvelle session de 3 jours ? La session actuelle sera sauvegardée.")
            }
            .onChange(of: viewModel.currentSession) { _, _ in
                viewModel.saveData()
            }
        }
    }

    private enum Period {
        case morning, evening
    }

    private func bindingForReadings(period: Period) -> Binding<[BloodPressureReading]> {
        @Bindable var vm = viewModel
        return switch period {
        case .morning:
            $vm.currentSession.days[selectedDay].morningReadings
        case .evening:
            $vm.currentSession.days[selectedDay].eveningReadings
        }
    }

    private func measurementSection(
        title: String,
        subtitle: String,
        icon: String,
        readings: Binding<[BloodPressureReading]>
    ) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundStyle(themeColor)
                    .font(.title3)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(themeColor)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            // Column headers
            HStack(spacing: 8) {
                Text("")
                    .frame(width: 72, alignment: .leading)
                Text("SYS")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                Text("DIA")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                Text("Pouls")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
            }

            ForEach(0..<3, id: \.self) { index in
                ReadingRowView(
                    label: "Mesure \(index + 1)",
                    reading: readings[index]
                )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 3, y: 1)
        )
        .padding(.horizontal)
    }
}

#Preview {
    MeasurementView()
        .environment(MeasurementViewModel())
}
