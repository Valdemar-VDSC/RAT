import SwiftUI

struct SplashScreenView: View {
    @State private var iconScale: CGFloat = 0.3
    @State private var iconOpacity: Double = 0
    @State private var titleOpacity: Double = 0
    @State private var subtitleOpacity: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    @State private var ringProgress: CGFloat = 0

    private let themeColor = Color(red: 0.102, green: 0.322, blue: 0.463)

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    themeColor,
                    themeColor.opacity(0.85),
                    Color(red: 0.05, green: 0.2, blue: 0.35)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                // Animated icon
                ZStack {
                    // Pulsing ring
                    Circle()
                        .stroke(Color.white.opacity(0.2), lineWidth: 3)
                        .frame(width: 140, height: 140)
                        .scaleEffect(pulseScale)

                    // Progress ring
                    Circle()
                        .trim(from: 0, to: ringProgress)
                        .stroke(
                            Color.white.opacity(0.6),
                            style: StrokeStyle(lineWidth: 3, lineCap: .round)
                        )
                        .frame(width: 140, height: 140)
                        .rotationEffect(.degrees(-90))

                    // Heart icon with pulse wave
                    ZStack {
                        // Background circle
                        Circle()
                            .fill(Color.white.opacity(0.15))
                            .frame(width: 120, height: 120)

                        // Heart icon
                        Image(systemName: "heart.fill")
                            .font(.system(size: 44, weight: .medium))
                            .foregroundStyle(.white)
                            .scaleEffect(pulseScale)

                        // Small waveform
                        Image(systemName: "waveform.path.ecg")
                            .font(.system(size: 22))
                            .foregroundStyle(.white.opacity(0.7))
                            .offset(y: 30)
                    }
                }
                .scaleEffect(iconScale)
                .opacity(iconOpacity)

                // App name
                VStack(spacing: 8) {
                    Text("TensioTracker")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .opacity(titleOpacity)

                    Text("Relevé d'automesure tensionnelle")
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.75))
                        .opacity(subtitleOpacity)
                }

                Spacer()

                // Bottom branding
                VStack(spacing: 6) {
                    Image(systemName: "stethoscope")
                        .font(.system(size: 18))
                        .foregroundStyle(.white.opacity(0.4))
                    Text("Suivi tensionnel conforme\naux recommandations françaises")
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.4))
                        .multilineTextAlignment(.center)
                }
                .opacity(subtitleOpacity)
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            animate()
        }
    }

    private func animate() {
        withAnimation(.easeOut(duration: 0.6)) {
            iconScale = 1.0
            iconOpacity = 1.0
        }

        withAnimation(.easeOut(duration: 0.5).delay(0.3)) {
            titleOpacity = 1.0
        }

        withAnimation(.easeOut(duration: 0.5).delay(0.5)) {
            subtitleOpacity = 1.0
        }

        withAnimation(.easeInOut(duration: 1.2).delay(0.2)) {
            ringProgress = 1.0
        }

        // Pulse heartbeat effect
        withAnimation(
            .easeInOut(duration: 0.6)
            .repeatCount(3, autoreverses: true)
            .delay(0.6)
        ) {
            pulseScale = 1.08
        }
    }
}

#Preview {
    SplashScreenView()
}
