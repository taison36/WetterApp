import SwiftUI
import Combine

struct CityPageView: View{
    let city: City
    var weather_vm: WeatherViewModel
    var city_vm: CityViewModel
    
    var body: some View{
        VStack {
            if weather_vm.isBeingLoaded(for: city) {
                ScrollView {
                    CurrentDayLoadingView()
                    ForecastLoadingView()
                        .padding(.horizontal)
                        .padding(.vertical, 25)
                }
            } else if let data = weather_vm.forecast(for: city) {
                CurrentForecastView(forecast: data, city_vm: city_vm, city: city)
            }
        }
        .task{
            await weather_vm.fetch_forecast(for: city)
        }
    }
}

private struct CurrentForecastView: View{
    let forecast: WeatherData
    var city_vm: CityViewModel
    let city: City
    
    var body: some View{
        ZStack(alignment: .topTrailing) {
            VStack{
                ScrollView{
                    CurrentDayView(location: forecast.location, current: forecast.current)
                    ForecastView(forecast: forecast.forecast)
                        .padding(.horizontal)
                        .padding(.vertical, 25)
                }
            }
            .scrollIndicators(.hidden)
            .transition(.move(edge: .top).combined(with: .opacity))
            deleteCityButton()
                .padding(12)
        }
    }
    
    @ViewBuilder
    public func deleteCityButton() -> some View {
        Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                if let index = city_vm.saved_cities?.firstIndex(of: city) {
                    city_vm.saved_cities?.remove(at: index)
                }
            }
        } label: {
            Image(systemName: "xmark.circle.fill")
                .font(.title2)
                .foregroundStyle(.secondary)
                .padding(6)
                .background(.ultraThinMaterial, in: Circle())
        }
        .accessibilityLabel("Delete city")
    }
}

#Preview {
    ContentView(city_vm: CityViewModel())
}
