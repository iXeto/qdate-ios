import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 1.0, green: 0.95, blue: 0.96),
                    Color(red: 0.93, green: 0.98, blue: 1.0)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Text("QDate")
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(red: 0.12, green: 0.08, blue: 0.10))

                Button("Placeholder Button") {}
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .tint(Color(red: 0.91, green: 0.20, blue: 0.38))
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
