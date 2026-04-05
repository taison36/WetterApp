import SwiftUI
import Combine

struct MyLocationView: View {
    @ObservedObject var weather_vm: WeatherViewModel
    @ObservedObject var city_vm: CityViewModel
    var background_vm: BackgroundViewModel
    
    var body: some View{
        VStack {
            if let city = city_vm.my_location_city, let data = weather_vm.forecast(for: city) {
                CurrentForecastView(forecast: data)
            } else {
                ScrollView {
                    CurrentDayLoadingView()
                    ForecastLoadingView()
                        .padding(.horizontal)
                        .padding(.vertical, 25)
                }
            }
        }
        .onReceive(city_vm.locationManager.$location.compactMap { $0 }) { location in
            Task {
                await city_vm.myLocation()
                if let city = city_vm.my_location_city {
                    await weather_vm.fetch_forecast(for: city)
                    guard let day = weather_vm.forecast(for: city) else {return}
                    
                    let is_night = (day.current.is_day != 1)
                    let newBackground: [Color] = [
                        is_night ? .black.opacity(0.8) : background_vm.darkBlue.opacity(0.8),
                        is_night ? .gray.opacity(0.6) : background_vm.skyBlue.opacity(0.6) ]
                    if background_vm.app_background != newBackground {
                        background_vm.app_background = newBackground
                    }
                }else {
                    print("My location city couldn't be loaded")
                }
            }
        }
    }
    
    private struct CurrentForecastView: View{
        let forecast: WeatherData
        
        var body: some View{
            Text("My Location")
                .foregroundStyle(.white)
                .font(.system(size: 32))
                .bold()
            ZStack(alignment: .topTrailing) {
                VStack{
                    ScrollView{
                        CurrentDayView(location: forecast.location, current: forecast.current)
                        ForecastView(forecast: forecast.forecast)
                            .padding(.horizontal)
                            .padding(.vertical, 25)
                    }
                    .scrollIndicators(.hidden)
                }
            }
        }
    }
}

#Preview {
    ContentView(city_vm: CityViewModel())
}
