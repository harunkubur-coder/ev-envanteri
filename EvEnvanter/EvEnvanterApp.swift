import SwiftUI
import SwiftData

@main
struct EvEnvanterApp: App {
    private let modelContainer: ModelContainer

    init() {
        do {
            modelContainer = try ModelContainerFactory.create()
        } catch {
            fatalError("Veritabanı başlatılamadı: \(error.localizedDescription)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .tint(InventoryTheme.accent)
        }
        .modelContainer(modelContainer)
    }
}
