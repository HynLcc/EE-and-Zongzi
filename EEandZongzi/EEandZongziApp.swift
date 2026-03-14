import SwiftUI
import SwiftData

@main
struct EEandZongziApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: WeightRecord.self)
    }
}
