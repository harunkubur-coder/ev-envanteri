import SwiftUI

struct SettingsView: View {
    @State private var iCloudMonitor = ICloudSyncMonitor()

    var body: some View {
        List {
            iCloudSection
            legalSection
            supportSection
            aboutSection
        }
        .scrollContentBackground(.hidden)
        .inventoryScreenBackground()
        .navigationTitle("Ayarlar")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await iCloudMonitor.refresh()
        }
        .refreshable {
            await iCloudMonitor.refresh()
        }
    }

    private var iCloudSection: some View {
        Section {
            HStack(alignment: .top, spacing: 14) {
                Image(systemName: iCloudMonitor.status.icon)
                    .font(.title2)
                    .foregroundStyle(iCloudMonitor.status.tint)
                    .frame(width: 32)

                VStack(alignment: .leading, spacing: 6) {
                    Text(iCloudMonitor.status.title)
                        .font(.headline)

                    Text(iCloudMonitor.status.detail)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(.vertical, 4)

            Button("Durumu yenile") {
                Task { await iCloudMonitor.refresh() }
            }
        } header: {
            Text("iCloud Senkronizasyonu")
        } footer: {
            if ModelContainerFactory.usesCloudKit {
                Text("Üyelik gerekmez. Apple ID ile iCloud'a giriş yapmanız yeterlidir. Verileriniz yalnızca sizin iCloud hesabınızda saklanır.")
            } else {
                Text("iCloud şu an devre dışı; veriler yalnızca bu cihazda saklanıyor. Apple Developer hesabında iCloud container tanımlandığında senkron otomatik açılır.")
            }
        }
    }

    private var legalSection: some View {
        Section("Yasal") {
            NavigationLink {
                PrivacyPolicyView()
            } label: {
                Label("Gizlilik Politikası", systemImage: "hand.raised.fill")
            }
        }
    }

    private var supportSection: some View {
        Section("Destek") {
            if let mailURL = AppInfo.supportMailURL {
                Link(destination: mailURL) {
                    Label {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Bize ulaşın")
                            Text(AppInfo.supportEmail)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    } icon: {
                        Image(systemName: "envelope.fill")
                    }
                }
            }

            if let appStoreURL = AppInfo.appStoreURL {
                Link(destination: appStoreURL) {
                    Label("App Store'da değerlendir", systemImage: "star.fill")
                }
            }
        }
    }

    private var aboutSection: some View {
        Section("Uygulama") {
            HStack {
                Text("Sürüm")
                Spacer()
                Text(AppInfo.versionLabel)
                    .foregroundStyle(.secondary)
            }

            HStack {
                Text("Geliştirici")
                Spacer()
                Text("Ev Envanteri")
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
