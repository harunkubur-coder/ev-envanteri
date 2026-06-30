import SwiftUI

struct ItemDetailView: View {
    @Bindable var item: InventoryItem
    @State private var showEditSheet = false

    private var categoryColor: Color {
        InventoryTheme.categoryColor(item.category)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                heroSection
                quickInfoGrid
                if item.warrantyExpiryDate != nil {
                    warrantyBanner
                }
                if !item.notes.isEmpty {
                    notesSection
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(Color.clear)
        .inventoryScreenBackground()
        .navigationTitle(item.name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButton(title: "Geri")
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showEditSheet = true
                } label: {
                    Text("Düzenle")
                        .fontWeight(.semibold)
                }
            }
        }
        .sheet(isPresented: $showEditSheet) {
            AddEditItemView(item: item)
                .presentationDragIndicator(.visible)
        }
    }

    private var heroSection: some View {
        ZStack(alignment: .bottomLeading) {
            Group {
                if let photoData = item.photoData, let uiImage = UIImage(data: photoData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                } else {
                    LinearGradient(
                        colors: [categoryColor.opacity(0.35), categoryColor.opacity(0.08)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .overlay {
                        Image(systemName: InventoryTheme.categoryIcon(item.category))
                            .font(.system(size: 56, weight: .semibold))
                            .foregroundStyle(categoryColor.opacity(0.7))
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 240)
            .clipped()

            LinearGradient(
                colors: [.clear, .black.opacity(0.55)],
                startPoint: .center,
                endPoint: .bottom
            )

            VStack(alignment: .leading, spacing: 8) {
                CategoryBadge(category: item.category)
                Text(item.name)
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.white)
            }
            .padding(18)
        }
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: .black.opacity(0.12), radius: 16, y: 8)
    }

    private var quickInfoGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            InfoTile(title: "Konum", value: item.location, icon: "mappin.and.ellipse", tint: .purple)
            InfoTile(
                title: "Satın alma",
                value: formattedDate(item.purchaseDate) ?? "—",
                icon: "calendar",
                tint: .blue
            )
            InfoTile(
                title: "Garanti bitiş",
                value: formattedDate(item.warrantyExpiryDate) ?? "—",
                icon: "shield.lefthalf.filled",
                tint: InventoryTheme.warrantyColor(item.warrantyStatus)
            )
            InfoTile(
                title: "Eklenme",
                value: item.createdAt.formatted(date: .abbreviated, time: .omitted),
                icon: "clock.fill",
                tint: .teal
            )
        }
    }

    private var warrantyBanner: some View {
        HStack(spacing: 12) {
            Image(systemName: item.warrantyStatus == .expired ? "xmark.shield.fill" : "checkmark.shield.fill")
                .font(.title3)
                .foregroundStyle(InventoryTheme.warrantyColor(item.warrantyStatus))

            VStack(alignment: .leading, spacing: 2) {
                Text("Garanti durumu")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(item.warrantyStatus.label)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(InventoryTheme.warrantyColor(item.warrantyStatus))
            }

            Spacer()
        }
        .padding(16)
        .background(InventoryTheme.warrantyColor(item.warrantyStatus).opacity(0.1), in: RoundedRectangle(cornerRadius: InventoryTheme.cardRadius, style: .continuous))
    }

    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: "Notlar", icon: "note.text")

            Text(item.notes)
                .font(.body)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .inventoryCard()
        }
    }

    private func formattedDate(_ date: Date?) -> String? {
        guard let date else { return nil }
        return date.formatted(date: .long, time: .omitted)
    }
}

private struct InfoTile: View {
    let title: String
    let value: String
    let icon: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: icon)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(tint)
                .frame(width: 32, height: 32)
                .background(tint.opacity(0.14), in: Circle())

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(value)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .inventoryCard()
    }
}
