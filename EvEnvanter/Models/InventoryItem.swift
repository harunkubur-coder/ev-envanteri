import Foundation
import SwiftData

@Model
final class InventoryItem {
    var id: UUID = UUID()
    var name: String = ""
    var category: String = "Diğer"
    var location: String = ""
    var purchaseDate: Date?
    var warrantyExpiryDate: Date?
    var notes: String = ""
    @Attribute(.externalStorage) var photoData: Data?
    var createdAt: Date = Date()

    init(
        name: String,
        category: String,
        location: String,
        purchaseDate: Date? = nil,
        warrantyExpiryDate: Date? = nil,
        notes: String = "",
        photoData: Data? = nil
    ) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.location = location
        self.purchaseDate = purchaseDate
        self.warrantyExpiryDate = warrantyExpiryDate
        self.notes = notes
        self.photoData = photoData
        self.createdAt = Date()
    }

    var warrantyStatus: WarrantyStatus {
        guard let expiry = warrantyExpiryDate else { return .none }
        let days = Calendar.current.dateComponents([.day], from: Date(), to: expiry).day ?? 0
        if days < 0 { return .expired }
        if days <= 30 { return .expiringSoon(days: days) }
        return .valid
    }
}

enum WarrantyStatus: Equatable {
    case none
    case valid
    case expiringSoon(days: Int)
    case expired

    var label: String {
        switch self {
        case .none: return "Garanti yok"
        case .valid: return "Garanti geçerli"
        case .expiringSoon(let days): return "\(days) gün kaldı"
        case .expired: return "Garanti bitti"
        }
    }

    var isWarning: Bool {
        switch self {
        case .expiringSoon, .expired: return true
        default: return false
        }
    }
}
