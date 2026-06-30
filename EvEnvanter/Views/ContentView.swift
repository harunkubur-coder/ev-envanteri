import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \InventoryItem.createdAt, order: .reverse) private var items: [InventoryItem]

    @State private var searchText = ""
    @State private var selectedCategory: String?
    @State private var showAddSheet = false

    private var filteredItems: [InventoryItem] {
        items.filter { item in
            let matchesSearch = searchText.isEmpty
                || item.name.localizedCaseInsensitiveContains(searchText)
                || item.location.localizedCaseInsensitiveContains(searchText)
                || item.notes.localizedCaseInsensitiveContains(searchText)

            let matchesCategory = selectedCategory == nil || item.category == selectedCategory
            return matchesSearch && matchesCategory
        }
    }

    private var expiringCount: Int {
        items.filter { $0.warrantyStatus.isWarning }.count
    }

    private var uniqueLocations: Int {
        Set(items.map(\.location)).count
    }

    private var hasActiveFilter: Bool {
        selectedCategory != nil || !searchText.isEmpty
    }

    private func clearFilters() {
        selectedCategory = nil
        searchText = ""
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                Group {
                    if items.isEmpty {
                        emptyState
                    } else {
                        itemList
                    }
                }

                if !items.isEmpty {
                    addButton
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                }
            }
            .inventoryScreenBackground()
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Eşya, konum veya not ara")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundStyle(InventoryTheme.accent)
                    }
                }

                if hasActiveFilter {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Temizle") {
                            clearFilters()
                        }
                        .fontWeight(.medium)
                    }
                }
            }
            .sheet(isPresented: $showAddSheet) {
                AddEditItemView()
                    .presentationDragIndicator(.visible)
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 28) {
            Spacer()

            AppBrandLogo(iconSize: 72, layout: .stacked)

            VStack(spacing: 8) {
                Text("Envanterin boş")
                    .font(.title2.weight(.bold))

                Text("Evdeki eşyalarını ekle, nerede olduklarını\nve garantilerini tek yerden takip et.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            Button {
                showAddSheet = true
            } label: {
                Label("İlk eşyayı ekle", systemImage: "plus.circle.fill")
                    .font(.headline)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 14)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)

            Spacer()
        }
        .padding(.horizontal, 32)
    }

    private var itemList: some View {
        ScrollView {
            VStack(spacing: 20) {
                AppBrandLogo(iconSize: 40, layout: .horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if hasActiveFilter {
                    activeFilterBanner
                }
                dashboardSection
                categoryFilters
                itemsSection
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 100)
        }
    }

    private var activeFilterBanner: some View {
        HStack(spacing: 10) {
            Image(systemName: "line.3.horizontal.decrease.circle.fill")
                .foregroundStyle(InventoryTheme.accent)

            VStack(alignment: .leading, spacing: 2) {
                Text("Filtre aktif")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                Text(activeFilterDescription)
                    .font(.subheadline.weight(.medium))
            }

            Spacer()

            Button("Kaldır") {
                clearFilters()
            }
            .font(.subheadline.weight(.semibold))
        }
        .padding(14)
        .background(InventoryTheme.accent.opacity(0.12), in: RoundedRectangle(cornerRadius: InventoryTheme.cardRadius, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: InventoryTheme.cardRadius, style: .continuous)
                .strokeBorder(InventoryTheme.accent.opacity(0.18), lineWidth: 1)
        }
    }

    private var activeFilterDescription: String {
        switch (selectedCategory, searchText.isEmpty) {
        case let (category?, true):
            return "Kategori: \(category)"
        case (nil, false):
            return "Arama: \"\(searchText)\""
        case let (category?, false):
            return "\(category) · \"\(searchText)\""
        default:
            return "Tüm eşyalar"
        }
    }

    private var dashboardSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Özet")
                .font(.headline)

            HStack(spacing: 12) {
                StatCard(
                    title: "Toplam eşya",
                    value: "\(items.count)",
                    icon: "shippingbox.fill",
                    tint: .blue
                )
                StatCard(
                    title: "Konum",
                    value: "\(uniqueLocations)",
                    icon: "mappin.circle.fill",
                    tint: .purple
                )
            }

            if expiringCount > 0 {
                HStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.orange)
                    Text("\(expiringCount) eşyanın garantisi yakında bitiyor veya bitti")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.primary)
                    Spacer()
                }
                .padding(14)
                .background(Color.orange.opacity(0.12), in: RoundedRectangle(cornerRadius: InventoryTheme.cardRadius, style: .continuous))
            }
        }
    }

    private var categoryFilters: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Kategoriler")
                .font(.headline)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    CategoryFilterChip(
                        title: "Tümü",
                        icon: "square.grid.2x2.fill",
                        color: .accentColor,
                        isSelected: selectedCategory == nil
                    ) {
                        selectedCategory = nil
                    }

                    ForEach(InventoryOptions.categories, id: \.self) { category in
                        CategoryFilterChip(
                            title: category,
                            icon: InventoryTheme.categoryIcon(category),
                            color: InventoryTheme.categoryColor(category),
                            isSelected: selectedCategory == category
                        ) {
                            selectedCategory = category
                        }
                    }
                }
                .padding(.horizontal, 2)
            }
        }
    }

    private var itemsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(selectedCategory ?? "Tüm eşyalar")
                    .font(.headline)
                Spacer()
                Text("\(filteredItems.count) adet")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            LazyVStack(spacing: 12) {
                if filteredItems.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "tray")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)

                        Text("Bu filtrede eşya yok")
                            .font(.headline)

                        Text(filteredEmptyMessage)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)

                        Button {
                            clearFilters()
                        } label: {
                            Text("Tüm eşyaları göster")
                                .font(.subheadline.weight(.semibold))
                                .padding(.horizontal, 18)
                                .padding(.vertical, 10)
                        }
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.capsule)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 32)
                } else {
                    ForEach(filteredItems, id: \.id) { item in
                    NavigationLink {
                        ItemDetailView(item: item)
                    } label: {
                        ItemRowView(item: item)
                    }
                    .buttonStyle(.plain)
                    .contextMenu {
                        Button(role: .destructive) {
                            modelContext.delete(item)
                        } label: {
                            Label("Sil", systemImage: "trash")
                        }
                    }
                    }
                }
            }
        }
    }

    private var filteredEmptyMessage: String {
        if let category = selectedCategory, !searchText.isEmpty {
            return "\"\(category)\" kategorisinde \"\(searchText)\" aramasına uygun eşya bulunamadı."
        }
        if let category = selectedCategory {
            return "\"\(category)\" kategorisinde henüz eşya yok. Eşya eklerken bu kategoriyi seç veya \"Tümü\"ne dön."
        }
        return "\"\(searchText)\" aramasına uygun eşya bulunamadı."
    }

    private var addButton: some View {
        Button {
            showAddSheet = true
        } label: {
            Image(systemName: "plus")
                .font(.title2.weight(.semibold))
                .foregroundStyle(.white)
                .frame(width: 58, height: 58)
                .background {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [InventoryTheme.accent, InventoryTheme.accentSecondary],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: InventoryTheme.accent.opacity(0.4), radius: 12, y: 6)
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: InventoryItem.self, inMemory: true)
}
