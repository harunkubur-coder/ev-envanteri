# Ev Envanteri — App Store Metinleri

Aşağıdaki metinleri App Store Connect'e kopyala-yapıştır yapabilirsin.

---

## Uygulama adı (App Name)
```
Ev Envanteri
```

## Alt başlık (Subtitle — max 30 karakter)
```
Eşyalarını akıllıca takip et
```

## Tanıtım metni (Description)

```
Ev Envanteri ile evindeki tüm eşyaları tek yerden yönet.

Nereye koyduğun eşyaları unutma. HDMI kablon nerede? Matkap hangi dolapta? Garantisi ne zaman bitiyor? Hepsinin cevabı cebinde.

ÖNE ÇIKAN ÖZELLİKLER
• Eşya ekle: ad, kategori, konum, not
• Fotoğraf ekle: eşyayı görsel olarak kaydet
• Garanti takibi: bitiş tarihini kaydet, yaklaşanları gör
• Akıllı arama: isim, konum ve notlarda ara
• Kategori filtreleri: Elektronik, Mobilya, Mutfak ve daha fazlası
• iCloud senkron: aynı Apple ID ile tüm cihazlarında senkron

GİZLİLİK
• Hesap oluşturman gerekmez
• Reklam yok, izleme yok
• Verilerin cihazında ve iCloud hesabında kalır
• Verilerin üçüncü taraflarla paylaşılmaz

Kimler için?
• Ev eşyalarını düzenli tutmak isteyenler
• Taşınma / tadilat öncesi envanter çıkaranlar
• Garanti sürelerini takip etmek isteyenler
• Depo, garaj ve dolaplardaki eşyaları kaybetmek istemeyenler

Ev Envanteri — evin düzenli, zihnin rahat.
```

## Anahtar kelimeler (Keywords — max 100 karakter, virgülle ayır)

```
envanter,ev,eşya,takip,garanti,konum,depo,organize,envanter listesi,ev eşyası,dolap
```

## Promosyon metni (Promotional Text — isteğe bağlı)

```
Evdeki eşyalarını kaydet, nerede olduklarını bul, garantilerini kaçırma. iCloud ile tüm cihazlarında senkron.
```

## Destek URL (Support URL)
GitHub Pages ile yayınlandığında:
```
https://harunkubur.github.io/ev-envanteri/destek.html
```

## Gizlilik politikası URL (Privacy Policy URL) — ZORUNLU
App Store Connect bu alanı zorunlu tutar. `docs/gizlilik.html` dosyası hazır. GitHub Pages'e yükledikten sonra:
```
https://harunkubur.github.io/ev-envanteri/gizlilik.html
```

Uygulama içinde de aynı metin Ayarlar → Gizlilik Politikası'nda mevcuttur.

---

## Gizlilik metni (Web sayfasına yapıştır)

Son güncelleme: 30 Haziran 2026

### Giriş
Ev Envanteri ("uygulama"), evinizdeki eşyaları kaydetmenize, konumlarını takip etmenize ve garanti tarihlerini yönetmenize yardımcı olur. Gizliliğinize saygı duyuyoruz.

### Toplanan veriler
Uygulamaya girdiğiniz bilgiler cihazınızda (ve iCloud açıksa iCloud hesabınızda) saklanır: eşya adı, kategori, konum, tarihler, notlar ve isteğe bağlı fotoğraflar. Ayrı hesap oluşturmanız gerekmez. Ad, e-posta veya telefon numarası toplamayız.

### Verilerin kullanımı
Verileriniz yalnızca uygulamanın çalışması için kullanılır. Reklam profili oluşturmak veya üçüncü taraflara satmak için kullanmayız.

### iCloud senkronizasyonu
Apple ID ile iCloud'a giriş yaptıysanız verileriniz cihazlarınız arasında senkronize edilebilir. Bu işlem Apple'ın iCloud altyapısı üzerinden gerçekleşir.

### Fotoğraf erişimi
Fotoğraf eklemek için galeri/kamera izni istenir. Fotoğraflar yalnızca sizin cihazınızda ve iCloud'unuzda saklanır.

### Veri silme
Eşyayı uygulama içinden sildiğinizde kayıt kalıcı olarak kaldırılır. Uygulamayı silerseniz cihazdaki veriler de silinir.

### Üçüncü taraflar
Analitik, reklam veya izleme SDK'ları kullanılmaz.

### İletişim
kuburharun@gmail.com

---

## App Store Connect — Gizlilik anketi (App Privacy)

Aşağıdaki gibi doldur:

| Soru | Cevap |
|------|-------|
| Veri topluyor musunuz? | Hayır (veya "Evet" → sadece cihazda, sen toplamıyorsun) |
| Üçüncü tarafa veri | Hayır |
| Reklam | Hayır |
| Analitik | Hayır |
| Konum | Hayır |
| Kişisel bilgi | Hayır |
| Fotoğraf | Kullanıcı cihazında kalır, sunucuya gönderilmez |

Not: Apple bazen "Data Not Collected" seçeneğini sunar — uygulama veriyi sadece cihaz/iCloud'da tuttuğu için bu en uygun seçenek.

---

## Sürüm notları (What's New) — v1.1

```
• iCloud senkronizasyonu: envanteriniz tüm Apple cihazlarınızda güncel kalır
• Ayarlar ekranı eklendi
• Gizlilik politikası eklendi
• Arayüz iyileştirmeleri
```

## Sürüm notları — v1.0 (ilk yayın)

```
• Ev envanteri oluşturma ve düzenleme
• Kategori ve konum takibi
• Garanti tarihi hatırlatıcıları
• Fotoğraf ekleme
• Arama ve filtreleme
```

---

## Ekran görüntüsü başlıkları (Screenshot captions — isteğe bağlı)

1. Tüm eşyalarını tek ekranda gör
2. Kategori ve konum ile filtrele
3. Garanti tarihlerini takip et
4. Fotoğraf ekle, detayları kaydet
5. iCloud ile cihazlar arası senkron

---

## Apple Developer — iCloud kurulumu (senin yapman gerekenler)

1. [developer.apple.com](https://developer.apple.com) → Certificates, Identifiers & Profiles
2. **Identifiers** → `com.evenvanter.app` → iCloud → Enable
3. CloudKit container: `iCloud.com.evenvanter.app` oluştur
4. Xcode → EvEnvanter target → **Signing & Capabilities** → **+ Capability** → **iCloud** → CloudKit işaretle
5. Container olarak `iCloud.com.evenvanter.app` seç

---

## Yayın checklist

- [ ] Apple Developer Program ($99/yıl)
- [ ] App Store Connect'te uygulama oluştur
- [ ] Bundle ID: com.evenvanter.app
- [ ] iCloud container aktif
- [ ] Gizlilik politikası web URL'si
- [ ] Ekran görüntüleri (6.7" iPhone)
- [ ] App Icon 1024x1024
- [ ] Xcode Archive → Upload
- [ ] App Store Connect'te "Submit for Review"
