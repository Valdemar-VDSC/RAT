import SwiftUI

struct AverageCardView: View {
    let title: String
    let sysValue: String
    let diaValue: String
    let pulseValue: String
    let status: MeasurementViewModel.BPStatus

    private var statusColor: Color {
        switch status {
        case .normal: return .green
        case .elevated: return .red
        case .unknown: return .gray
        }
    }

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
                Spacer()
                if status != .unknown {
                    Text(status.label)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(
                            Capsule().fill(statusColor)
                        )
                }
            }

            HStack(spacing: 16) {
                ValueColumn(label: "SYS", value: sysValue, unit: "mmHg", color: statusColor)
                Divider().frame(height: 40)
                ValueColumn(label: "DIA", value: diaValue, unit: "mmHg", color: statusColor)
                Divider().frame(height: 40)
                ValueColumn(label: "Pouls", value: pulseValue, unit: "bpm", color: .primary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.systemBackground))
                .shadow(color: statusColor.opacity(status != .unknown ? 0.15 : 0.05), radius: 5, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(statusColor.opacity(status != .unknown ? 0.3 : 0.1), lineWidth: 1)
        )
    }
}

private struct ValueColumn: View {
    let label: String
    let value: String
    let unit: String
    let color: Color

    var body: some View {
        VStack(spacing: 2) {
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.title2.bold().monospacedDigit())
                .foregroundStyle(value == "—" ? .secondary : color)
            Text(unit)
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    VStack(spacing: 16) {
        AverageCardView(
            title: "Moyenne du matin",
            sysValue: "128",
            diaValue: "79",
            pulseValue: "68",
            status: .normal
        )
        AverageCardView(
            title: "Moyenne du soir",
            sysValue: "142",
            diaValue: "88",
            pulseValue: "72",
            status: .elevated
        )
        AverageCardView(
            title: "Moyenne générale",
            sysValue: "—",
            diaValue: "—",
            pulseValue: "—",
            status: .unknown
        )
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
