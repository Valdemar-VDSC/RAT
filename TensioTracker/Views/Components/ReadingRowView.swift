import SwiftUI

struct ReadingRowView: View {
    let label: String
    @Binding var reading: BloodPressureReading

    var body: some View {
        HStack(spacing: 8) {
            Text(label)
                .font(.subheadline.weight(.medium))
                .frame(width: 72, alignment: .leading)

            IntFieldView(value: $reading.systolic, placeholder: "SYS", unit: nil)
            IntFieldView(value: $reading.diastolic, placeholder: "DIA", unit: nil)
            IntFieldView(value: $reading.pulse, placeholder: "Pouls", unit: nil)
        }
    }
}

struct IntFieldView: View {
    @Binding var value: Int?
    let placeholder: String
    let unit: String?

    @State private var text: String = ""

    var body: some View {
        TextField(placeholder, text: $text)
            .keyboardType(.numberPad)
            .multilineTextAlignment(.center)
            .font(.subheadline.monospacedDigit())
            .padding(.vertical, 8)
            .padding(.horizontal, 4)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.tertiarySystemFill))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(.separator), lineWidth: 0.5)
            )
            .onAppear {
                text = value.map { "\($0)" } ?? ""
            }
            .onChange(of: text) { _, newValue in
                if newValue.isEmpty {
                    value = nil
                } else if let intVal = Int(newValue) {
                    value = intVal
                }
            }
            .onChange(of: value) { _, newValue in
                let expected = newValue.map { "\($0)" } ?? ""
                if text != expected {
                    text = expected
                }
            }
    }
}

#Preview {
    @Previewable @State var reading = BloodPressureReading()
    ReadingRowView(label: "Mesure 1", reading: $reading)
        .padding()
}
