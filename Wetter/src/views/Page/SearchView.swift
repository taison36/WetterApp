import SwiftUI

struct SearchView: View{
    @Binding var close_search_window: Bool
    @State private var is_opened: Bool = false
    @ObservedObject var city_vm: CityViewModel
    
    var body: some View{
        VStack{
            SearchMenu(close_search_window: $close_search_window, is_opened: $is_opened, city_vm: city_vm)
                .frame(width: is_opened ?  .infinity : 170, alignment: .top)
                .background(
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(is_opened ? Color.black.opacity(0.8) : Color.clear)
                        .padding(.horizontal, 10)
                )
                .animation(.spring(response: 0.35, dampingFraction: 0.85), value: is_opened)
        }
    }
}

private struct SearchMenu: View{
    @FocusState var is_focused: Bool
    @Binding var close_search_window: Bool
    @Binding var is_opened: Bool
    @ObservedObject var city_vm: CityViewModel
    
    @State var suggested_cities: [City] = []
    @State private var search_field: String = ""
    
    var body: some View{
        VStack{
            HStack{
                Spacer()
                TextField("", text: $search_field, prompt: Text("Search for City")
                    .foregroundColor(.white)
                )
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .focused($is_focused)
                    .frame(alignment: .center)
                    .bold()
                    .padding(.vertical, 7)
                    .padding(.horizontal, 10)
                    .autocorrectionDisabled()
                    .onChange(of: is_focused) { oldState, newState in
                        if(!newState){
                            suggested_cities = []
                        }
                        is_opened = newState
                    }
                    .onChange(of: close_search_window) { _, newState in
                        if newState {
                            suggested_cities = []
                            is_focused = false
                            search_field = ""
                            close_search_window = false
                        }
                    }
                    .onChange(of: search_field) { _, newState in
                        Task {
                            let trimmed = newState.trimmingCharacters(in: .whitespacesAndNewlines)
                            if trimmed.isEmpty {
                                return
                            }
                            
                            await city_vm.searchCity(city_name: trimmed)
                            if let c = city_vm.suggested_cities {
                                suggested_cities = c
                            }
                        }
                    }
                Spacer()
            }
            
            if !suggested_cities.isEmpty{
                VStack{
                    ForEach(suggested_cities, id: \.id) { city in
                        CitySearchRow(city: city, city_vm: city_vm, should_close: $close_search_window)
                            .background(
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .fill(Color.gray.opacity(0.3))
                            )
                            .padding(.vertical, 8)
                        
                    }
                }
            }
        }
    }
}

private struct CitySearchRow: View{
    let city: City
    @ObservedObject var city_vm: CityViewModel
    @Binding var should_close: Bool
    
    var body: some View{
        Button{
            if city_vm.saved_cities != nil {
                city_vm.saved_cities!.append(city)
            } else {
                city_vm.saved_cities = [city]
            }
            should_close = true
            city_vm.new_sity_added = true
        } label: {
            HStack(spacing: 12) {
                Text("\(city.name),")
                Text(city.country)
            }
            .bold()
            .foregroundStyle(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 8)
        }
    }
}
