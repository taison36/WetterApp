import SwiftUI

func getImageOfWeatherCondition(weather_condition: WeatherCondition, is_day: Bool) -> Image {
    switch weather_condition {
        
    case .clear:
        return Image("night")
    case .sunny:
        return Image("sunny")

    case .partlyCloudy:
        return is_day ? Image("partly_cloudy") : Image("cloudy_night")
    case .cloudy, .overcast, .mist, .fog, .freezingFog:
        return is_day ? Image("cloud") : Image("cloudy_night")

    case .patchyRainPossible, .patchyRainNearby, .patchyLightRain, .lightRain, .lightRainShower, .moderateRainAtTimes, .moderateRain, .heavyRainAtTimes, .heavyRain, .torrentialRainShower:
        return is_day ? Image("sunny_rain") : Image("rain_night")
    case .patchyLightDrizzle, .lightDrizzle, .freezingDrizzle, .heavyFreezingDrizzle, .lightFreezingRain, .moderateOrHeavyFreezingRain:
        return is_day ? Image("sunny_rain") : Image("rain_night")
    case .moderateOrHeavyRainShower:
        return Image("sunny_rain")

    case .patchyLightRainWithThunder, .moderateOrHeavyRainWithThunder, .patchyLightSnowWithThunder, .moderateOrHeavySnowWithThunder, .thunderyOutbreaksPossible:
        return Image("thunder")

    case .patchySnowPossible, .patchySleetPossible, .patchyLightSnow, .lightSnow, .patchyModerateSnow, .moderateSnow, .patchyHeavySnow, .heavySnow, .blizzard, .icePellets, .lightSnowShowers, .moderateOrHeavySnowShowers, .lightSleet, .moderateOrHeavySleet, .lightSleetShowers, .moderateOrHeavySleetShowers, .lightShowersOfIcePellets, .moderateOrHeavyShowersOfIcePellets:
        return Image("light_snow")

    default:
        return is_day ? Image("sunny") : Image("cloudy_night")
    }
}
