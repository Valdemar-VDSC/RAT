import SwiftUI

@main
struct TensioTrackerApp: App {
    @State private var viewModel = MeasurementViewModel()

    var body: some Scene {
        WindowGroup {
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
        }
    }
}
