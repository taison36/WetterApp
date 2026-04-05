import SwiftUI

struct ForecastLoadingView: View {
    var body: some View {
        VStack(spacing: 12) {

            // Title
            HStack {
                BreathingPlaceholder(cornerRadius: 10)
                    .frame(width: 90, height: 22)
                Spacer()
            }

            VStack(spacing: 10) {
                ForEach(0..<3, id: \.self) { _ in
                    ForecastDayRowLoading()
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(Color.black.opacity(0.25))
        )
    }
}

struct ForecastDayRowLoading: View {
    var body: some View {
        HStack(spacing: 12) {

            // Day
            BreathingPlaceholder(cornerRadius: 8)
                .frame(width: 36, height: 18)

            // Icon
            BreathingPlaceholder(cornerRadius: 6)
                .frame(width: 32, height: 32)

            // Temps
            HStack(spacing: 12) {
                BreathingPlaceholder(cornerRadius: 8)
                    .frame(width: 60, height: 18)
                BreathingPlaceholder(cornerRadius: 8)
                    .frame(width: 60, height: 18)
                BreathingPlaceholder(cornerRadius: 8)
                    .frame(width: 60, height: 18)
            }

            Spacer()
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.black.opacity(0.15))
        )
    }
}
