import SwiftUI

@main
struct TensioTrackerApp: App {
    @State private var viewModel = MeasurementViewModel()
    @State private var showSplash = true
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            ZStack {
                TabView {
                    InstructionsView()
                        .tabItem {
                            Label("Consignes", systemImage: "list.clipboard")
                        }

                    MeasurementView()
                        .tabItem {
                            Label("Mesures", systemImage: "heart.text.square")
                        }

                    ProfileView()
                        .tabItem {
                            Label("Profil", systemImage: "person.crop.circle")
                        }
                }
                .environment(viewModel)
                .tint(Color("AccentColor"))
                .opacity(showSplash ? 0 : 1)
                .onChange(of: scenePhase) { _, phase in
                    if phase == .inactive || phase == .background {
                        viewModel.saveData()
                    }
                }

                if showSplash {
                    SplashScreenView()
                        .transition(.opacity)
                        .onAppear {
                            splashSequence()
                        }
                }
            }
        }
    }

    private func splashSequence() {
        // Wait for splash animations then dismiss
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeInOut(duration: 0.5)) {
                showSplash = false
            }
        }
    }
}
