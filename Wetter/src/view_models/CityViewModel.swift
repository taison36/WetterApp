import SwiftUI
import CoreLocation

@Observable
class CityViewModel: ObservableObject {
    var suggested_cities: [City]?
    var saved_cities: [City]?
    var my_location_city: City?
    var new_sity_added: Bool = false
    
    var locationManager = LocationManager()
    
    func searchCity(city_name: String) async {
        do {
            let base = "https://api.weatherapi.com/v1/search.json"
            
            guard let encoded_instruction = city_name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let url = URL(string: "\(base)?q=\(encoded_instruction)")
            else {
                fatalError("Search instruction could not be encoded")
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "accept")
            request.setValue("4288329c0cc948aca86201617252411", forHTTPHeaderField: "key")
            
            let (jsonData, _) = try await URLSession.shared.data(for: request)
            let decoded_cities = try JSONDecoder().decode([City].self, from: jsonData)
            
            await MainActor.run {
                self.suggested_cities = decoded_cities
            }
        } catch {
            print("Error during searching for cities:", error)
        }
        
    }
    
    func myLocation() async {
        guard let location = locationManager.location else {
            print("location manager couldn't return the current location")
            return
        }
        
        do {
            let base = "https://api.weatherapi.com/v1/search.json"
            
            guard let url = URL(string: "\(base)?q=\(location.coordinate.latitude), \(location.coordinate.longitude)")
            else {
                fatalError("Location coordinates could not be encoded")
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "accept")
            request.setValue("4288329c0cc948aca86201617252411", forHTTPHeaderField: "key")
            
            let (jsonData, _) = try await URLSession.shared.data(for: request)
            let decoded_city = try JSONDecoder().decode([City].self, from: jsonData)
            
            await MainActor.run {
                my_location_city = decoded_city.last
            }
        } catch {
            print("Error during searching for cities:", error)
        }
    }
    
    func loadSavedCities() {
        if let extracted_data = UserDefaults.standard.data(forKey: "saved_cities"),
           let extracted_cities = try? JSONDecoder().decode([City].self, from: extracted_data) {
            saved_cities = extracted_cities
        }
    }
    
    func saveCities() {
        guard let cities = saved_cities else { return }
        if let encoded = try? JSONEncoder().encode(cities) {
            UserDefaults.standard.set(encoded, forKey: "saved_cities")
        }
    }
}
