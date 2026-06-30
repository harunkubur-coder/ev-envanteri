import SwiftUI

enum InventoryTheme {
    static let cardRadius: CGFloat = 18
    static let thumbnailSize: CGFloat = 64

    static let accent = Color(red: 0.42, green: 0.34, blue: 0.92)
    static let accentSecondary = Color(red: 0.20, green: 0.62, blue: 0.92)

    static func categoryIcon(_ category: String) -> String {
        switch category {
        case "Elektronik": return "laptopcomputer"
        case "Mobilya": return "sofa.fill"
        case "Mutfak": return "fork.knife"
        case "Alet & Hırdavat": return "wrench.and.screwdriver.fill"
        case "Kıyafet": return "tshirt.fill"
        case "Belge": return "doc.text.fill"
        default: return "shippingbox.fill"
        }
    }

    static func categoryColor(_ category: String) -> Color {
        switch category {
        case "Elektronik": return Color(red: 0.25, green: 0.47, blue: 0.96)
        case "Mobilya": return Color(red: 0.58, green: 0.40, blue: 0.86)
        case "Mutfak": return Color(red: 0.96, green: 0.55, blue: 0.20)
        case "Alet & Hırdavat": return Color(red: 0.35, green: 0.72, blue: 0.45)
        case "Kıyafet": return Color(red: 0.93, green: 0.35, blue: 0.55)
        case "Belge": return Color(red: 0.45, green: 0.62, blue: 0.78)
        default: return Color(red: 0.50, green: 0.52, blue: 0.58)
        }
    }

    static func warrantyColor(_ status: WarrantyStatus) -> Color {
        switch status {
        case .expired: return .red
        case .expiringSoon: return .orange
        case .valid: return .green
        case .none: return .secondary
        }
    }
}

struct InventoryBackground: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ZStack {
            if colorScheme == .dark {
                LinearGradient(
                    colors: [
                        Color(red: 0.08, green: 0.09, blue: 0.18),
                        Color(red: 0.10, green: 0.12, blue: 0.22),
                        Color(red: 0.07, green: 0.14, blue: 0.16)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                Circle()
                    .fill(InventoryTheme.accent.opacity(0.22))
                    .frame(width: 320, height: 320)
                    .blur(radius: 8)
                    .offset(x: -140, y: -260)

                Circle()
                    .fill(Color.teal.opacity(0.16))
                    .frame(width: 280, height: 280)
                    .blur(radius: 6)
                    .offset(x: 160, y: 320)

                Circle()
                    .fill(Color.orange.opacity(0.10))
                    .frame(width: 220, height: 220)
                    .blur(radius: 4)
                    .offset(x: -80, y: 420)
            } else {
                LinearGradient(
                    colors: [
                        Color(red: 0.93, green: 0.94, blue: 1.00),
                        Color(red: 0.96, green: 0.92, blue: 0.99),
                        Color(red: 0.92, green: 0.97, blue: 0.95)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                Circle()
                    .fill(InventoryTheme.accent.opacity(0.16))
                    .frame(width: 340, height: 340)
                    .offset(x: -150, y: -240)

                Circle()
                    .fill(Color.cyan.opacity(0.14))
                    .frame(width: 300, height: 300)
                    .offset(x: 170, y: 280)

                Circle()
                    .fill(Color.orange.opacity(0.12))
                    .frame(width: 240, height: 240)
                    .offset(x: -60, y: 460)
            }
        }
        .ignoresSafeArea()
    }
}

struct InventoryCardBackground: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme

    func body(content: Content) -> some View {
        content
            .background {
                RoundedRectangle(cornerRadius: InventoryTheme.cardRadius, style: .continuous)
                    .fill(cardFill)
                    .overlay {
                        RoundedRectangle(cornerRadius: InventoryTheme.cardRadius, style: .continuous)
                            .strokeBorder(strokeColor, lineWidth: 1)
                    }
                    .shadow(color: shadowColor, radius: 12, y: 5)
            }
    }

    private var cardFill: AnyShapeStyle {
        if colorScheme == .dark {
            AnyShapeStyle(Color.white.opacity(0.08))
        } else {
            AnyShapeStyle(Color.white.opacity(0.82))
        }
    }

    private var strokeColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.10) : Color.white.opacity(0.65)
    }

    private var shadowColor: Color {
        colorScheme == .dark ? .black.opacity(0.25) : InventoryTheme.accent.opacity(0.10)
    }
}

extension View {
    func inventoryScreenBackground() -> some View {
        background {
            InventoryBackground()
        }
    }

    func inventoryCard() -> some View {
        modifier(InventoryCardBackground())
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(width: 34, height: 34)
                    .background(
                        LinearGradient(
                            colors: [tint, tint.opacity(0.75)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        in: Circle()
                    )
                Spacer()
            }

            Text(value)
                .font(.title2.weight(.bold))
                .foregroundStyle(.primary)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .inventoryCard()
        .overlay(alignment: .leading) {
            RoundedRectangle(cornerRadius: 3, style: .continuous)
                .fill(tint)
                .frame(width: 4)
                .padding(.vertical, 12)
        }
    }
}

struct CategoryFilterChip: View {
    let title: String
    let icon: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption.weight(.semibold))
                Text(title)
                    .font(.subheadline.weight(.semibold))
            }
            .foregroundStyle(isSelected ? .white : color)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background {
                Capsule(style: .continuous)
                    .fill(
                        isSelected
                            ? AnyShapeStyle(LinearGradient(colors: [color, color.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing))
                            : AnyShapeStyle(color.opacity(0.14))
                    )
            }
            .shadow(color: isSelected ? color.opacity(0.28) : .clear, radius: 8, y: 3)
        }
        .buttonStyle(.plain)
    }
}

struct CategoryBadge: View {
    let category: String

    var body: some View {
        let color = InventoryTheme.categoryColor(category)
        HStack(spacing: 5) {
            Image(systemName: InventoryTheme.categoryIcon(category))
                .font(.caption2.weight(.bold))
            Text(category)
                .font(.caption.weight(.semibold))
        }
        .foregroundStyle(color)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(color.opacity(0.14), in: Capsule(style: .continuous))
    }
}

struct WarrantyBadge: View {
    let status: WarrantyStatus

    var body: some View {
        let color = InventoryTheme.warrantyColor(status)
        HStack(spacing: 4) {
            Image(systemName: status == .expired ? "xmark.shield.fill" : "exclamationmark.shield.fill")
                .font(.caption2)
            Text(status.label)
                .font(.caption2.weight(.semibold))
        }
        .foregroundStyle(color)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(color.opacity(0.12), in: Capsule(style: .continuous))
    }
}

struct ItemThumbnail: View {
    let photoData: Data?
    let category: String
    var size: CGFloat = InventoryTheme.thumbnailSize

    var body: some View {
        let color = InventoryTheme.categoryColor(category)

        Group {
            if let photoData, let uiImage = UIImage(data: photoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                ZStack {
                    LinearGradient(
                        colors: [color.opacity(0.25), color.opacity(0.08)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    Image(systemName: InventoryTheme.categoryIcon(category))
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(color)
                }
            }
        }
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .strokeBorder(color.opacity(0.15), lineWidth: 1)
        }
    }
}

struct SectionHeader: View {
    let title: String
    let icon: String

    var body: some View {
        Label(title, systemImage: icon)
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.secondary)
            .textCase(nil)
    }
}

struct BackButton: View {
    @Environment(\.dismiss) private var dismiss
    var title: String = "Geri"

    var body: some View {
        Button {
            dismiss()
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "chevron.left")
                    .font(.body.weight(.semibold))
                Text(title)
                    .font(.body.weight(.medium))
            }
        }
    }
}

struct AppBrandLogo: View {
    var iconSize: CGFloat = 44
    var layout: LogoLayout = .horizontal

    enum LogoLayout {
        case horizontal
        case stacked
    }

    var body: some View {
        Group {
            switch layout {
            case .horizontal:
                HStack(spacing: iconSize * 0.28) {
                    AppMarkIcon(size: iconSize)
                    logoText(compact: true)
                }
            case .stacked:
                VStack(spacing: iconSize * 0.35) {
                    AppMarkIcon(size: iconSize * 1.35)
                    logoText(compact: false)
                }
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Ev Envanteri")
    }

    @ViewBuilder
    private func logoText(compact: Bool) -> some View {
        if compact {
            HStack(spacing: 6) {
                Text("Ev")
                    .font(.system(size: iconSize * 0.48, weight: .bold, design: .rounded))
                    .foregroundStyle(logoGradient)
                Text("Envanteri")
                    .font(.system(size: iconSize * 0.48, weight: .semibold, design: .rounded))
                    .foregroundStyle(.primary)
            }
        } else {
            VStack(spacing: 4) {
                HStack(spacing: 6) {
                    Text("Ev")
                        .font(.system(size: iconSize * 0.62, weight: .bold, design: .rounded))
                        .foregroundStyle(logoGradient)
                    Text("Envanteri")
                        .font(.system(size: iconSize * 0.62, weight: .semibold, design: .rounded))
                        .foregroundStyle(.primary)
                }

                Text("Akıllı ev envanteri")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var logoGradient: LinearGradient {
        LinearGradient(
            colors: [InventoryTheme.accent, InventoryTheme.accentSecondary],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

struct AppMarkIcon: View {
    var size: CGFloat = 44

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.24, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [InventoryTheme.accent, InventoryTheme.accentSecondary],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            RoundedRectangle(cornerRadius: size * 0.24, style: .continuous)
                .strokeBorder(Color.white.opacity(0.22), lineWidth: 1)

            ZStack {
                Image(systemName: "house.fill")
                    .font(.system(size: size * 0.34, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.95))
                    .offset(y: -size * 0.05)

                Image(systemName: "shippingbox.fill")
                    .font(.system(size: size * 0.20, weight: .bold))
                    .foregroundStyle(.white)
                    .offset(y: size * 0.14)
            }
        }
        .frame(width: size, height: size)
        .shadow(color: InventoryTheme.accent.opacity(0.32), radius: size * 0.14, y: size * 0.07)
        .accessibilityLabel("Ev Envanteri simgesi")
    }
}

/// Geriye dönük kullanım için AppMark adı korundu.
struct AppMark: View {
    var size: CGFloat = 88

    var body: some View {
        AppMarkIcon(size: size)
    }
}
