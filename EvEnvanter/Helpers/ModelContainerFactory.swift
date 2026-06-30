import SwiftData
import Foundation

enum ModelContainerFactory {
    private(set) static var usesCloudKit = false

    static func create() throws -> ModelContainer {
        let schema = Schema([InventoryItem.self])

        do {
            let cloudConfiguration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false,
                cloudKitDatabase: .private(AppInfo.iCloudContainer)
            )
            let container = try ModelContainer(for: schema, configurations: [cloudConfiguration])
            usesCloudKit = true
            return container
        } catch {
            print("iCloud veritabanı başlatılamadı, yerel moda geçiliyor: \(error.localizedDescription)")

            let localConfiguration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false,
                cloudKitDatabase: .none
            )
            let container = try ModelContainer(for: schema, configurations: [localConfiguration])
            usesCloudKit = false
            return container
        }
    }
}
