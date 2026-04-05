import SwiftUI

struct BreathingPlaceholder: View {
    var cornerRadius: CGFloat = 12

    @State private var breathe = false

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [
                        Color.white.opacity(breathe ? 0.25 : 0.5),
                        Color.white.opacity(breathe ? 0.45 : 0.7)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .scaleEffect(breathe ? 0.94 : 1.02)
            .shadow(
                color: .black.opacity(breathe ? 0.10 : 0.25),
                radius: breathe ? 6 : 14
            )
            .animation(
                .easeInOut(duration: 1.1)
                .repeatForever(autoreverses: true),
                value: breathe
            )
            .onAppear {
                breathe = true
            }
    }
}




struct CurrentDayLoadingView: View {
    var body: some View {
        VStack(spacing: 16) {

            // Weather icon
            BreathingPlaceholder(cornerRadius: 30)
                .frame(width: 160, height: 110)

            // Temperature
            BreathingPlaceholder(cornerRadius: 16)
                .frame(width: 140, height: 64)

            // Condition
            BreathingPlaceholder(cornerRadius: 10)
                .frame(width: 120, height: 22)

            // Feels like
            BreathingPlaceholder(cornerRadius: 10)
                .frame(width: 160, height: 22)

            // City
            BreathingPlaceholder(cornerRadius: 12)
                .frame(width: 200, height: 26)

            // Date
            BreathingPlaceholder(cornerRadius: 10)
                .frame(width: 220, height: 18)
        }
        .padding(.top, 20)
        .frame(
            maxWidth: .infinity,
            maxHeight: .maximum(300, 400)
        )
    }
}
