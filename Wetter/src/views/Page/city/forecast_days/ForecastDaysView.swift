import SwiftUI

import SwiftUI

struct ForecastView: View {
    let forecast: Forecast
    var title: String = "Forecast"
    
    var body: some View {
        VStack(spacing: 12) {
            // Header
            HStack {
                Text(title)
                    .foregroundStyle(.white)
                    .bold()
                Spacer()
            }
            .padding(.top, 8)
            
            // Days list
            VStack(spacing: 8) {
                ForEach(forecast.forecastday, id: \.date) { day in
                    ForecastDayRow(day: day)
                        .background(Color.black.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .top)
        .background(
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(Color.black.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .stroke(Color.black, lineWidth: 1.5)
                )
        )
    }
}

private struct ForecastDayRow: View {
    let day: ForecastDay
    
    var body: some View {
        HStack(spacing: 12) {
            Text(day.weekday.rawValue.prefix(3))
                .bold()
                .foregroundStyle(.white)
                .frame(width: 40, alignment: .leading)
            
            getImageOfWeatherCondition(weather_condition: day.day.condition, is_day: true)
                .resizable()
                .scaledToFit()
                .frame(height: 32)
            
            HStack(spacing: 12) {
                Text("A: \(Int(day.day.avgtemp))°C")
                Text("H: \(Int(day.day.maxtemp))°C")
                Text("L: \(Int(day.day.mintemp))°C")
            }
            .foregroundStyle(.white)
            
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 8)
    }
}
