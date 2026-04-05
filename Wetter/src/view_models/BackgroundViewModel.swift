import SwiftUI

@Observable
class BackgroundViewModel {
    let darkBlue = Color(red: 0, green: 0.1, blue: 0.55)
    let skyBlue = Color(red: 0.4627, green: 0.8392, blue: 1.0)
    var app_background: [Color] = [Color(red: 0, green: 0.1, blue: 0.55).opacity(0.8), Color(red: 0.4627, green: 0.8392, blue: 1.0).opacity(0.6)]
}
