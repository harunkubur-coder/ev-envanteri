import SwiftUI
import SwiftData
import PhotosUI

struct AddEditItemView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    var item: InventoryItem?

    @State private var name = ""
    @State private var category = InventoryOptions.categories[0]
    @State private var location = ""
    @State private var hasPurchaseDate = false
    @State private var purchaseDate = Date()
    @State private var hasWarrantyDate = false
    @State private var warrantyExpiryDate = Date()
    @State private var notes = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var photoData: Data?

    private var isEditing: Bool { item != nil }
    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty && !location.isEmpty
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    photoSection
                    detailsSection
                    locationSection
                    datesSection
                    notesSection
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .background(Color.clear)
            .inventoryScreenBackground()
            .navigationTitle(isEditing ? "Eşyayı Düzenle" : "Yeni Eşya")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    BackButton(title: "Geri")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Kaydet") { save() }
                        .fontWeight(.semibold)
                        .disabled(!canSave)
                }
            }
            .onAppear(perform: loadExistingItem)
            .onChange(of: selectedPhoto) { _, newValue in
                Task {
                    photoData = try? await newValue?.loadTransferable(type: Data.self)
                }
            }
        }
    }

    private var photoSection: some View {
        VStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                InventoryTheme.categoryColor(category).opacity(0.22),
                                InventoryTheme.categoryColor(category).opacity(0.06)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 180)

                if let photoData, let uiImage = UIImage(data: photoData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 180)
                        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                } else {
                    VStack(spacing: 10) {
                        ItemThumbnail(photoData: nil, category: category, size: 72)
                        Text("Fotoğraf ekle")
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .overlay(alignment: .bottomTrailing) {
                PhotosPicker(selection: $selectedPhoto, matching: .images) {
                    Label(photoData == nil ? "Ekle" : "Değiştir", systemImage: "camera.fill")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(.black.opacity(0.55), in: Capsule())
                }
                .padding(12)
            }

            if photoData != nil {
                Button("Fotoğrafı kaldır", role: .destructive) {
                    photoData = nil
                    selectedPhoto = nil
                }
                .font(.caption)
            }
        }
    }

    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: "Eşya bilgileri", icon: "info.circle.fill")

            VStack(spacing: 12) {
                TextField("Eşya adı", text: $name)
                    .font(.body)
                    .padding(14)
                    .background(inputFieldBackground)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Kategori")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)

                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 110), spacing: 10)], spacing: 10) {
                        ForEach(InventoryOptions.categories, id: \.self) { cat in
                            categoryButton(cat)
                        }
                    }
                }
            }
            .padding(16)
            .inventoryCard()
        }
    }

    private func categoryButton(_ cat: String) -> some View {
        let color = InventoryTheme.categoryColor(cat)
        let isSelected = category == cat

        return Button {
            category = cat
        } label: {
            VStack(spacing: 8) {
                Image(systemName: InventoryTheme.categoryIcon(cat))
                    .font(.title3)
                Text(cat)
                    .font(.caption.weight(.semibold))
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
            .foregroundStyle(isSelected ? .white : color)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(isSelected ? color : color.opacity(0.12))
            }
        }
        .buttonStyle(.plain)
    }

    private var locationSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: "Konum", icon: "mappin.circle.fill")

            VStack(spacing: 12) {
                TextField("Oda, dolap, kutu...", text: $location)
                    .padding(14)
                    .background(inputFieldBackground)

                FlowLayout(spacing: 8) {
                    ForEach(InventoryOptions.suggestedLocations, id: \.self) { suggestion in
                        Button(suggestion) {
                            location = suggestion
                        }
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(location == suggestion ? .white : .primary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background {
                            Capsule(style: .continuous)
                                .fill(
                                    location == suggestion
                                        ? AnyShapeStyle(LinearGradient(colors: [InventoryTheme.accent, InventoryTheme.accentSecondary], startPoint: .leading, endPoint: .trailing))
                                        : AnyShapeStyle(Color.white.opacity(0.55))
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(16)
            .inventoryCard()
        }
    }

    private var datesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: "Tarihler", icon: "calendar.circle.fill")

            VStack(spacing: 0) {
                Toggle(isOn: $hasPurchaseDate) {
                    Label("Satın alma tarihi", systemImage: "cart.fill")
                }
                .padding(16)

                if hasPurchaseDate {
                    Divider().padding(.leading, 16)
                    DatePicker("Tarih", selection: $purchaseDate, displayedComponents: .date)
                        .padding(16)
                }

                Divider()

                Toggle(isOn: $hasWarrantyDate) {
                    Label("Garanti bitiş tarihi", systemImage: "shield.lefthalf.filled")
                }
                .padding(16)

                if hasWarrantyDate {
                    Divider().padding(.leading, 16)
                    DatePicker("Bitiş", selection: $warrantyExpiryDate, displayedComponents: .date)
                        .padding(16)
                }
            }
            .inventoryCard()
        }
    }

    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: "Notlar", icon: "note.text")

            TextField("Seri no, marka, ek bilgi...", text: $notes, axis: .vertical)
                .lineLimit(4...8)
                .padding(16)
                .inventoryCard()
        }
    }

    private func loadExistingItem() {
        guard let item else { return }
        name = item.name
        category = item.category
        location = item.location
        notes = item.notes
        photoData = item.photoData
        if let purchaseDate = item.purchaseDate {
            hasPurchaseDate = true
            self.purchaseDate = purchaseDate
        }
        if let warrantyExpiryDate = item.warrantyExpiryDate {
            hasWarrantyDate = true
            self.warrantyExpiryDate = warrantyExpiryDate
        }
    }

    private func save() {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        let finalPurchaseDate = hasPurchaseDate ? purchaseDate : nil
        let finalWarrantyDate = hasWarrantyDate ? warrantyExpiryDate : nil

        if let item {
            item.name = trimmedName
            item.category = category
            item.location = location
            item.purchaseDate = finalPurchaseDate
            item.warrantyExpiryDate = finalWarrantyDate
            item.notes = notes
            item.photoData = photoData
        } else {
            let newItem = InventoryItem(
                name: trimmedName,
                category: category,
                location: location,
                purchaseDate: finalPurchaseDate,
                warrantyExpiryDate: finalWarrantyDate,
                notes: notes,
                photoData: photoData
            )
            modelContext.insert(newItem)
        }

        dismiss()
    }

    private var inputFieldBackground: some View {
        RoundedRectangle(cornerRadius: 14, style: .continuous)
            .fill(Color.white.opacity(0.55))
            .overlay {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(Color.white.opacity(0.7), lineWidth: 1)
            }
    }
}

private struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrange(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: proposal, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y), proposal: .unspecified)
        }
    }

    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            positions.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
        }

        return (CGSize(width: maxWidth, height: y + rowHeight), positions)
    }
}
