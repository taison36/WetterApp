import SwiftUI

struct CurrentDayView: View {
    let location: Location
    let current: Current
    var body: some View {
        ZStack {
             VStack(spacing: 16) {
                 getImageOfWeatherCondition(
                     weather_condition: current.condition,
                     is_day: current.is_day == 1
                 )
                 .resizable()
                 .scaledToFit()
                 .frame(maxHeight: UIScreen.main.bounds.height * 0.20)

                 Text("\(Int(current.temp))°C")
                     .font(.system(size: 60, weight: .bold))
                     .foregroundColor(.white)

                 Text(current.condition.rawValue)
                     .font(.title3)
                     .foregroundColor(.white.opacity(0.8))
                 

                 Text("Feels like \(Int(current.temp))°C")
                     .font(.title3)
                     .foregroundColor(.white.opacity(0.8))
                 
                 Text("\(location.name), \(location.country)")
                     .font(.system(size: 20))
                     .bold()
                     .foregroundColor(.white)

                 Text("\(current.weekday.rawValue), \(location.localtime)")
                     .font(.subheadline)
                     .foregroundColor(.white.opacity(0.7))
             }
        }.frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .maximum(300,400),
            alignment: .center
          )
        
    }
}
