import SwiftUI

struct ScrollPagesView: View{
    @ObservedObject var city_vm: CityViewModel
    @ObservedObject var weather_vm: WeatherViewModel = WeatherViewModel()
    var background_vm: BackgroundViewModel
    
    @State private var curPage: Int? = 0
    @Binding var close_search_window: Bool
    
    @ViewBuilder
    private func pageView(at index: Int) -> some View {
        if index == 0 {
            MyLocationView(weather_vm: weather_vm, city_vm: city_vm, background_vm: background_vm)
        } else {
            let cities = city_vm.saved_cities ?? []
            if cities.indices.contains(index - 1) {
                CityPageView(city: cities[index - 1], weather_vm: weather_vm, city_vm: city_vm)
            } else {
                Color.clear
            }
        }
    }
    
    var body: some View{
        let pageCount = 1 + (city_vm.saved_cities?.count ?? 0)
        ScrollView(.horizontal) {
            LazyHStack(spacing: 0) {
                ForEach(0..<pageCount, id: \.self) { index in
                    pageView(at: index)
                        .id(index)
                        .frame(width: UIScreen.main.bounds.width)
                        .padding(.top, 50)
                        .contentShape(Rectangle())
                        .onTapGesture { close_search_window = true }
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.paging)
        .scrollPosition(id: $curPage)
        .onChange(of: city_vm.new_sity_added) { _, new_state in
            guard new_state else {return}
            city_vm.new_sity_added = false
            let cities = city_vm.saved_cities ?? []
            print("saved_cities called")
            if let lastIndex = cities.indices.last {
                // +1 to account for MyLocationView at index 0
                curPage = lastIndex + 1
            } else {
                curPage = 0
            }
        }
        .onChange(of: curPage) { _, new_page in
            guard let page = new_page else { return }
            updateBackground(page: page)
        }
        .onChange(of: weather_vm.cached_weatherdata) { _, _ in
            guard let page = curPage else { return }
            updateBackground(page: page)
        }
    }
    
    private func updateBackground(page: Int) {
        var city: City
        if page == 0 {
            guard let c = city_vm.my_location_city else {
                print("UpBack: no my location city found")
                return
            }
            city = c
        } else {
            let cities = city_vm.saved_cities ?? []
            let cityIndex = page - 1
            guard cities.indices.contains(cityIndex) else { return }
            city = cities[cityIndex]
        }

        guard let day = weather_vm.forecast(for: city) else {
            print("update back could not find the day by id")
            return
        }
        let is_night = (day.current.is_day != 1)
        let newBackground: [Color] = [
            is_night ? .black.opacity(0.8) : background_vm.darkBlue.opacity(0.8),
            is_night ? .gray.opacity(0.6) : background_vm.skyBlue.opacity(0.6) ]
        if background_vm.app_background != newBackground {
            background_vm.app_background = newBackground
        }
    }
    

}
