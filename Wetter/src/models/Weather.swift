import SwiftUI
import Foundation

struct WeatherData: Codable, Equatable {
    let location: Location
    let current: Current
    let forecast: Forecast
}

struct Location: Codable, Equatable {
    let name: String
    let region: String
    let country: String
    let lat: Double
    let lon: Double
    let tz_id: String
    let localtime_epoch: Int
    let localtime: String
}

struct Condition: Codable{
    let text: String
}

struct Current: Codable, Equatable {
    let last_updated: Date
    let temp: Double
    let is_day: Int
    let condition: WeatherCondition
    let cloud: Int
    let feelslike: Double
    let weekday: Weekday

    enum CodingKeys: String, CodingKey {
        case last_updated
        case temp = "temp_c"
        case is_day, condition, cloud
        case feelslike = "feelslike_c"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.temp = try container.decode(Double.self, forKey: .temp)
        self.is_day = try container.decode(Int.self, forKey: .is_day)
        self.cloud = try container.decode(Int.self, forKey: .cloud)
        self.feelslike = try container.decode(Double.self, forKey: .feelslike)
        let decoded_condition: Condition = try container.decode(Condition.self, forKey: .condition)
        self.condition = WeatherCondition(rawValue: decoded_condition.text.trimmingCharacters(in: .whitespacesAndNewlines)) ?? .sunny
        let string_last_updated = try container.decode(String.self, forKey: .last_updated)

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")

        guard let date_last_updated = formatter.date(from: string_last_updated) else {
            throw DecodingError.dataCorruptedError(
                forKey: .last_updated,
                in: container,
                debugDescription: "Invalid date format: \(string_last_updated)"
            )
        }
        
        self.last_updated = date_last_updated

        let weekdayIndex = Calendar.current.component(.weekday, from: date_last_updated)

        switch weekdayIndex {
        case 1: self.weekday = .sun
        case 2: self.weekday = .mon
        case 3: self.weekday = .tue
        case 4: self.weekday = .wed
        case 5: self.weekday = .thu
        case 6: self.weekday = .fri
        case 7: self.weekday = .sat
        default:
            fatalError("Invalid weekday index")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(last_updated, forKey: .last_updated)
        try container.encode(temp, forKey: .temp)
        try container.encode(is_day, forKey: .is_day)
        try container.encode(condition, forKey: .condition)
        try container.encode(cloud, forKey: .cloud)
        try container.encode(feelslike, forKey: .feelslike)
    }
}

struct Forecast: Codable, Equatable {
    let forecastday: [ForecastDay]
}

struct ForecastDay: Codable, Equatable {
    let date: String
    let day: Day
    let weekday: Weekday

    enum CodingKeys: String, CodingKey {
        case date
        case day
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.date = try container.decode(String.self, forKey: .date)
        self.day = try container.decode(Day.self, forKey: .day)

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")

        guard let parsedDate = formatter.date(from: self.date) else {
            throw DecodingError.dataCorruptedError(
                forKey: .date,
                in: container,
                debugDescription: "Invalid date format: \(self.date)"
            )
        }

        let weekdayIndex = Calendar.current.component(.weekday, from: parsedDate)

        switch weekdayIndex {
        case 1: self.weekday = .sun
        case 2: self.weekday = .mon
        case 3: self.weekday = .tue
        case 4: self.weekday = .wed
        case 5: self.weekday = .thu
        case 6: self.weekday = .fri
        case 7: self.weekday = .sat
        default:
            fatalError("Invalid weekday index")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(day, forKey: .day)
    }
}

struct Day: Codable, Equatable {
    let maxtemp: Double
    let mintemp: Double
    let avgtemp: Double
    let daily_will_it_rain: Int
    let daily_will_it_snow: Int
    let condition: WeatherCondition
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.maxtemp = try container.decode(Double.self, forKey: .maxtemp)
        self.mintemp = try container.decode(Double.self, forKey: .mintemp)
        self.avgtemp = try container.decode(Double.self, forKey: .avgtemp)
        self.daily_will_it_rain = try container.decode(Int.self, forKey: .daily_will_it_rain)
        self.daily_will_it_snow = try container.decode(Int.self, forKey: .daily_will_it_snow)
        let decoded_condition = try container.decode(Condition.self, forKey: .condition)
        self.condition = WeatherCondition(rawValue: decoded_condition.text.trimmingCharacters(in: .whitespacesAndNewlines)) ?? .sunny
    }

    enum CodingKeys: String, CodingKey {
        case maxtemp = "maxtemp_c"
        case mintemp = "mintemp_c"
        case avgtemp = "avgtemp_c"
        case daily_will_it_rain, daily_will_it_snow, condition
    }
}

enum WeatherCondition: String, CaseIterable, Codable, Equatable{
    case sunny = "Sunny"
    case clear = "Clear"
    case partlyCloudy = "Partly Cloudy"
    case cloudy = "Cloudy"
    case overcast = "Overcast"
    case mist = "Mist"
    case patchyRainPossible = "Patchy rain possible"
    case patchySnowPossible = "Patchy snow possible"
    case patchySleetPossible = "Patchy sleet possible"
    case patchyFreezingDrizzlePossible = "Patchy freezing drizzle possible"
    case thunderyOutbreaksPossible = "Thundery outbreaks possible"
    case blowingSnow = "Blowing snow"
    case blizzard = "Blizzard"
    case fog = "Fog"
    case freezingFog = "Freezing fog"
    case patchyLightDrizzle = "Patchy light drizzle"
    case lightDrizzle = "Light drizzle"
    case freezingDrizzle = "Freezing drizzle"
    case heavyFreezingDrizzle = "Heavy freezing drizzle"
    case patchyLightRain = "Patchy light rain"
    case lightRain = "Light rain"
    case moderateRainAtTimes = "Moderate rain at times"
    case moderateRain = "Moderate rain"
    case heavyRainAtTimes = "Heavy rain at times"
    case heavyRain = "Heavy rain"
    case lightFreezingRain = "Light freezing rain"
    case moderateOrHeavyFreezingRain = "Moderate or heavy freezing rain"
    case lightSleet = "Light sleet"
    case moderateOrHeavySleet = "Moderate or heavy sleet"
    case patchyLightSnow = "Patchy light snow"
    case lightSnow = "Light snow"
    case patchyModerateSnow = "Patchy moderate snow"
    case moderateSnow = "Moderate snow"
    case patchyHeavySnow = "Patchy heavy snow"
    case heavySnow = "Heavy snow"
    case icePellets = "Ice pellets"
    case lightRainShower = "Light rain shower"
    case moderateOrHeavyRainShower = "Moderate or heavy rain shower"
    case torrentialRainShower = "Torrential rain shower"
    case lightSleetShowers = "Light sleet showers"
    case moderateOrHeavySleetShowers = "Moderate or heavy sleet showers"
    case lightSnowShowers = "Light snow showers"
    case moderateOrHeavySnowShowers = "Moderate or heavy snow showers"
    case lightShowersOfIcePellets = "Light showers of ice pellets"
    case moderateOrHeavyShowersOfIcePellets = "Moderate or heavy showers of ice pellets"
    case patchyLightRainWithThunder = "Patchy light rain with thunder"
    case moderateOrHeavyRainWithThunder = "Moderate or heavy rain with thunder"
    case patchyLightSnowWithThunder = "Patchy light snow with thunder"
    case moderateOrHeavySnowWithThunder = "Moderate or heavy snow with thunder"
    case patchyRainNearby = "Patchy rain nearby"
}

enum Weekday: String {
    case mon = "Monday"
    case tue = "Tuesday"
    case wed = "Wednesday"
    case thu = "Thursday"
    case fri = "Friday"
    case sat = "Saturday"
    case sun = "Sunday"

    static func from(_ date: Date) -> Weekday {
        let index = Calendar.current.component(.weekday, from: date)
        switch index {
        case 1: return .sun
        case 2: return .mon
        case 3: return .tue
        case 4: return .wed
        case 5: return .thu
        case 6: return .fri
        case 7: return .sat
        default:
            fatalError("Invalid weekday index")
        }
    }
}
