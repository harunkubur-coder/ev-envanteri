# Ev Envanteri

Evdeki eşyalarını kaydet, nerede olduklarını bul, garanti tarihlerini takip et.

## Özellikler

- Eşya ekleme: ad, kategori, konum, not
- Fotoğraf ekleme (galeriden)
- Satın alma ve garanti bitiş tarihi
- Arama (isim, konum, not)
- Kategoriye göre filtreleme
- Garantisi yaklaşan eşyalar için uyarı

## Gereksinimler

- macOS + Xcode 15+
- iOS 17+ (SwiftData kullanıyor)
- iPhone veya iPad simülatörü

## Kurulum

### 0. iOS Simülatörünü indir (önemli)

Xcode kurulu olsa bile simülatör ayrı indirilir (~8,5 GB). Simülatör yoksa uygulama çalışmaz.

**Xcode içinden:**
1. **Xcode → Settings** (veya `Cmd + ,`)
2. **Components** (veya **Platforms**) sekmesi
3. **iOS 26.5 Simulator** yanındaki indir butonuna tıkla
4. İndirme bitene kadar bekle

**Terminalden:**
```bash
xcodebuild -downloadPlatform iOS
```

Kontrol:
```bash
xcrun simctl list devices available
```
Listede iPhone cihazları görünmeli.

### 1. Xcode'u aktif et

Terminalde şu an Command Line Tools seçili olabilir. Tam Xcode için:

```bash
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
```

### 2. Projeyi aç

```bash
open /Users/harunkubur/Desktop/saas/EvEnvanter/EvEnvanter.xcodeproj
```

### 3. Signing ayarı

Xcode'da sol üstten **EvEnvanter** target'ını seç → **Signing & Capabilities** → kendi Apple ID'nle **Team** seç.

### 4. Çalıştır

Simülatör seç (ör. iPhone 16) → **Cmd + R**

## Proje yapısı

```
EvEnvanter/
├── EvEnvanterApp.swift      # Giriş noktası
├── Models/
│   ├── InventoryItem.swift  # SwiftData modeli
│   └── InventoryOptions.swift
└── Views/
    ├── ContentView.swift    # Ana liste
    ├── ItemRowView.swift
    ├── AddEditItemView.swift
    └── ItemDetailView.swift
```

## Sonraki adımlar (isteğe bağlı)

- [ ] iCloud sync
- [ ] Barkod / QR ile eşya ekleme
- [ ] Garanti bitiş bildirimleri (push notification)
- [ ] Kutu / raf hiyerarşisi (Salon → Dolap → Kutu 3)
- [ ] PDF dışa aktarma
