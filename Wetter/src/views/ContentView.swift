import SwiftUI

struct ContentView: View {
    @ObservedObject var city_vm: CityViewModel
    @StateObject var weather_vm: WeatherViewModel = WeatherViewModel()
    @State var background_vm: BackgroundViewModel = BackgroundViewModel()
    
    @State var close_search_window: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            SearchView(close_search_window: $close_search_window, city_vm: city_vm)
                .zIndex(1)
            ScrollPagesView(city_vm: city_vm, weather_vm: weather_vm,background_vm: background_vm, close_search_window: $close_search_window)
        }
        .background(
            LinearGradient(colors: background_vm.app_background, startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.5), value: background_vm.app_background)
        )
    }
}



#Preview {
    ContentView(city_vm: CityViewModel())
}
