import SwiftUI

struct ItemRowView: View {
    let item: InventoryItem

    var body: some View {
        HStack(spacing: 14) {
            ItemThumbnail(photoData: item.photoData, category: item.category)

            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top) {
                    Text(item.name)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .lineLimit(2)

                    Spacer(minLength: 8)

                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.tertiary)
                }

                HStack(spacing: 6) {
                    Label(item.location, systemImage: "mappin.and.ellipse")
                        .lineLimit(1)
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)

                HStack(spacing: 8) {
                    CategoryBadge(category: item.category)

                    if item.warrantyStatus.isWarning {
                        WarrantyBadge(status: item.warrantyStatus)
                    }
                }
            }
        }
        .padding(16)
        .inventoryCard()
    }
}
