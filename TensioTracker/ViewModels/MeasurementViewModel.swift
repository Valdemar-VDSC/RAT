import Foundation
import Observation

@Observable
class MeasurementViewModel {
    var currentSession: MeasurementSession
    var profile: PatientProfile
    var sessions: [MeasurementSession] = []

    private let profileKey = "patient_profile"
    private let sessionsKey = "measurement_sessions"

    init() {
        self.currentSession = MeasurementSession()
        self.profile = PatientProfile()
        loadData()
    }

    // MARK: - Averages Calculation

    private func average(of readings: [BloodPressureReading], keyPath: KeyPath<BloodPressureReading, Int?>) -> Double? {
        let values = readings.compactMap { $0[keyPath: keyPath] }
        guard !values.isEmpty else { return nil }
        return Double(values.reduce(0, +)) / Double(values.count)
    }

    var morningAverageSys: Double? {
        let allMorning = currentSession.days.flatMap { $0.morningReadings }
        return average(of: allMorning, keyPath: \.systolic)
    }

    var morningAverageDia: Double? {
        let allMorning = currentSession.days.flatMap { $0.morningReadings }
        return average(of: allMorning, keyPath: \.diastolic)
    }

    var morningAveragePulse: Double? {
        let allMorning = currentSession.days.flatMap { $0.morningReadings }
        return average(of: allMorning, keyPath: \.pulse)
    }

    var eveningAverageSys: Double? {
        let allEvening = currentSession.days.flatMap { $0.eveningReadings }
        return average(of: allEvening, keyPath: \.systolic)
    }

    var eveningAverageDia: Double? {
        let allEvening = currentSession.days.flatMap { $0.eveningReadings }
        return average(of: allEvening, keyPath: \.diastolic)
    }

    var eveningAveragePulse: Double? {
        let allEvening = currentSession.days.flatMap { $0.eveningReadings }
        return average(of: allEvening, keyPath: \.pulse)
    }

    var generalAverageSys: Double? {
        let allReadings = currentSession.days.flatMap { $0.morningReadings + $0.eveningReadings }
        return average(of: allReadings, keyPath: \.systolic)
    }

    var generalAverageDia: Double? {
        let allReadings = currentSession.days.flatMap { $0.morningReadings + $0.eveningReadings }
        return average(of: allReadings, keyPath: \.diastolic)
    }

    var generalAveragePulse: Double? {
        let allReadings = currentSession.days.flatMap { $0.morningReadings + $0.eveningReadings }
        return average(of: allReadings, keyPath: \.pulse)
    }

    // MARK: - BP Status

    func bpStatus(sys: Double?, dia: Double?) -> BPStatus {
        guard let sys = sys, let dia = dia else { return .unknown }
        if sys < 135 && dia < 85 {
            return .normal
        } else if sys >= 135 || dia >= 85 {
            return .elevated
        }
        return .unknown
    }

    enum BPStatus {
        case normal, elevated, unknown

        var color: String {
            switch self {
            case .normal: return "green"
            case .elevated: return "red"
            case .unknown: return "gray"
            }
        }

        var label: String {
            switch self {
            case .normal: return "Normal"
            case .elevated: return "Élevée"
            case .unknown: return "—"
            }
        }
    }

    // MARK: - Session Averages for History

    func sessionAverageSys(_ session: MeasurementSession) -> Double? {
        let allReadings = session.days.flatMap { $0.morningReadings + $0.eveningReadings }
        return average(of: allReadings, keyPath: \.systolic)
    }

    func sessionAverageDia(_ session: MeasurementSession) -> Double? {
        let allReadings = session.days.flatMap { $0.morningReadings + $0.eveningReadings }
        return average(of: allReadings, keyPath: \.diastolic)
    }

    // MARK: - Persistence

    func saveData() {
        if let profileData = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(profileData, forKey: profileKey)
        }
        if let idx = sessions.firstIndex(where: { $0.id == currentSession.id }) {
            sessions[idx] = currentSession
        } else {
            sessions.append(currentSession)
        }
        if let sessionsData = try? JSONEncoder().encode(sessions) {
            UserDefaults.standard.set(sessionsData, forKey: sessionsKey)
        }
    }

    func loadData() {
        if let data = UserDefaults.standard.data(forKey: profileKey),
           let decoded = try? JSONDecoder().decode(PatientProfile.self, from: data) {
            profile = decoded
        }
        if let data = UserDefaults.standard.data(forKey: sessionsKey),
           let decoded = try? JSONDecoder().decode([MeasurementSession].self, from: data) {
            sessions = decoded
            if let last = decoded.last {
                currentSession = last
            }
        }
    }

    func startNewSession() {
        saveData()
        currentSession = MeasurementSession()
        sessions.append(currentSession)
        saveData()
    }

    func formatAverage(_ value: Double?) -> String {
        guard let value = value else { return "—" }
        return String(format: "%.0f", value)
    }

    // MARK: - Export

    func exportSessionText() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale(identifier: "fr_FR")

        var text = "RELEVÉ D'AUTOMESURE TENSIONNELLE\n"
        text += "================================\n\n"

        if !profile.lastName.isEmpty || !profile.firstName.isEmpty {
            text += "Patient : \(profile.firstName) \(profile.lastName)\n"
        }
        if let birthDate = profile.birthDate {
            text += "Date de naissance : \(dateFormatter.string(from: birthDate))\n"
        }
        if !profile.medications.isEmpty {
            text += "Traitements : \(profile.medications)\n"
        }
        text += "\nSession du \(dateFormatter.string(from: currentSession.createdAt))\n"
        text += "────────────────────────────────\n\n"

        for (index, day) in currentSession.days.enumerated() {
            let dayDate = day.date != nil ? dateFormatter.string(from: day.date!) : "Non renseignée"
            text += "JOUR \(index + 1) — \(dayDate)\n\n"

            text += "  Matin :\n"
            for (i, reading) in day.morningReadings.enumerated() {
                let sys = reading.systolic.map { "\($0)" } ?? "—"
                let dia = reading.diastolic.map { "\($0)" } ?? "—"
                let pul = reading.pulse.map { "\($0)" } ?? "—"
                text += "    Mesure \(i + 1) : SYS \(sys) / DIA \(dia) / Pouls \(pul)\n"
            }

            text += "  Soir :\n"
            for (i, reading) in day.eveningReadings.enumerated() {
                let sys = reading.systolic.map { "\($0)" } ?? "—"
                let dia = reading.diastolic.map { "\($0)" } ?? "—"
                let pul = reading.pulse.map { "\($0)" } ?? "—"
                text += "    Mesure \(i + 1) : SYS \(sys) / DIA \(dia) / Pouls \(pul)\n"
            }
            text += "\n"
        }

        text += "────────────────────────────────\n"
        text += "MOYENNES\n\n"
        text += "  Matin  : SYS \(formatAverage(morningAverageSys)) / DIA \(formatAverage(morningAverageDia))\n"
        text += "  Soir   : SYS \(formatAverage(eveningAverageSys)) / DIA \(formatAverage(eveningAverageDia))\n"
        text += "  Global : SYS \(formatAverage(generalAverageSys)) / DIA \(formatAverage(generalAverageDia))\n\n"

        let status = bpStatus(sys: generalAverageSys, dia: generalAverageDia)
        text += "Statut : \(status.label)\n"
        text += "Objectif : < 135/85 mmHg\n"

        return text
    }
}
