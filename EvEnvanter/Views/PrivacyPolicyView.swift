import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    AppBrandLogo(iconSize: 36, layout: .horizontal)

                    Text("Son güncelleme: \(PrivacyPolicyText.lastUpdated)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                ForEach(PrivacyPolicyText.sections, id: \.title) { section in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(section.title)
                            .font(.headline)

                        Text(section.body)
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .inventoryCard()
                }
            }
            .padding(16)
            .padding(.bottom, 24)
        }
        .background(Color.clear)
        .inventoryScreenBackground()
        .navigationTitle("Gizlilik Politikası")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        PrivacyPolicyView()
    }
}
