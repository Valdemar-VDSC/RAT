import Foundation

struct BloodPressureReading: Codable, Identifiable, Equatable {
    let id: UUID
    var systolic: Int?
    var diastolic: Int?
    var pulse: Int?

    init(id: UUID = UUID(), systolic: Int? = nil, diastolic: Int? = nil, pulse: Int? = nil) {
        self.id = id
        self.systolic = systolic
        self.diastolic = diastolic
        self.pulse = pulse
    }

    var isComplete: Bool {
        systolic != nil && diastolic != nil && pulse != nil
    }
}

struct DayMeasurement: Codable, Identifiable, Equatable {
    let id: UUID
    var date: Date?
    var morningReadings: [BloodPressureReading]
    var eveningReadings: [BloodPressureReading]

    init(id: UUID = UUID(), date: Date? = nil) {
        self.id = id
        self.date = date
        self.morningReadings = (0..<3).map { _ in BloodPressureReading() }
        self.eveningReadings = (0..<3).map { _ in BloodPressureReading() }
    }
}

struct MeasurementSession: Codable, Identifiable, Equatable {
    let id: UUID
    var days: [DayMeasurement]
    var createdAt: Date

    init(id: UUID = UUID()) {
        self.id = id
        self.days = (0..<3).map { _ in DayMeasurement() }
        self.createdAt = Date()
    }
}

struct PatientProfile: Codable, Equatable {
    var firstName: String = ""
    var lastName: String = ""
    var birthDate: Date? = nil
    var medications: String = ""
}
