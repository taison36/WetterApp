import SwiftUI
import Combine

@MainActor
@Observable
class WeatherViewModel: ObservableObject {
      var cached_weatherdata: [City: WeatherData] = [:]
     var cities_being_loaded: Set<City> = []
    
    func isBeingLoaded(for city: City) -> Bool {
        if cities_being_loaded.contains(city){
            return true
        } else {
            return false
        }
    }
    
    func fetch_forecast(for city: City) async {
        if cities_being_loaded.contains(city) {
            return // уже грузим — не стартуй вторую загрузку
        }
        
        if let cached = cached_weatherdata[city] {
            let age = Date().timeIntervalSince(cached.current.last_updated)

            if age < 600.0 {
                return
            }
        }
        
        cities_being_loaded.insert(city)
        
        do {
            let base = "https://api.weatherapi.com/v1/forecast.json"
            
            guard let encodedCity = city.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let url = URL(string: "\(base)?q=\(encodedCity)&days=3")
            else {
                fatalError("Invalid city name")
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "accept")
            request.setValue("4288329c0cc948aca86201617252411", forHTTPHeaderField: "key")
            
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoded_weather_data = try JSONDecoder().decode(WeatherData.self, from: data)
            
            cached_weatherdata[city] = decoded_weather_data
            
        } catch {
            print("Error:", error)
        }
        
        cities_being_loaded.remove(city)
    }
    
    func forecast(for city_id: Int) -> WeatherData? {
        if let found = cached_weatherdata.first(where: { $0.key.id == city_id}) {
            return found.value
        }
        return nil
    }
    
    func forecast(for city: City) -> WeatherData? {
        if let cached = cached_weatherdata[city] {
            return cached
        }
        
        return nil
    }
    
}
