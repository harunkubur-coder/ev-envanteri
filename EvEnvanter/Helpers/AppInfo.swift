import Foundation

enum AppInfo {
    static let name = "Ev Envanteri"
    static let bundleIdentifier = "com.evenvanter.app"
    static let iCloudContainer = "iCloud.com.evenvanter.app"
    static let supportEmail = "kuburharun@gmail.com"
    /// App Store yayınından sonra App Store Connect'teki uygulama URL'sini buraya ekleyin.
    static let appStoreURL: URL? = nil

    static var version: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.1"
    }

    static var build: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }

    static var versionLabel: String {
        "Sürüm \(version) (\(build))"
    }

    static var supportMailURL: URL? {
        var components = URLComponents()
        components.scheme = "mailto"
        components.path = supportEmail
        components.queryItems = [
            URLQueryItem(name: "subject", value: "\(name) Destek")
        ]
        return components.url
    }
}
