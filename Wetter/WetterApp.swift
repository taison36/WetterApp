import SwiftUI

@main
struct WetterApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject var city_vm: CityViewModel = CityViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(city_vm: city_vm)
                .onAppear {
                    city_vm.loadSavedCities()
                }
        }.onChange(of: scenePhase) { _, newPhase in
            switch newPhase {
            case .active:
                print("")
            case .inactive:
                print("")
            case .background:
                city_vm.saveCities()
            @unknown default:
                break
            }
        }
    }
}
