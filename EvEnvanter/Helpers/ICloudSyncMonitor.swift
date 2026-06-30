import CloudKit
import SwiftUI

@MainActor
@Observable
final class ICloudSyncMonitor {
    enum Status: Equatable {
        case checking
        case available
        case noAccount
        case restricted
        case temporarilyUnavailable
        case unknown

        var title: String {
            switch self {
            case .checking: return "Kontrol ediliyor..."
            case .available: return "iCloud aktif"
            case .noAccount: return "iCloud hesabı yok"
            case .restricted: return "iCloud kısıtlı"
            case .temporarilyUnavailable: return "Geçici olarak kullanılamıyor"
            case .unknown: return "Durum bilinmiyor"
            }
        }

        var detail: String {
            switch self {
            case .checking:
                return "iCloud durumu kontrol ediliyor."
            case .available:
                return "Envanteriniz aynı Apple ID ile giriş yaptığınız cihazlar arasında senkronize edilir."
            case .noAccount:
                return "Ayarlar → Apple ID → iCloud bölümünden oturum açın."
            case .restricted:
                return "Bu cihazda iCloud erişimi kısıtlanmış olabilir."
            case .temporarilyUnavailable:
                return "Bir süre sonra tekrar deneyin veya internet bağlantınızı kontrol edin."
            case .unknown:
                return "iCloud durumu şu an doğrulanamadı."
            }
        }

        var icon: String {
            switch self {
            case .checking: return "arrow.triangle.2.circlepath"
            case .available: return "icloud.fill"
            case .noAccount: return "icloud.slash"
            case .restricted: return "exclamationmark.icloud"
            case .temporarilyUnavailable: return "icloud.slash"
            case .unknown: return "questionmark.circle"
            }
        }

        var tint: Color {
            switch self {
            case .available: return .green
            case .checking: return .secondary
            case .noAccount, .restricted, .temporarilyUnavailable: return .orange
            case .unknown: return .secondary
            }
        }
    }

    var status: Status = .checking

    func refresh() async {
        status = .checking

        do {
            let accountStatus = try await CKContainer(identifier: AppInfo.iCloudContainer).accountStatus()
            switch accountStatus {
            case .available:
                status = .available
            case .noAccount:
                status = .noAccount
            case .restricted:
                status = .restricted
            case .temporarilyUnavailable:
                status = .temporarilyUnavailable
            case .couldNotDetermine:
                status = .unknown
            @unknown default:
                status = .unknown
            }
        } catch {
            status = .unknown
        }
    }
}
